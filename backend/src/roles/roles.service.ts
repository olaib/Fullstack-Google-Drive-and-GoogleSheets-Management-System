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

  /**
   * Create a new role
   * @param dto - CreateRoleDto
   * @returns - created role
   * @throws Error
   * */
  async create(dto: CreateRoleDto): Promise<RoleDocument> {
    const role = await this.roleModel.create(dto);
    return role;
  }

  /**
   * Get all roles
   * @returns - all roles
   * @throws Error
   * */
  async findAll(): Promise<RoleDocument[]> {
    const roles = await this.roleModel.find();
    return roles;
  }
  /**
   * Find role by value
   * @param value - role value
   * @returns - role
   * @throws Error
   * */
  async findByValue(value: string): Promise<RoleDocument | null> {
    const role = await this.roleModel.findOne({ value });
    return role;
  }
  /**
   * Find role by id
   * @param id - role id
   * @returns - role
   * @throws Error
   * */
  async findById(id: string): Promise<RoleDocument | null> {
    const role = await this.roleModel.findById(id);
    return role;
  }
  /**
   * Delete role by id
   * @param id - role id
   * @returns - deleted role
   * @throws Error
   * */
  async deleteById(id: string): Promise<RoleDocument | null> {
    const role = await this.roleModel.findByIdAndDelete(id);
    return role;
  }
}
