import { IsNotEmpty, IsString } from 'class-validator';

export class ReadRowDto {
  @IsNotEmpty()
  @IsString()
  spreadsheetId: string;

  @IsNotEmpty()
  @IsString()
  sheetName: string;

  @IsNotEmpty()
  @IsString()
  range: string;
}
