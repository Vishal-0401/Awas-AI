import { walletRepository } from '../repositories/store';
import { ValidationAppError } from '../utils/AppError';

class WalletService {
  getWallet(userId: string) {
    const wallet = walletRepository.findByUserId(userId);
    const transactions = walletRepository.listTransactions(wallet.id).slice(0, 10);
    return {
      ...wallet,
      totalBalance: wallet.availableBalance + wallet.escrowBalance,
      recentTransactions: transactions
    };
  }

  listTransactions(userId: string) {
    const wallet = walletRepository.findByUserId(userId);
    return walletRepository.listTransactions(wallet.id);
  }

  addMoney(userId: string, amount: number) {
    if (amount <= 0) throw new ValidationAppError('Amount must be positive');
    return walletRepository.mutateBalance(userId, amount, 'ADD_MONEY', 'CREDIT');
  }
}

export const walletService = new WalletService();
