import { HttpException, HttpStatus } from '@nestjs/common';
import { MISSING_GSHETS_PARAMS } from '../../constants';

export function ValidateGSheetsParams(isDataRead: boolean = false) {
  return function (
    target: any,
    propertyKey: string,
    descriptor: PropertyDescriptor,
  ) {
    const originalMethod = descriptor.value;
    descriptor.value = async function (...args: any[]) {
      const { spreadsheetId, range, sheetName } = args[0];
      if (isDataRead && !args[0].data) {
        throw new HttpException(
          'Missing data parameter',
          HttpStatus.BAD_REQUEST,
        );
      }

      // if (!spreadsheetId || !range || !data) {
      //   throw new HttpException(MISSING_GSHETS_PARAMS, HttpStatus.BAD_REQUEST);
      // }
      if (!spreadsheetId)
        throw new HttpException(
          'Missing spreadsheetId parameter',
          HttpStatus.BAD_REQUEST,
        );
      if (!sheetName)
        throw new HttpException(
          'Missing sheetName parameter',
          HttpStatus.BAD_REQUEST,
        );
      if (!range)
        throw new HttpException(
          'Missing range parameter',
          HttpStatus.BAD_REQUEST,
        );

      return await originalMethod.apply(this, args);
    };
    return descriptor;
  };
}
