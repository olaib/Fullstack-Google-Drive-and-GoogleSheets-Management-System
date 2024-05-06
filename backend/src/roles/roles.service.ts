import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Role, RoleDocument } from './schemas/role.schema';
import { CreateRoleDto } from './dto/create-role.dto';

@Injectable()
export class RolesService {
  constructor(
    @InjectModel(Role.name) private readonly roleModel: Model<RoleDocument>,
  ) {}

  async create(dto: CreateRoleDto): Promise<RoleDocument> {
    const role = await this.roleModel.create(dto);
    return role;
  }

  async findAll(): Promise<RoleDocument[]> {
    const roles = await this.roleModel.find();
    return roles;
  }

  async findByValue(value: string): Promise<RoleDocument | null> {
    const role = await this.roleModel.findOne({ value });
    return role;
  }

  async findById(id: string): Promise<RoleDocument | null> {
    const role = await this.roleModel.findById(id);
    return role;
  }

  async deleteById(id: string): Promise<RoleDocument | null> {
    const role = await this.roleModel.findByIdAndDelete(id);
    return role;
  }
}
