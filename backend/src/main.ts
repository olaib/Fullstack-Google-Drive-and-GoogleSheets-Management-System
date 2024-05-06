import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DEFAULT_PORT } from './constants';
import { ValidationPipe } from '@nestjs/common';
import { HttpExceptionFilter } from './common/filters/http-exception.filter';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import {
  SWAGGER_API_DESCRIPTION,
  SWAGGER_API_ENDPOINT,
  SWAGGER_API_TAG,
  SWAGGER_API_TITLE,
  SWAGGER_API_VERSION,
} from './constants';

//todo: add permissions to the user in the spreadsheet
/**
 * validation pipe is a built-in pipe provided by NestJS to validate incoming requests
 * @see https://docs.nestjs.com/techniques/validation for more information
 * FastifyAdapter is a built-in adapter provided by NestJS to use Fastify as the underlying HTTP server
 * @see https://docs.nestjs.com/techniques/performance for more information
 * Swagger documentation is a built-in feature provided by NestJS to generate API documentation and test the API endpoints
 * @see https://docs.nestjs.com/openapi/introduction for more information
 */
async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const PORT: string = process.env.PORT ?? DEFAULT_PORT;

  app.enableCors();
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
    }),
  );
  app.useGlobalFilters(new HttpExceptionFilter());

  const config = new DocumentBuilder()
    .setTitle(SWAGGER_API_TITLE)
    .setDescription(SWAGGER_API_DESCRIPTION)
    .setVersion(SWAGGER_API_VERSION)
    .addTag(SWAGGER_API_TAG)
    .build();
  const document = SwaggerModule.createDocument(app, config);

  // Get /api endpoint to view the Swagger UI
  SwaggerModule.setup(SWAGGER_API_ENDPOINT, app, document);

  await app.listen(PORT);
  console.log(`Server is running on: http://localhost:${PORT}`);
}
bootstrap();
