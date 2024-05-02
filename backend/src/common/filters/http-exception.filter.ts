import { HttpException, HttpStatus, Logger } from '@nestjs/common';
import { Request, Response } from 'express';
import { Catch, ExceptionFilter, ArgumentsHost } from '@nestjs/common';
import { INTERNAL_SERVER_ERROR } from '../../constants';

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: HttpException, host: ArgumentsHost) {
    console.log('exception', exception.message);
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();
    const status =
      exception instanceof HttpException
        ? exception.getStatus()
        : HttpStatus.INTERNAL_SERVER_ERROR;


    Logger.error(
      `${request.method} ${request.url}`,
      JSON.stringify(exception.message),
      'ExceptionFilter',
    );

    response.status(status).send({
      statusCode: status,
      timestamp: new Date().toISOString(),
      path: request.url,
      message: exception.message || exception ||INTERNAL_SERVER_ERROR,
    });
  }
}
