import { Request, Response } from 'express';
import { prisma } from '../../server';

export class WalletController {
  async getWallet(req: Request, res: Response) {
    const userId = req.user!.userId;

    res.status(200).json({
      status: 'success',
      data: {
        wallet: {
          id: 'wallet-id',
          balance: 0,
          currency: 'USD',
        },
      },
    });
  }

  async getTransactions(req: Request, res: Response) {
    res.status(200).json({
      status: 'success',
      data: { transactions: [] },
    });
  }
}