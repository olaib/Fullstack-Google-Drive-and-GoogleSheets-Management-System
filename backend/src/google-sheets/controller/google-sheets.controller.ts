import {
  Controller,
  Get,
  Body,
  Query,
  Patch,
  Delete,
  Post,
} from '@nestjs/common';
import { GoogleSheetsService } from '../service/google-sheets.service';
import { ReadRowDto } from '../dto/read-row.dto/read-row.dto';
import { UpdateRowDto } from '../dto/update-row.dto/update-row.dto';
import {
  ADDED_SUCCESSFULLY,
  DEFAULT_RANGE,
  DELETED_SUCCESSFULLY,
  UPDATED_SUCCESSFULLY,
} from '../../constants';
import { DeleteRowDto } from '../dto/delete-row.dto/delete-row.dto';
import { HelpersService } from 'src/common/helpers/helpers.service';

@Controller('sheets')
export class GoogleSheetsController {
  constructor(private readonly googleSheetsService: GoogleSheetsService) {}

  @Get()
  async getSheet(@Query() query: ReadRowDto): Promise<any> {
    const { spreadsheetId, range = DEFAULT_RANGE } = query;

    return await this.googleSheetsService.readSheet({
      spreadsheetId: spreadsheetId,
      range: range,
    });
  }

  @Patch('update')
  async updateSheet(@Body() dataFieldsToUpdate: UpdateRowDto): Promise<{
    message: string;
    updatedRange: string;
  }> {
    const { spreadsheetId, range = DEFAULT_RANGE, data } = dataFieldsToUpdate;

    const dataToRowObj = HelpersService.objectToRow(data);

    const { updatedRange } = await this.googleSheetsService.updateSheet(
      spreadsheetId,
      range,
      dataToRowObj,
    );
    return {
      message: UPDATED_SUCCESSFULLY,
      updatedRange: updatedRange,
    };
  }

  @Delete('row/delete')
  async deleteRow(@Body() body: DeleteRowDto): Promise<{ message: string }> {
    const { spreadsheetId, sheetName, rowNumber } = body;
    await this.googleSheetsService.delete(spreadsheetId, sheetName, rowNumber);

    return {
      message: DELETED_SUCCESSFULLY,
    };
  }

  @Post('append')
  async appendSheet(
    @Body() dataFieldsToUpdate: UpdateRowDto,
  ): Promise<{ message: string; updatedRange: string }> {
    const {
      data,
      sheetName,
      spreadsheetId,
      range = DEFAULT_RANGE,
    } = dataFieldsToUpdate;

    const dataToRowObj = HelpersService.objectToRow(data);
    const { updatedRange } = await this.googleSheetsService.insertSheet(
      spreadsheetId,
      sheetName,
      range,
      dataToRowObj,
    );

    return {
      message: ADDED_SUCCESSFULLY,
      updatedRange: updatedRange,
    };
  }

  @Post('create')
  async createSheet(@Body() sheetName: string): Promise<string> {
    return await this.googleSheetsService.createSheet(sheetName);
  }
  //find all sheets details in a spreadsheet
  @Get('all')
  async getAllSheets(
    @Query('spreadsheetId') spreadsheetId: string,
  ): Promise<any> {
    return await this.googleSheetsService.getAllSheets(spreadsheetId);
  }
}
