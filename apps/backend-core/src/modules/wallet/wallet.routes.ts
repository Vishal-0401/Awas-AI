import { Router } from 'express';
import { WalletController } from './wallet.controller';
import { authenticate } from '../../common/middleware/auth.middleware';

const router = Router();
const walletController = new WalletController();

router.use(authenticate);

router.get('/', walletController.getWallet);
router.get('/transactions', walletController.getTransactions);

export const walletRoutes = router;
