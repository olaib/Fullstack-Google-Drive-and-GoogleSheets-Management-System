import { Body, Controller, Param, Query } from '@nestjs/common';
import { UsersService } from './users.service';
import { StatusService } from 'src/statuses/status.service';
import { RolesService } from 'src/roles/roles.service';
import { SafeUser, SafeUserDocument, User } from './schemas/user.schema';
import * as bcrypt from 'bcrypt';

import {
  USER_NOT_FOUND,
  INVALID_PASSWORD,
  USER_NOT_LOGGED_IN,
  USER_LOGGED_OUT,
} from 'src/constants';
import {
  Post,
  Get,
  Patch,
  Delete,
} from '@nestjs/common/decorators/http/request-mapping.decorator';
import { CreateUserDto } from './dto/create-user-dto/create-user.dto';
import { hash } from 'crypto';
//todo prevent diplaying password in response

@Controller('users')
export class UsersController {
  constructor(
    private readonly usersService: UsersService,
    private readonly statusService: StatusService,
    private readonly rolesService: RolesService,
  ) {}

  @Post('user')
  async createOne(
    @Body()
    createUserDto: CreateUserDto,
  ): Promise<SafeUserDocument> {
    const role = createUserDto?.role;
    const status = createUserDto?.status;
    const hashedPassword: string = bcrypt.hashSync(
      createUserDto.password,
      process.env.SALT_OR_ROUNDS,
    );

    createUserDto = {
      ...createUserDto,
      password: hashedPassword,
      role: role?.name ? role : (await this.rolesService.findAll())[0],
      status: status?.name ? status : (await this.statusService.findAll())[0],
    };
    return this.usersService.create(createUserDto);
  }

  @Post()
  async createOrUpdateMany(
    @Body()
    createdUsersDto: CreateUserDto[],
  ): Promise<SafeUserDocument[]> {
    return this.usersService.createOrUpdateMany(createdUsersDto);
  }

  @Patch('user/update')
  async update(
    @Param('id')
    id: number,
    @Body()
    user: User,
  ): Promise<SafeUser> {
    return this.usersService.update(id, user);
  }

  @Patch('user')
  async updateOneByUsername(
    @Query('username') username: string,
    @Body() user: User,
  ): Promise<SafeUser> {
    return this.usersService.updateByUsername(username, user);
  }

  @Delete()
  async deleteMany(
    @Body()
    ids: number[],
  ): Promise<{ message: string; users: String[] }> {
    return this.usersService.deleteMany(ids);
  }
  @Get('user/:id')
  async findOne(
    @Param('id')
    id: number,
  ): Promise<SafeUser> {
    return this.usersService.findOne(id);
  }

  @Get('user')
  async findOneByUsername(
    @Query('username')
    username: string,
  ): Promise<SafeUser> {
    return this.usersService.findOneByUsername(username);
  }

  @Get()
  async findAll(): Promise<SafeUser[]> {
    return this.usersService.findAll();
  }
  // for user login
  @Post('/login')
  async findOneAndValidatePassword(
    @Body()
    username: string,
    @Body()
    password: string,
  ): Promise<SafeUser | String> {
    const user = await this.usersService.findOneByUsername(username);

    if (!user) return USER_NOT_FOUND;
    else {
      if (!bcrypt.compareSync(password, user.password)) return INVALID_PASSWORD;
      user.lastLogin = new Date();
      user.duration = 0;
      return user;
    }
  }

  @Post('/auth/logout')
  async logout(@Body() username: string): Promise<string> {
    const user = await this.usersService.findOneByUsername(username);
    if (!user) return USER_NOT_FOUND;
    if (!user.lastLogin) return USER_NOT_LOGGED_IN;
    user.duration = new Date().getTime() - user.lastLogin.getTime();
    return USER_LOGGED_OUT;
  }
}
