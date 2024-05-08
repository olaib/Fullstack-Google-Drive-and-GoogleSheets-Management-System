import { Module } from '@nestjs/common';
<<<<<<< Updated upstream
import { GoogleSheetsService } from './service/google-sheets.service';
import { GoogleSheetsController } from './controller/google-sheets.controller';
<<<<<<< Updated upstream
=======
import { GoogleSheetsService } from './google-sheets.service';
import { GoogleSheetsController } from './google-sheets.controller';
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

@Module({
  providers: [GoogleSheetsService],
  controllers: [GoogleSheetsController]
})
export class GoogleSheetsModule {}
