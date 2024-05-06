import { HttpException, HttpStatus } from '@nestjs/common';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Schema as mongooseSchema } from 'mongoose';
import { Role } from '../../roles/schemas/role.schema';

import {
  ALREADY_EXISTS,
  INVALID_PASSWORD,
  REQUIRED_FIELD,
  PASSWORD_REG,
  EXISTS_USER,
} from '../../constants';
import { Status } from 'src/statuses/schemas/status.schema';
import { OmitType } from '@nestjs/mapped-types';

export type UserDocument = HydratedDocument<User>;

export type SafeUserDocument = HydratedDocument<SafeUser>;

@Schema({ timestamps: true })
export class User {
  @Prop({
    required: [true, `row is ${REQUIRED_FIELD}`],
    unique: true,
  })
  rowNumber!: number;
  @Prop({
    required: [true, `username is ${REQUIRED_FIELD}`],
    unique: true,
  })
  username!: string;
  @Prop({ required: [true, `password is ${REQUIRED_FIELD}`] })
  password!: string;

  @Prop({
    required: [true, `role is ${REQUIRED_FIELD}`],
    type: mongooseSchema.Types.ObjectId,
    ref: 'Role',
  })
  role!: Role;

  @Prop({
    required: [true, `status is ${REQUIRED_FIELD}`],
    type: mongooseSchema.Types.ObjectId,
    ref: 'Status',
  })
  status!: Status;
  //must be last-login
  @Prop({ required: false, field: 'last-login' })
  lastLogin!: Date;

  @Prop({ required: false })
  duration!: number;

  static validatePassword(password: string) {
    if (!password.match(PASSWORD_REG)) {
      throw new HttpException(
        {
          status: HttpStatus.BAD_REQUEST,
          message: INVALID_PASSWORD,
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }
}
export class SafeUser extends OmitType(User, ['password']) {}

export const UserSchema = SchemaFactory.createForClass(User);

UserSchema.pre<UserDocument>('save', async function (next) {
  const user = this;
  const existingUser = await this.model('User').findOne({
    username: user.username,
  });
  if (existingUser && user.rowNumber == this.rowNumber) {
    throw new Error(EXISTS_USER);
  }
  next();
});
