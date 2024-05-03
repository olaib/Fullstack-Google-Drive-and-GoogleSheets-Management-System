import { ApiProperty, PickType } from '@nestjs/swagger';
import { UpdateRowDto } from '../update-row.dto/update-row.dto';
import { IsOptional, IsString } from 'class-validator';

export class AppendRowDto extends PickType(UpdateRowDto, [
  'spreadsheetId',
  'sheetName',
  'data',
  'range'
]) {}
