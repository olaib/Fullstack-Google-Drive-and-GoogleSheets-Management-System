import { Module } from '@nestjs/common';
import { MyGoogleDriveService } from './my-google-drive.service';
import { MyGoogleDriveController } from './my-google-drive.controller';

@Module({
  providers: [MyGoogleDriveService],
  controllers: [MyGoogleDriveController]
})
export class MyGoogleDriveModule {}
