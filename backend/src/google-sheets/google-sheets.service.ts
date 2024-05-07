import { Injectable, Inject, HttpException, HttpStatus } from '@nestjs/common';
import { google, sheets_v4 } from 'googleapis';
import envConfig from '../../config/env.config';
import { ConfigType } from '@nestjs/config';
import {
  ROW,
  SHEET_NOT_FOUND,
  GSHEETS_AUTH_URL,
  NO_DATA_IN_RANGE,
  GSHEETS_API_VERSION,
  DELETED_SUCCESSFULLY,
} from '../constants';
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
      range: [sheetName, range].join('!'),
    });

    const rows = result.data.values;
    return rows;
  }

<<<<<<< Updated upstream:backend/src/google-sheets/service/google-sheets.service.ts
=======
  async getContentByGid(spreadsheetId: string,sheetName: string): Promise<any> {
    const result = await this.gsheets.spreadsheets.get({
      spreadsheetId: spreadsheetId,
      ranges: [sheetName],
      includeGridData: true,

    });
    console.log(result)
    return result.data.sheets;
    // const sheet = result.data.sheets.find((sheet) => sheet.properties.sheetId === Number(gid));
    // return sheet;
  }
  /**
   * Insert new row in Google Sheet
   * @param spreadsheetId - Google Spreadsheet ID
   * @param sheetName - Name of the google sheet
   * @param range - Range of the google sheet
   * @param data - Data to insert in the google sheet
   * @returns Promise<{ updatedRange: string }> - Updated range of the google sheet
   * @throws HttpException | Error
   */
>>>>>>> Stashed changes:backend/src/google-sheets/google-sheets.service.ts
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

  async appendRow(
    spreadsheetId: string,
    sheetName: string,
    data: unknown[],
    range: string,
  ): Promise<{ updatedRange: string }> {
    const result = await this.gsheets.spreadsheets.values.append({
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

    const updatedRange = result.data?.updates?.updatedRange;
    return { updatedRange };
  }

  //create new sheet with a name
  async createSheet(sheetName: string): Promise<string> {
    const result = await this.gsheets.spreadsheets.create({
      requestBody: {
        properties: {
          title: sheetName,
        },
      },
    });

    return result.data.spreadsheetId;
  }

  // change spreadsheet title
  async updateSheetTitle(
    spreadsheetId: string,
    title: string,
  ): Promise<string> {
    const result = await this.gsheets.spreadsheets.batchUpdate({
      spreadsheetId: spreadsheetId,
      requestBody: {
        requests: [
          {
            updateSpreadsheetProperties: {
              properties: {
                title: title,
              },
              fields: 'title',
            },
          },
        ],
      },
    });

    return result.data.spreadsheetId;
  }

  rowsToArr(data: string[][]): object[] {
    const [keys, ...values] = data;
    return values.map((valuesArray) => {
      return valuesArray.reduce((acc, value, index) => {
        acc[keys[index]] = value;
        return acc;
      }, {});
    });
  }

  objectToRow(data: object): string[] {
    return Object.values(data);
  }
}
