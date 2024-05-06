import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsAlphanumeric,
  IsNotEmpty,
  IsOptional,
  IsPositive,
  IsString,
} from 'class-validator';
import { timeStamp } from 'console';
import { Role } from 'src/roles/schemas/role.schema';
import { Status } from 'src/statuses/schemas/status.schema';

export class CreateUserDto {
  @ApiProperty()
  @IsNotEmpty()
  readonly rowNumber: number;

  @ApiProperty()
  @IsNotEmpty()
  @IsAlphanumeric()
  readonly username!: string;

  @ApiProperty()
  @IsNotEmpty()
  @IsString()
  readonly password!: string;

  @ApiProperty()
  @IsOptional()
  @Type(() => Role)
  readonly role?: Role;

  @ApiProperty()
  @IsOptional()
  @Type(() => Status)
  readonly status?: Status;

  @ApiProperty()
  @IsOptional()
  @Type(() => Date)
  readonly lastLogin!: Date;

  //   duration at current status
  @ApiProperty()
  @IsOptional()
  @Type(() => Number)
  readonly duration!: number;
}
