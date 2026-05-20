import { Request, Response } from 'express';

export class TelemetryController {
  async trackEvent(req: Request, res: Response) {
    res.status(200).json({
      status: 'success',
      message: 'Event tracked',
    });
  }
}