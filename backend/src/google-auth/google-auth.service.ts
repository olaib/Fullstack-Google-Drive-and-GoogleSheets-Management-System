import { Injectable } from '@nestjs/common';
const { google } = require('googleapis');
import {
  GDRIVE_AUTH_URL,
  GOOGLE_DRIVE_REDIRECT_URL,
  GSHEETS_AUTH_URL,
} from '../constants';

@Injectable()
export class GoogleAuthService {
  private oAuth2Client: any;
  private authUrl: string;

  constructor() {
    const googleClientId = process.env.OAUTH_CLIENT_ID;
    const googleClientSecret = process.env.OAUTH_CLIENT_SECRET;
    const googleClientEmail = process.env.CLIENT_EMAIL;
    const googlePrivateKey = process.env.GOOGLE_PRIVATE_KEY?.replace(
      /\\n/g,
      '\n',
    );
    this.authByServiceAccount(
      googleClientEmail,
      googlePrivateKey,
      googleClientId,
      googleClientSecret,
    );
  }

  /**
   * Authenticate with Google Drive API using service account
   * @param googleClientEmail - Google client email
   * @param googlePrivateKey - Google private key
   * @param googleClientId - Google client id
   * @param googleClientSecret - Google client secret
   * @returns void
   * @throws Error | HttpException
   * */
  private authByServiceAccount(
    googleClientEmail: string,
    googlePrivateKey: string,
    googleClientId: string,
    googleClientSecret: string,
  ): void {
    // create an oAuth client to authorize the API call
    this.oAuth2Client = new google.auth.OAuth2(
      googleClientId,
      googleClientSecret,
      GOOGLE_DRIVE_REDIRECT_URL,
    );
    // generate the url to authorize the API call
    this.authUrl = this.oAuth2Client.generateAuthUrl({
      credentials: {
        private_key: googlePrivateKey,
        client_email: googleClientEmail,
        refresh_token: process.env.REFRESH_TOKEN,
        // access_token: process.env.GOOGLE_ACCESS_TOKEN,
      },
      access_type: 'offline', // online (default) or offline (gets refresh_token)
      scope: [GDRIVE_AUTH_URL, GSHEETS_AUTH_URL],
      include_granted_scopes: true, // for incremental authorization
    });

    this.oAuth2Client.setCredentials({
      // access_token: process.env.GOOGLE_ACCESS_TOKEN,
      refresh_token: process.env.REFRESH_TOKEN,
    });
  }

  /** Get  the OAuth2Client
   * @returns any
   * */
  getOAuth2Client(): any {
    return this.oAuth2Client;
  }

  /**
   * Get the authentication URL
   * @returns string
   * */
  getAuthUrl(): string {
    return this.authUrl;
  }

  /**
   * Handle the authentication code
   * @param code - authentication code
   * @returns void
   * */
  async handleAuthCode(code: string): Promise<void> {
    try {
      const { tokens } = await this.oAuth2Client.getToken(code);

      this.oAuth2Client.setCredentials(tokens);
    } catch (_) {
      throw new Error('Authentication failed');
    }
  }
}
