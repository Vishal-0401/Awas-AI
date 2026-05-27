import { Router } from 'express';
import { DashboardController } from '../controllers/dashboard.controller';
import { authenticate, requireRoles } from '../middleware/auth';
import { asyncHandler } from '../utils/asyncHandler';

const router = Router();
const controller = new DashboardController();

router.get('/', authenticate, requireRoles('CUSTOMER'), asyncHandler(controller.get));

export default router;
