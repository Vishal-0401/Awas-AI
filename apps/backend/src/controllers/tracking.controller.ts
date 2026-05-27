import { Request, Response } from 'express';
import { bookingService } from '../services/booking.service';
import { dispatchService } from '../services/dispatch.service';
import { ok } from '../utils/response';

export class TrackingController {
  nearby = async (req: Request, res: Response): Promise<void> => {
    const query = req.query as unknown as { lat: number; lng: number; serviceId?: string };
    ok(res, await dispatchService.nearby(query.lat, query.lng, query.serviceId));
  };

  jobTracking = async (req: Request, res: Response): Promise<void> => {
    ok(res, bookingService.tracking(req.user!.id, req.params.id as string));
  };

  updateJobTracking = async (req: Request, res: Response): Promise<void> => {
    ok(res, bookingService.updateTracking(req.user!.id, req.params.id as string, req.body));
  };
}
