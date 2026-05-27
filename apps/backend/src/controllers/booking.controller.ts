import { Request, Response } from 'express';
import { bookingService } from '../services/booking.service';
import { created, ok } from '../utils/response';

export class BookingController {
  create = async (req: Request, res: Response): Promise<void> => {
    created(res, bookingService.createBooking(req.user!.id, req.body), 'Booking created');
  };

  list = async (req: Request, res: Response): Promise<void> => {
    const query = req.query as { status?: 'active' | 'history' };
    ok(res, bookingService.list(req.user!.id, query.status));
  };

  detail = async (req: Request, res: Response): Promise<void> => {
    ok(res, bookingService.detail(req.user!.id, req.params.id as string));
  };

  cancel = async (req: Request, res: Response): Promise<void> => {
    ok(res, bookingService.cancel(req.user!.id, req.params.id as string, req.body.reason as string), 'Booking cancelled');
  };

  payEscrow = async (req: Request, res: Response): Promise<void> => {
    ok(res, bookingService.payEscrow(req.user!.id, req.params.id as string), 'Escrow held');
  };
}
