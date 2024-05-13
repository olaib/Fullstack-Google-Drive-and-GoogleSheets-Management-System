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
import { GlobalModule } from './common/global/global.module';
import { GoogleDriveModule } from 'nestjs-google-drive';
import { GOOGLE_DRIVE_REDIRECT_URL } from './constants';
import { MyGoogleDriveModule } from './my-google-drive/my-google-drive.module';
import { GoogleAuthModule } from './google-auth/google-auth.module';

@Module({
  imports: [
    ConfigModule.forRoot(),
    GoogleDriveModule.register({
      clientId: process.env.OAUTH_CLIENT_ID,
      clientSecret: process.env.OAUTH_CLIENT_SECRET,
      redirectUrl: GOOGLE_DRIVE_REDIRECT_URL,
      refreshToken: process.env.REFRESH_TOKEN,
    }),
    MongooseModule.forRootAsync({ 
      useFactory: async () => ({
        uri: process.env.MONGO_DB_URI,
      }),
    }),
    GoogleSheetsModule,
    UsersModule,
    GlobalModule,
    RolesModule,
    StatusModule,
    AuthModule,
    MyGoogleDriveModule,
    GoogleAuthModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
