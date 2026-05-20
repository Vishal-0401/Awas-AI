import { Router } from 'express';
import { JobController } from './jobs.controller';
import { authGuard, roleGuard } from '../../common/guards/auth.guard';
import { Role } from '@prisma/client';

const router = Router();
const jobController = new JobController();

router.get('/my-jobs', authGuard, jobController.getMyJobs);
router.get('/:id', authGuard, jobController.getJob);
router.put('/:id/status', authGuard, jobController.updateJobStatus);

export default router;