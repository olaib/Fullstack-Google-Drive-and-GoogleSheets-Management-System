import { Module } from '@nestjs/common';
import { GoogleSheetsService } from './service/google-sheets.service';
import { GoogleSheetsController } from './controller/google-sheets.controller';

@Module({
  providers: [GoogleSheetsService],
  controllers: [GoogleSheetsController]
})
export class GoogleSheetsModule {}
