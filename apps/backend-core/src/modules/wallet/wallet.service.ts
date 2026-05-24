import { WalletRepository } from './wallet.repository';

export class WalletService {
  private walletRepository = new WalletRepository();

  async getWallet(userId: string) {
    let wallet = await this.walletRepository.findWalletByUserId(userId);
    if (!wallet) {
      wallet = await this.walletRepository.createWallet(userId);
    }
    return wallet;
  }

  async getTransactions(userId: string) {
    const wallet = await this.getWallet(userId);
    return this.walletRepository.findTransactionsByWalletId(wallet.id);
  }
}
