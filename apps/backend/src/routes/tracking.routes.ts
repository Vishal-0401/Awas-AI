import { Router } from 'express';
import { TrackingController } from '../controllers/tracking.controller';
import { authenticate, requireRoles } from '../middleware/auth';
import { validateBody, validateQuery } from '../middleware/validate';
import { nearbyQuerySchema, trackingUpdateSchema } from '../validators/schemas';
import { asyncHandler } from '../utils/asyncHandler';

const router = Router();
const controller = new TrackingController();

router.get('/nearby', authenticate, validateQuery(nearbyQuerySchema), asyncHandler(controller.nearby));
router.get('/jobs/:id', authenticate, requireRoles('CUSTOMER'), asyncHandler(controller.jobTracking));
router.post('/jobs/:id', authenticate, requireRoles('WORKER', 'ADMIN'), validateBody(trackingUpdateSchema), asyncHandler(controller.updateJobTracking));

export default router;
