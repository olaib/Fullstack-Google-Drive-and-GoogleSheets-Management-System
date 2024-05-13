import {
  Controller,
  Get,
  Body,
  Query,
  Delete,
  Post,
  ParseIntPipe,
} from '@nestjs/common';
import { GoogleSheetsService } from '../service/google-sheets.service';
import { ReadRowDto } from '../dto/read-row.dto/read-row.dto';
import { UpdateRowDto } from '../dto/update-row.dto/update-row.dto';
import {
  ADDED_SUCCESSFULLY,
  DELETED_SUCCESSFULLY,
  UPDATED_SUCCESSFULLY,
} from '../../constants';
import { DeleteRowDto } from '../dto/delete-row.dto/delete-row.dto';
import { HelpersService } from '../../common/helpers/helpers.service';

@Controller('sheets')
export class GoogleSheetsController {
  constructor(private readonly googleSheetsService: GoogleSheetsService) {}
  @Get()
  async getSheet(@Query() query: ReadRowDto): Promise<any[][]> {
    const { spreadsheetId, range, sheetName } = query;

    return await this.googleSheetsService.readSheet({
      spreadsheetId: spreadsheetId,
      range: range,
      sheetName: sheetName,
    });
  }

  @Post('update')
  async updateSheet(@Body() dataFieldsToUpdate: UpdateRowDto): Promise<{
    message: string;
    updatedRange: string;
  }> {
    const { spreadsheetId, sheetName, range, data } = dataFieldsToUpdate;
    console.log('');
    const dataToRowObj = HelpersService.objectToRow(data);
    console.log(dataToRowObj);

    const { updatedRange } = await this.googleSheetsService.updateSheet(
      sheetName,
      spreadsheetId,
      range,
      dataToRowObj,
    );
    return {
      message: UPDATED_SUCCESSFULLY,
      updatedRange: updatedRange,
    };
  }

  @Delete('row')
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
    const { data, sheetName, spreadsheetId, range } = dataFieldsToUpdate;

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

  // @Post('create')
  // async createSheet(@Body() sheetName: string, @Body() spreadsheetId: string) {
  //   // sheetName = sheetName.charAt(0).toUpperCase() + sheetName.slice(1);
  //   return await this.googleSheetsService.createSheet(sheetName, spreadsheetId);
  // }

  //find all sheets details in a spreadsheet
  @Get('titles')
  async getAllSheets(
    @Query('spreadsheetId') spreadsheetId: string,
  ): Promise<any> {
    return await this.googleSheetsService.getAllSheets(spreadsheetId);
  }

  @Post('update/title')
  async updateSheetTitle(
    @Body('spreadsheetId') spreadsheetId: string,
    @Body('sheetId', ParseIntPipe) sheetId: number,
    @Body('title') updatedTitle: string,
  ): Promise<string> {
    return await this.googleSheetsService.updateSheetTitle(
      spreadsheetId,
      sheetId,
      updatedTitle,
    );
  }
}
