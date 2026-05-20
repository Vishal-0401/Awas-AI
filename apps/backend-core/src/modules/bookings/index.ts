import { Router } from 'express';
import { BookingController } from './bookings.controller';
import { authGuard, roleGuard } from '../../common/guards/auth.guard';
import { Role } from '@prisma/client';

const router = Router();
const bookingController = new BookingController();

router.post('/', authGuard, roleGuard(Role.CUSTOMER), bookingController.createBooking);
router.get('/', authGuard, bookingController.getBookings);
router.get('/:id', authGuard, bookingController.getBooking);
router.put('/:id', authGuard, bookingController.updateBooking);

export default router;