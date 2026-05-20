import { Request, Response } from 'express';

export class PaymentController {
  async charge(req: Request, res: Response) {
    res.status(200).json({
      status: 'success',
      message: 'Payment processed',
      data: { transactionId: 'txn-id' },
    });
  }

  async getPaymentHistory(req: Request, res: Response) {
    res.status(200).json({
      status: 'success',
      data: { payments: [] },
    });
  }
}