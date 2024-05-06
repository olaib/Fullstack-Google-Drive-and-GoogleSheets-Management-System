import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { USER_NOT_FOUND, INCORRECT_PASSWORD } from '../constants';
import {
  SafeUser,
  SafeUserDocument,
  User,
  UserDocument,
} from '../users/schemas/user.schema';
import * as bcrypt from 'bcrypt';
import { UsersService } from 'src/users/users.service';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
  ) {}

  async signIn(
    user: UserDocument | SafeUserDocument,
  ): Promise<{ access_token: string }> {
    const payload = { username: user.username, sub: user._id };
    return {
      access_token: this.jwtService.sign(payload),
    };
  }

  // async signIn({
  //   email,
  //   password,
  // }: {
  //   email: string;
  //   password: string;
  // }): Promise<{ access_token: string }> {
  //   try {
  //     const user = await this.usersService.findOneByEmail(email);
  //     if (!user) {
  //       throw new UnauthorizedException(USER_NOT_FOUND);
  //     }
  //     if (!(await bcrypt.compare(password, user?.password))) {
  //       throw new UnauthorizedException(PASSWORD_INCORRECT);
  //     }
  //     return this.generateToken(user);
  //   } catch (error) {
  //     throw new UnauthorizedException(error.message);
  //   }
  // }

  // async SignUp(user: UserDocument): Promise<UserDocument> {
  //   try {
  //     const hashedPassword = await bcrypt.hash(user.password, 10);
  //     const userWithHashedPassword = {
  //       ...user,
  //       password: hashedPassword,
  //     };
  //     return await this.usersService.create(userWithHashedPassword);
  //   } catch (error) {
  //     throw new UnauthorizedException(error.message);
  //   }
  // }

  //generate token
  //   async generateToken(user: UserDocument): Promise<{ access_token: string }> {
  //     const payload = { email: user.email, sub: user._id };
  //     return {
  //       access_token: this.jwtService.sign(payload),
  //     };
  //   }

  //   async validateToken(token: string): Promise<any> {
  //     return this.jwtService.verify(token);
  //   }

  async validateUser(username: string, password: string): Promise<SafeUser> {
    const user = await this.usersService.findOneByUsername(username);
    if (user && (await bcrypt.compare(password, user.password))) {
      const { password, ...result } = user;
      return result;
    }
    return null;
  }
}
