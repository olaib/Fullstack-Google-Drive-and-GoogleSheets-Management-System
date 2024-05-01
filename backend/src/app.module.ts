import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from '@nestjs/config';
import { GoogleSheetsModule } from './google-sheets/google-sheets.module';
import envConfig from './config/env.config';

@Module({
  imports: [ ConfigModule.forRoot({
    envFilePath: ['.env', '.env.example'],
    isGlobal: true,
    load: [envConfig],
  }), GoogleSheetsModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
