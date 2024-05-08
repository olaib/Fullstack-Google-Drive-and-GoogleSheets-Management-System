import { IsNotEmpty, IsOptional, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class ReadRowDto {
  @ApiProperty()
  @IsNotEmpty()
  @IsString()
  spreadsheetId: string;

  @ApiProperty()
  @IsString()
  sheetName?: string;

  @ApiProperty()
  @IsOptional()
<<<<<<< Updated upstream
  @IsString()
  range?: string;
=======
  range: string;
>>>>>>> Stashed changes
}
