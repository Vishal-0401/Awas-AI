import { Router } from 'express';
import { TelemetryController } from './telemetry.controller';
import { authGuard } from '../../common/guards/auth.guard';

const router = Router();
const telemetryController = new TelemetryController();

router.post('/events', telemetryController.trackEvent);

export default router;