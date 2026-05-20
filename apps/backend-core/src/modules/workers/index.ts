import { Router } from 'express';
import { WorkerController } from './workers.controller';
import { authGuard, roleGuard } from '../../common/guards/auth.guard';
import { Role } from '@prisma/client';

const router = Router();
const workerController = new WorkerController();

router.get('/nearby', authGuard, workerController.getNearbyWorkers);
router.get('/:id', workerController.getWorker);
router.put('/profile', authGuard, roleGuard(Role.WORKER), workerController.updateWorkerProfile);

export default router;