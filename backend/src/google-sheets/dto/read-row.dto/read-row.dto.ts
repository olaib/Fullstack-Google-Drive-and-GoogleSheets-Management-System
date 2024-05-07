import { IsNotEmpty, IsOptional, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class ReadRowDto {
  @ApiProperty()
  @IsNotEmpty()
  @IsString()
  spreadsheetId: string;

  @ApiProperty()
  @IsOptional()
  @IsString()
  sheetName?: string;

  @ApiProperty()
  @IsOptional()
  @IsString()
  range?: string;
}
