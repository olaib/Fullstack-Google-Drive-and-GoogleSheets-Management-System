import { ApiProperty, PickType } from '@nestjs/swagger';
import { ReadRowDto } from '../read-row.dto/read-row.dto';
import { IsNotEmpty, IsNumber, IsPositive, IsString } from 'class-validator';

export class DeleteRowDto extends PickType(ReadRowDto, [
  'spreadsheetId',
  'sheetName',
]) {
  @IsNotEmpty()
  @IsNumber()
  @IsPositive()
  rowNumber: number;
}
