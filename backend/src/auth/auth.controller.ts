import {
  Body,
  UseGuards,
  Request,
  Post,
  Get,
  Controller,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { AuthGuard } from './auth.guard';
import { AuthService } from './auth.service';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  // @HttpCode(HttpStatus.OK)
  // @Post('login')
  // async SignIn(
  //   @Body() signInDto: Record<string, any>,
  // ): Promise<{ access_token: string | undefined }> {
  //   return await this.authService.signIn({
  //     email: signInDto.email,
  //     password: signInDto.password,
  //   });
  // }

  @Get('profile')
  async getProfile(@Request() req: any): Promise<any> {
    return req.user;
  }
}
