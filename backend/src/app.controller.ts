import { Controller, Get, Redirect } from '@nestjs/common';
import { AppService } from './app.service';
import {
  SWAGGER_API_ENDPOINT,
  WELCOME_MESSAGE,
  TEST_ENDPOINTS_MESSAGE,
} from './constants';
// todo: add roles guard and tokens

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }
}
