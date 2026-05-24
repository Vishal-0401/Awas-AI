import { Response } from 'express';

export class ApiResponse {
  static success(res: Response, message: string, data: any = {}, statusCode: number = 200) {
    return res.status(statusCode).json({
      success: true,
      message,
      data,
    });
  }

  static error(res: Response, message: string, errorDetails: any = null, statusCode: number = 400) {
    return res.status(statusCode).json({
      success: false,
      message,
      error: {
        code: statusCode,
        details: errorDetails
      },
    });
  }
}
