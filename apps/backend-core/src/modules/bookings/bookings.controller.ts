import { Request, Response } from 'express';
import { prisma } from '../../server';

export class BookingController {
  async createBooking(req: Request, res: Response) {
    const customerId = req.user!.userId;
    const { serviceType, scheduledDate, address, notes } = req.body;

    const booking = await prisma.booking.create({
      data: {
        customerId,
        serviceType,
        scheduledDate: new Date(scheduledDate),
        address,
        notes,
      },
    });

    return res.status(201).json({
      status: 'success',
      message: 'Booking created',
      data: { booking },
    });
  }

  async getBookings(req: Request, res: Response) {
    const userId = req.user!.userId;
    const role = req.user!.role;

    const bookings = await prisma.booking.findMany({
      where: role === 'CUSTOMER' ? { customerId: userId } : {},
    });

    return res.status(200).json({
      status: 'success',
      data: { bookings },
    });
  }

  async getBooking(req: Request, res: Response) {
    const { id } = req.params;
    const userId = req.user!.userId;
    const role = req.user!.role;

    const booking = await prisma.booking.findFirst({
      where: {
        id,
        ...(role === 'CUSTOMER' ? { customerId: userId } : {}),
      },
    });

    if (!booking) {
      return res.status(404).json({
        status: 'error',
        message: 'Booking not found',
      });
    }

    return res.status(200).json({
      status: 'success',
      data: { booking },
    });
  }

  async updateBooking(req: Request, res: Response) {
    const { id } = req.params;
    const { status, address, scheduledDate } = req.body;

    const booking = await prisma.booking.update({
      where: { id },
      data: { status, address, scheduledDate: scheduledDate ? new Date(scheduledDate) : undefined },
    });

    return res.status(200).json({
      status: 'success',
      message: 'Booking updated',
      data: { booking },
    });
  }
}