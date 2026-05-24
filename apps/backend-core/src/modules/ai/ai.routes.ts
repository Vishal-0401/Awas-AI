import { Router } from 'express';
import { AiController } from './ai.controller';
import { authenticate } from '../../common/middleware/auth.middleware';

const router = Router();
const aiController = new AiController();

router.use(authenticate);

router.post('/scan', aiController.scanAppliance);
router.post('/diagnostics', aiController.scanAppliance); // Fallback for similar usage
router.get('/history', aiController.getHistory);

export const aiRoutes = router;
