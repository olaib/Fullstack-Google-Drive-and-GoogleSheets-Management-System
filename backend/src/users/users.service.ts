import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User, UserDocument } from './schemas/user.schema';
import { CreateUserDto } from './dto/create-user-dto/create-user.dto';
import { DELETE_USERS_SUCCESS } from 'src/constants';
import { hash } from 'crypto';

@Injectable()
export class UsersService {
  constructor(
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
  ) {}
  
  /**
   * Create a new user
   * @param createUserDto - CreateUserDto
   * @returns - created user
   * @throws Error
   * */
  async create(createUserDto: CreateUserDto): Promise<UserDocument> {
    const createdUser = new this.userModel(createUserDto);
    return await createdUser.save();
  }

  /**
   * Create or update many users
   * @param createdUsersDto - CreateUserDto[]
   * @returns - created or updated users
   * @throws Error
   * */
  async createOrUpdateMany(
    createdUsersDto: CreateUserDto[],
  ): Promise<UserDocument[]> {
    await this.userModel.bulkWrite(
      createdUsersDto.map((createdUserDto) => ({
        updateOne: {
          filter: { username: createdUserDto.username },
          update: {
            ...createdUserDto,
            password: hash(
              createdUserDto.password,
              process.env.SALT_OR_ROUNDS,
            ).toString(),
          },
          upsert: true,
        },
      })),
      { ordered: false },
    );

    return await this.userModel.find().exec();
  }

  /**
   * Get all users
   * @returns - all users
   * @throws Error
   * */
  async findAll(): Promise<UserDocument[]> {
    return await this.userModel.find().exec();
  }

  /**
   * Find user by username
   * @param username - user username
   * @returns - user
   * @throws Error
   * */
  async findOne(id: number): Promise<UserDocument> {
    return await this.userModel.findById(id).exec();
  }

  /**
   * Find user by username
   * @param username - user username
   * @returns - user
   * @throws Error
   * */
  async findOneByUsername(username: string): Promise<UserDocument> {
    return await this.userModel.findOne({ username: username }).exec();
  }
  
  /**
   * Update user by id
   * @param id - user id
   * @param user - User
   * @returns - updated user
   * @throws Error
   * */
  async update(id: number, user: User): Promise<User> {
    return await this.userModel.findByIdAndUpdate(id, user, { new: true });
  }

  /**
   * Update user by username
   * @param username - user username
   * @param user - User
   * @returns - updated user
   * @throws Error
   * */
  async updateByUsername(username: string, user: User): Promise<User> {
    return await this.userModel.findOneAndUpdate({ username: username }, user, {
      new: true,
    });
  }

  /**
   * Remove user by id
   * @param id - user id
   * @returns - deleted user
   * @throws Error
   * */
  async remove(id: string): Promise<number> {
    const deletedUser = await this.userModel.deleteOne({ _id: id }).exec();
    return deletedUser.deletedCount;
  }

  /**
   * Remove user by username
   * @param username - user username
   * @returns - deleted user
   * @throws Error
   * */
  async deleteMany(
    ids: number[],
  ): Promise<{ message: string; users: String[] }> {
    const usersToDelete = await this.userModel.find({ _id: { $in: ids } });
    await this.userModel.deleteMany({ _id: { $in: ids } });

    return {
      message: DELETE_USERS_SUCCESS,
      users: usersToDelete.map((user) => user.username),
    };
  }
}
