import { Router } from 'express';
import { AdminController } from './admin.controller';
import { authGuard, roleGuard } from '../../common/guards/auth.guard';
import { Role } from '@prisma/client';

const router = Router();
const adminController = new AdminController();

router.get('/dashboard', authGuard, roleGuard(Role.ADMIN), adminController.getDashboard);
router.get('/users', authGuard, roleGuard(Role.ADMIN), adminController.getUsers);

export default router;