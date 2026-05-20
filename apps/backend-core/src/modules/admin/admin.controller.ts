import { Request, Response } from 'express';

export class AdminController {
  async getDashboard(req: Request, res: Response) {
    res.status(200).json({
      status: 'success',
      data: {
        stats: {
          users: 0,
          workers: 0,
          bookings: 0,
          revenue: 0,
        },
      },
    });
  }

  async getUsers(req: Request, res: Response) {
    res.status(200).json({
      status: 'success',
      data: { users: [] },
    });
  }
}