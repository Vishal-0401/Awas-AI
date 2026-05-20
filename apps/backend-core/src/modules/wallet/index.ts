import { Router } from 'express';
import { WalletController } from './wallet.controller';
import { authGuard } from '../../common/guards/auth.guard';

const router = Router();
const walletController = new WalletController();

router.get('/', authGuard, walletController.getWallet);
router.get('/transactions', authGuard, walletController.getTransactions);

export default router;