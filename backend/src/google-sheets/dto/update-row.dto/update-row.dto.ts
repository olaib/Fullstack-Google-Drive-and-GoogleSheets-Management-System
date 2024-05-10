import { IsArray, IsNotEmpty, IsString } from 'class-validator';
import { ReadRowDto } from '../read-row.dto/read-row.dto';
import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';

export class UpdateRowDto extends ReadRowDto {
  @ApiProperty()
  @IsString()
  range: string;

  @ApiProperty()
  @IsArray()
  data: any[];
}
