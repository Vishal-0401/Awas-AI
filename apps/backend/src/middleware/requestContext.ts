import { NextFunction, Request, Response } from 'express';
import { randomUUID } from 'crypto';

export const requestContext = (req: Request, res: Response, next: NextFunction): void => {
  const requestId = req.header('x-request-id') ?? randomUUID();
  res.setHeader('x-request-id', requestId);
  next();
};
