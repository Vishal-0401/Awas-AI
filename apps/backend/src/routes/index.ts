import { Router } from 'express';
import authRoutes from './auth.routes';
import userRoutes from './user.routes';
import dashboardRoutes from './dashboard.routes';
import catalogRoutes from './catalog.routes';
import trackingRoutes from './tracking.routes';
import bookingRoutes from './booking.routes';
import walletRoutes from './wallet.routes';
import aiRoutes from './ai.routes';
import notificationRoutes from './notification.routes';
import chatRoutes from './chat.routes';

const router = Router();

router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/dashboard', dashboardRoutes);
router.use('/', catalogRoutes);
router.use('/tracking', trackingRoutes);
router.use('/bookings', bookingRoutes);
router.use('/wallet', walletRoutes);
router.use('/ai', aiRoutes);
router.use('/notifications', notificationRoutes);
router.use('/chats', chatRoutes);

export default router;
