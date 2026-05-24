import { Router } from 'express';
import { BookingController } from './booking.controller';
import { authenticate } from '../../common/middleware/auth.middleware';

const router = Router();
const bookingController = new BookingController();

router.use(authenticate);

// We keep categories and services here for simplicity, though they could be in a separate module
router.get('/categories', bookingController.getCategories);
router.get('/services', bookingController.getServices);

router.post('/', bookingController.createBooking);
router.get('/', bookingController.getCustomerBookings);
router.get('/:id', bookingController.getBookingById);

export const bookingRoutes = router;
