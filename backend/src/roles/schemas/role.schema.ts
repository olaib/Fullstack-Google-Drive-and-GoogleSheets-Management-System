import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';
import { ALREADY_EXISTS, REQUIRED_FIELD } from 'src/constants';

export type RoleDocument = HydratedDocument<Role>;

@Schema({ timestamps: true })
export class Role {
  @Prop({
    required: [true, `role is ${REQUIRED_FIELD}`],
    unique: [true, `role is ${ALREADY_EXISTS}`],
  })
  name: string;
}

export const RoleSchema = SchemaFactory.createForClass(Role);
