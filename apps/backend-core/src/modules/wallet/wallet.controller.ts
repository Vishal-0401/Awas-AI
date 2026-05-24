import { Response } from 'express';
import { WalletService } from './wallet.service';
import { logger } from '../../common/helpers/logger';
import { ApiResponse } from '../../common/helpers/response';
import { AuthRequest } from '../../common/middleware/auth.middleware';

export class WalletController {
  private walletService = new WalletService();

  getWallet = async (req: AuthRequest, res: Response) => {
    try {
      const userId = req.user!.userId;
      const wallet = await this.walletService.getWallet(userId);
      return ApiResponse.success(res, 'Wallet fetched successfully', wallet);
    } catch (error: any) {
      logger.error('Get wallet error:', error);
      return ApiResponse.error(res, 'Failed to fetch wallet', [], 500);
    }
  };

  getTransactions = async (req: AuthRequest, res: Response) => {
    try {
      const userId = req.user!.userId;
      const transactions = await this.walletService.getTransactions(userId);
      return ApiResponse.success(res, 'Transactions fetched successfully', transactions);
    } catch (error: any) {
      logger.error('Get transactions error:', error);
      return ApiResponse.error(res, 'Failed to fetch transactions', [], 500);
    }
  };
}
