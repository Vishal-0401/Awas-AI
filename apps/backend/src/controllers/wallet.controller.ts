import { Request, Response } from 'express';
import { walletService } from '../services/wallet.service';
import { ok } from '../utils/response';

export class WalletController {
  get = async (req: Request, res: Response): Promise<void> => {
    ok(res, walletService.getWallet(req.user!.id));
  };

  transactions = async (req: Request, res: Response): Promise<void> => {
    ok(res, walletService.listTransactions(req.user!.id));
  };

  topUp = async (req: Request, res: Response): Promise<void> => {
    ok(res, walletService.addMoney(req.user!.id, req.body.amount), 'Wallet topped up');
  };
}
