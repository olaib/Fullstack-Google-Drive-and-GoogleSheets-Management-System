import {
  IsNotEmpty,
  IsNotEmptyObject,
  IsObject,
  IsOptional,
} from 'class-validator';
import { ReadRowDto } from '../read-row.dto/read-row.dto';
import { ApiProperty } from '@nestjs/swagger';

export class UpdateRowDto extends ReadRowDto {
  @ApiProperty()
  @IsNotEmpty()
  @IsNotEmptyObject()
  @IsObject()
  data: Record<string, any>;

  @ApiProperty()
  @IsOptional()
  sheetName: string;
}
