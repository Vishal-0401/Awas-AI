import { NextFunction, Request, Response } from 'express';
import { ZodType } from 'zod';

export const validateBody = <T>(schema: ZodType<T>) => {
  return (req: Request, _res: Response, next: NextFunction): void => {
    req.body = schema.parse(req.body);
    next();
  };
};

export const validateQuery = <T>(schema: ZodType<T>) => {
  return (req: Request, _res: Response, next: NextFunction): void => {
    req.query = schema.parse(req.query) as Request['query'];
    next();
  };
};
