import { Injectable, Inject, HttpException, HttpStatus } from '@nestjs/common';
import { google, sheets_v4 } from 'googleapis';
import envConfig from '../../config/env.config';
import { ConfigType } from '@nestjs/config';
import {
  ROW,
  DEFAULT_RANGE,
  SHEET_NOT_FOUND,
  GSHEETS_AUTH_URL,
  NO_DATA_IN_RANGE,
  GSHEETS_API_VERSION,
  DELETED_SUCCESSFULLY,
} from '../../constants';
import { ValidateGSheetsParams } from 'src/common/validators/gsheets_params.validator';
/**
 * Google Sheets Service to interact with Google Sheets API
 * CRUID operations - Create, Read, Update, Insert, Delete
 */
@Injectable()
export class GoogleSheetsService {
  private gsheets: sheets_v4.Sheets; 

  constructor(
    @Inject(envConfig.KEY) private env: ConfigType<typeof envConfig>,
  ) {
    const googlePrivateKey = process.env.GOOGLE_PRIVATE_KEY.replace(
      /\\n/g,
      '\n',
    );
    const googleClientEmail = process.env.CLIENT_EMAIL;
    this.authByServiceAccount(googleClientEmail, googlePrivateKey);
  }

  private authByServiceAccount(
    googleClientEmail: string,
    googlePrivateKey: string,
  ): void {
    const auth = new google.auth.GoogleAuth({
      credentials: {
        private_key: googlePrivateKey,
        client_email: googleClientEmail,
      },
      scopes: [GSHEETS_AUTH_URL],
    });
    const gsheets: sheets_v4.Sheets = google.sheets({
      version: GSHEETS_API_VERSION,
      auth,
    });
    this.gsheets = gsheets;
  }

  @ValidateGSheetsParams()
  async readSheet({
    spreadsheetId,
    sheetName,
    range,
  }: {
    spreadsheetId: string;
    sheetName: string;
    range: string;
  }): Promise<any> {
    const result = await this.gsheets.spreadsheets.values.get({
      spreadsheetId: spreadsheetId,
      range: range,
    });

    const rows = result.data.values;
    return rows;
  }

  @ValidateGSheetsParams(true)
  async insertSheet(
    spreadsheetId: string,
    sheetName: string,
    range: string,
    data: unknown[],
  ): Promise<{ updatedRange: string }> {
    const result = await this.gsheets.spreadsheets.values.append({
      spreadsheetId: spreadsheetId,
      range: `${sheetName}!${range}`, // `Sheet1!A1 default range
      valueInputOption: ROW,
      requestBody: {
        values: [data],
      },
    });

    const updatedRange = result.data?.updates?.updatedRange;
    return { updatedRange };
  }

  //update
  @ValidateGSheetsParams(true)
  async updateSheet(
    spreadsheetId: string,
    range: string,
    data: unknown[],
  ): Promise<{ updatedRange: string }> {
    const result = await this.gsheets.spreadsheets.values.update({
      spreadsheetId: spreadsheetId,
      range: range,
      valueInputOption: ROW,
      requestBody: {
        values: [data],
      },
    });
    if (!result.data) {
      throw new HttpException(NO_DATA_IN_RANGE, HttpStatus.BAD_REQUEST);
    }

    const updatedRange = result.data?.updatedRange;
    return { updatedRange };
  }
  //delete
  @ValidateGSheetsParams()
  async delete(
    spreadsheetId: string,
    sheetName: string,
    rowNumber: number,
  ): Promise<String> {
    const result = await this.gsheets.spreadsheets.get({
      spreadsheetId: spreadsheetId,
      includeGridData: false,
    });
    const sheet = result.data.sheets.find(
      (sheet) => sheet.properties.title === sheetName,
    );

    if (!sheet) {
      throw new HttpException(SHEET_NOT_FOUND, HttpStatus.NOT_FOUND);
    }

    const request = {
      deleteDimension: {
        range: {
          sheetId: sheet.properties.sheetId,
          dimension: `${ROW}S`,
          startIndex: rowNumber - 1,
          endIndex: rowNumber,
        },
      },
    };

    await this.gsheets.spreadsheets.batchUpdate({
      spreadsheetId: spreadsheetId,
      requestBody: {
        requests: [request],
      },
    });
    return DELETED_SUCCESSFULLY;
  }
}
