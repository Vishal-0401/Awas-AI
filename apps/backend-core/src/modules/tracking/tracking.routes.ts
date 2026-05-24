import { Router } from 'express';
import { TrackingController } from './tracking.controller';
import { authenticate } from '../../common/middleware/auth.middleware';

const router = Router();
const trackingController = new TrackingController();

router.use(authenticate);

router.get('/nearby', trackingController.getNearbyWorkers);
router.get('/:jobId/location', trackingController.getLocation);
router.post('/:jobId/location', trackingController.updateLocation);

export const trackingRoutes = router;
