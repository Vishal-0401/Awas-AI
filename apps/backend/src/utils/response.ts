import { Response } from 'express';

export interface ApiEnvelope<T> {
  success: boolean;
  message: string;
  data: T | null;
  error?: {
    code: string | number;
    details: unknown;
  };
}

export const ok = <T>(res: Response, data: T, message = 'OK', status = 200): Response<ApiEnvelope<T>> => {
  return res.status(status).json({ success: true, message, data });
};

export const created = <T>(res: Response, data: T, message = 'Created'): Response<ApiEnvelope<T>> => {
  return ok(res, data, message, 201);
};
