import {
  Controller,
  Get,
  Post,
  Body,
  HttpException,
  Param,
  ParseIntPipe,
  Query,
} from '@nestjs/common';
import { GoogleSheetsService } from '../service/google-sheets.service';
import { ReadRowDto } from '../dto/read-row.dto/read-row.dto';

@Controller('google-sheets')
export class GoogleSheetsController {
  constructor(private readonly googleSheetsService: GoogleSheetsService) {}

  @Get()
  async readSheet(@Query() query: ReadRowDto): Promise<any> {
    return await this.googleSheetsService.readSheet({
      spreadsheetId: query.spreadsheetId,
      sheetName: query.sheetName,
      range: query.range,
    });
  }
}
