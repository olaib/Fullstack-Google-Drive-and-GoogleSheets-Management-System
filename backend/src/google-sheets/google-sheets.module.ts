import { Module } from '@nestjs/common';
import { GoogleSheetsService } from './service/google-sheets.service';
import { GoogleSheetsController } from './controller/google-sheets.controller';
import { HelpersModule } from 'src/common/helpers/helpers.module';

@Module({
  providers: [GoogleSheetsService],
  controllers: [GoogleSheetsController],
  exports: [GoogleSheetsService],
})
export class GoogleSheetsModule {}
