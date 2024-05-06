import { Injectable, Inject, Scope } from '@nestjs/common';
import { REQUEST } from '@nestjs/core';

export class HelpersService {
  public static rowsToArr(data: string[][]): object[] {
    const [keys, ...values] = data;
    return values.map((valuesArray) => {
      return valuesArray.reduce((acc, value, index) => {
        acc[keys[index]] = value;
        return acc;
      }, {});
    });
  }

  public static objectToRow(data: object): string[] {
    return Object.values(data);
  }
}
