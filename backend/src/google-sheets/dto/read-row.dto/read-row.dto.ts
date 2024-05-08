import { IsNotEmpty, IsOptional, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { DEFAULT_RANGE } from 'src/constants';

export class ReadRowDto {
  @ApiProperty()
  @IsNotEmpty()
  @IsString()
  spreadsheetId: string;

  @ApiProperty()
  @IsString()
  sheetName: string;

  @ApiProperty()
  @IsOptional()
  @IsString()
  range: string = DEFAULT_RANGE;

}


