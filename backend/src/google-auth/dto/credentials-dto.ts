import { IsNotEmpty, IsString } from 'class-validator';

export class CredentialsDto {
  @IsString()
  @IsNotEmpty()
  client_id: string;
  @IsString()
  @IsNotEmpty()
  client_secret: string;
  @IsString()
  @IsNotEmpty()
  client_email: string;
  @IsString()
  @IsNotEmpty()
  private_key: string;
  @IsString()
  @IsNotEmpty()
  redirect_url: string;
}
