import {
  Controller,
  Get,
  Body,
  Query,
  Patch,
  Delete,
  Post,
} from '@nestjs/common';
<<<<<<< Updated upstream
<<<<<<<< Updated upstream:backend/src/google-sheets/google-sheets.controller.ts
import { GoogleSheetsService } from './google-sheets.service';
import { ReadRowDto } from './dto/read-row.dto/read-row.dto';
import { UpdateRowDto } from './dto/update-row.dto/update-row.dto';
========
import { GoogleSheetsService } from '../service/google-sheets.service';
import { ReadRowDto } from '../dto/read-row.dto/read-row.dto';
import { UpdateRowDto } from '../dto/update-row.dto/update-row.dto';
import { DeleteRowDto } from '../dto/delete-row.dto/delete-row.dto';
>>>>>>>> Stashed changes:backend/src/google-sheets/controller/google-sheets.controller.ts
=======

import { GoogleSheetsService } from './service/google-sheets.service';
import { ReadRowDto } from './dto/read-row.dto/read-row.dto';
import { UpdateRowDto } from './dto/update-row.dto/update-row.dto';
>>>>>>> Stashed changes
import {
  ADDED_SUCCESSFULLY,
  DEFAULT_RANGE,
  DELETED_SUCCESSFULLY,
  UPDATED_SUCCESSFULLY,
<<<<<<< Updated upstream
<<<<<<< Updated upstream:backend/src/google-sheets/controller/google-sheets.controller.ts
} from '../../constants';
<<<<<<<< Updated upstream:backend/src/google-sheets/google-sheets.controller.ts
import { DeleteRowDto } from '../dto/delete-row.dto/delete-row.dto';
=======
} from '../constants';
import { DeleteRowDto } from './dto/delete-row.dto/delete-row.dto';
========
>>>>>>>> Stashed changes:backend/src/google-sheets/controller/google-sheets.controller.ts
import { HelpersService } from 'src/common/helpers/helpers.service';
>>>>>>> Stashed changes:backend/src/google-sheets/google-sheets.controller.ts
=======
} from '../constants';
import { DeleteRowDto } from './dto/delete-row.dto/delete-row.dto';
import { HelpersService } from '../common/helpers/helpers.service';
>>>>>>> Stashed changes

@Controller('sheets')
export class GoogleSheetsController {
  constructor(private readonly googleSheetsService: GoogleSheetsService) {}

<<<<<<< Updated upstream
<<<<<<<< Updated upstream:backend/src/google-sheets/google-sheets.controller.ts
  @Post()
  async getSheet(@Body() body: ReadRowDto): Promise<any> {
    const { spreadsheetId,sheetName, range = DEFAULT_RANGE } = body;

    const rows =  await this.googleSheetsService.readSheet({
========
  @Get()
  async getSheet(@Query() query: ReadRowDto): Promise<any> {
    const { spreadsheetId, sheetName, range = DEFAULT_RANGE } = query;

    return await this.googleSheetsService.readSheet({
>>>>>>>> Stashed changes:backend/src/google-sheets/controller/google-sheets.controller.ts
=======
  @Post()
  async getSheet(@Body() body: ReadRowDto): Promise<any> {
    const { spreadsheetId, sheetName, range = DEFAULT_RANGE } = body;

    const rows = await this.googleSheetsService.readSheet({
>>>>>>> Stashed changes
      sheetName: sheetName,
      spreadsheetId: spreadsheetId,
      range: range,
    });

    return HelpersService.rowsToArr(rows);
  }

  @Patch('update')
  async updateSheet(@Body() dataFieldsToUpdate: UpdateRowDto): Promise<{
    message: string;
    updatedRange: string;
<<<<<<< Updated upstream
  }> { 
    const { spreadsheetId, range = DEFAULT_RANGE, data } = dataFieldsToUpdate;

    const dataToRowObj = this.googleSheetsService.objectToRow(data);
=======
  }> {
    const { spreadsheetId, range = DEFAULT_RANGE, data } = dataFieldsToUpdate;

    const dataToRowObj = HelpersService.objectToRow(data);
>>>>>>> Stashed changes

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

<<<<<<< Updated upstream
    const dataToRowObj = this.googleSheetsService.objectToRow(data);
=======
    const dataToRowObj = HelpersService.objectToRow(data);
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
<<<<<<<< Updated upstream:backend/src/google-sheets/google-sheets.controller.ts
<<<<<<< Updated upstream:backend/src/google-sheets/controller/google-sheets.controller.ts
=======
========

>>>>>>>> Stashed changes:backend/src/google-sheets/controller/google-sheets.controller.ts
=======
>>>>>>> Stashed changes
  @Get('titles')
  async getAllSheets(
    @Query('spreadsheetId') spreadsheetId: string,
  ): Promise<any> {
    return await this.googleSheetsService.getAllSheets(spreadsheetId);
  }
<<<<<<< Updated upstream
>>>>>>> Stashed changes:backend/src/google-sheets/google-sheets.controller.ts
=======
>>>>>>> Stashed changes
}
