import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';
import { ALREADY_EXISTS, REQUIRED_FIELD } from 'src/constants';

export type StatusDocument = HydratedDocument<Status>;

@Schema({ timestamps: true })
export class Status {
  @Prop({
    required: [true, `status is ${REQUIRED_FIELD}`],
    unique: [true, `status is ${ALREADY_EXISTS}`],
  })
  name: string;

  @Prop({
    required: [true, `priority is ${REQUIRED_FIELD}`],
    unique: [true, `priority is ${ALREADY_EXISTS}`],
  })
  priority: number;
}

export const StatusSchema = SchemaFactory.createForClass(Status);

StatusSchema.pre('save', async function (next) {
  //is already exists
  const role = this;
  const isExists = await this.model('Status').findOne({
    name: role.name,
    priority: role.priority,
  });

  if (isExists) {
    throw new Error(ALREADY_EXISTS);
  }
  next();
});
