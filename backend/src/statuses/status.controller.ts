import { Body, Controller, Delete, Get, Param, Post } from '@nestjs/common';
import { StatusService } from './status.service';
import { CreateStatusDto } from './dto/create-status.dto';

@Controller('status')
export class StatusController {
  constructor(private readonly statusService: StatusService) {}

  @Get()
  async findAll() {
    return this.statusService.findAll();
  }

  @Get(':value')
  async findByValue(@Param('value') value: string) {
    return this.statusService.findByValue(value);
  }

  @Get(':id')
  async findById(@Param('id') id: string) {
    return this.statusService.findById(id);
  }

  @Delete(':id')
  async deleteById(@Param('id') id: string) {
    return this.statusService.deleteById(id);
  }

  @Post()
  async create(@Body() dto: CreateStatusDto) {
    return this.statusService.create(dto);
  }
}
