import { Router } from 'express';
import { BookingController } from '../controllers/booking.controller';
import { authenticate, requireRoles } from '../middleware/auth';
import { validateBody, validateQuery } from '../middleware/validate';
import { bookingListQuerySchema, cancelBookingSchema, createBookingSchema } from '../validators/schemas';
import { asyncHandler } from '../utils/asyncHandler';

const router = Router();
const controller = new BookingController();

router.use(authenticate, requireRoles('CUSTOMER'));
router.post('/', validateBody(createBookingSchema), asyncHandler(controller.create));
router.get('/', validateQuery(bookingListQuerySchema), asyncHandler(controller.list));
router.get('/:id', asyncHandler(controller.detail));
router.post('/:id/cancel', validateBody(cancelBookingSchema), asyncHandler(controller.cancel));
router.post('/:id/pay-escrow', asyncHandler(controller.payEscrow));

export default router;
