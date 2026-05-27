import { Request, Response } from 'express';
import { dashboardService } from '../services/dashboard.service';
import { ok } from '../utils/response';

export class DashboardController {
  get = async (req: Request, res: Response): Promise<void> => {
    ok(res, dashboardService.getDashboard(req.user!.id));
  };
}
