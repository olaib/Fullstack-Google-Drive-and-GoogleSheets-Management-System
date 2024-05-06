import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Status, StatusDocument } from './schemas/status.schema';
import { CreateStatusDto } from './dto/create-status.dto';

@Injectable()
export class StatusService {
  constructor(
    @InjectModel(Status.name)
    private readonly statusModel: Model<StatusDocument>,
  ) {}

  async create(dto: CreateStatusDto): Promise<StatusDocument> {
    const createdStatus = await this.statusModel.create({
      ...dto,
      name: dto.name.toLowerCase()
    });
    return createdStatus;
  }

  async findAll(): Promise<StatusDocument[]> {
    // const statuses = await this.statusModel.find({ order: { priority: 0 } });
    const statuses = await this.statusModel.find();
    return statuses;
  }

  async findByValue(value: string): Promise<StatusDocument | null> {
    return await this.statusModel.findOne({ value });
  }

  async findById(id: string): Promise<StatusDocument | null> {
    return await this.statusModel.findById(id);
  }

  async deleteById(id: string): Promise<StatusDocument | null> {
    return await this.statusModel.findByIdAndDelete(id);
  }
}
