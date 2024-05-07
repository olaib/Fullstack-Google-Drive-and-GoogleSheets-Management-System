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

  /**
   * Create a new status
   * @param dto - CreateStatusDto
   * @returns - created status
   * @throws Error
   * */
  async create(dto: CreateStatusDto): Promise<StatusDocument> {
    const createdStatus = await this.statusModel.create({
      ...dto,
      name: dto.name.toLowerCase(),
    });
    return createdStatus;
  }
  /**
   * Get all statuses
   * @returns - all statuses
   * @throws Error
   * */
  async findAll(): Promise<StatusDocument[]> {
    // const statuses = await this.statusModel.find({ order: { priority: 0 } });
    const statuses = await this.statusModel.find();
    return statuses;
  }
  /**
   * Find status by value
   * @param value - status value
   * @returns - status
   * @throws Error
   * */
  async findByValue(value: string): Promise<StatusDocument | null> {
    return await this.statusModel.findOne({ value });
  }
  /**
   * Find status by id
   * @param id - status id
   * @returns - status
   * @throws Error
   * */
  async findById(id: string): Promise<StatusDocument | null> {
    return await this.statusModel.findById(id);
  }
  /**
   * Delete status by id
   * @param id - status id
   * @returns - deleted status
   * @throws Error
   * */
  async deleteById(id: string): Promise<StatusDocument | null> {
    return await this.statusModel.findByIdAndDelete(id);
  }
}
