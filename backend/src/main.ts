import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DEFAULT_PORT, PORT_KEY } from './constants';
import { ValidationPipe } from '@nestjs/common';
import { HttpExceptionFilter } from './common/filters/http-exception.filter';

/**
 * validation pipe is a built-in pipe provided by NestJS to validate incoming requests
 * @see https://docs.nestjs.com/techniques/validation for more information
 * FastifyAdapter is a built-in adapter provided by NestJS to use Fastify as the underlying HTTP server
 * @see https://docs.nestjs.com/techniques/performance for more information
 */
async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const PORT: string = process.env.PORT ?? DEFAULT_PORT;

  app.enableCors();
  app.useGlobalPipes(new ValidationPipe());
  app.useGlobalFilters(new HttpExceptionFilter());

  await app.listen(PORT);
  console.log(`Server is running on: http://localhost:${PORT}`);
}
bootstrap();
