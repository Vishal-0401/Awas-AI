import { Response } from 'express';
import { BookingService } from './booking.service';
import { logger } from '../../common/helpers/logger';
import { ApiResponse } from '../../common/helpers/response';
import { AuthRequest } from '../../common/middleware/auth.middleware';
import { createBookingSchema } from '../../validators';

export class BookingController {
  private bookingService = new BookingService();

  getCategories = async (req: AuthRequest, res: Response) => {
    try {
      const categories = await this.bookingService.getCategories();
      return ApiResponse.success(res, 'Categories fetched successfully', categories);
    } catch (error: any) {
      logger.error('Get categories error:', error);
      return ApiResponse.error(res, 'Failed to fetch categories', [], 500);
    }
  };

  getServices = async (req: AuthRequest, res: Response) => {
    try {
      const services = await this.bookingService.getServices();
      return ApiResponse.success(res, 'Services fetched successfully', services);
    } catch (error: any) {
      logger.error('Get services error:', error);
      return ApiResponse.error(res, 'Failed to fetch services', [], 500);
    }
  };

  createBooking = async (req: AuthRequest, res: Response) => {
    try {
      const userId = req.user!.userId;
      const data = createBookingSchema.parse(req.body);
      const booking = await this.bookingService.createBooking(userId, {
        ...data,
        scheduledFor: new Date(data.scheduledFor)
      });
      return ApiResponse.success(res, 'Booking created successfully', booking, 201);
    } catch (error: any) {
      logger.error('Create booking error:', error);
      return ApiResponse.error(res, error.message || 'Failed to create booking', error.errors || []);
    }
  };

  getCustomerBookings = async (req: AuthRequest, res: Response) => {
    try {
      const userId = req.user!.userId;
      const bookings = await this.bookingService.getCustomerBookings(userId);
      return ApiResponse.success(res, 'Bookings fetched successfully', bookings);
    } catch (error: any) {
      logger.error('Get bookings error:', error);
      return ApiResponse.error(res, 'Failed to fetch bookings', [], 500);
    }
  };

  getBookingById = async (req: AuthRequest, res: Response) => {
    try {
      const bookingId = req.params.id;
      const booking = await this.bookingService.getBookingById(bookingId);
      
      // Security check: ensure user owns this booking (or is worker/admin)
      if (booking.customerId !== req.user!.userId && req.user!.role === 'CUSTOMER') {
        return ApiResponse.error(res, 'Forbidden access to this booking', [], 403);
      }

      return ApiResponse.success(res, 'Booking fetched successfully', booking);
    } catch (error: any) {
      logger.error('Get booking by id error:', error);
      return ApiResponse.error(res, error.message || 'Booking not found', [], 404);
    }
  };
}
