import { PrismaClient, Wallet, Transaction, Prisma } from '@prisma/client';
import { prisma } from '../../server';

export class WalletRepository {
  async findWalletByUserId(userId: string): Promise<Wallet | null> {
    return prisma.wallet.findUnique({
      where: { userId },
    });
  }

  async createWallet(userId: string): Promise<Wallet> {
    return prisma.wallet.create({
      data: { userId }
    });
  }

  async findTransactionsByWalletId(walletId: string): Promise<Transaction[]> {
    return prisma.transaction.findMany({
      where: { walletId },
      orderBy: { createdAt: 'desc' }
    });
  }
}
