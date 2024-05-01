import { registerAs } from '@nestjs/config';

export default registerAs('env', () => ({
  PORT: { privateKey: process.env.PORT },
  MONGO_DB_URI: { privateKey: process.env.MONGO_DB_URI },
}));
