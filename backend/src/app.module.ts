import { Global, Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from '@nestjs/config';
import { GoogleSheetsModule } from './google-sheets/google-sheets.module';
import { UsersModule } from './users/users.module';
import { RolesModule } from './roles/roles.module';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthModule } from './auth/auth.module';
import { StatusModule } from './statuses/status.module';
import { HelpersModule } from './common/helpers/helpers.module';
import { GlobalModule } from './common/global/global.module';

@Module({
  imports: [
    ConfigModule.forRoot(),
    GoogleSheetsModule,
    UsersModule,
    GlobalModule,
    RolesModule,
    StatusModule,
    AuthModule,
    GlobalModule,
    MongooseModule.forRootAsync({
      useFactory: async () => ({
        uri: process.env.MONGO_DB_URI,
      }),
    }),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
