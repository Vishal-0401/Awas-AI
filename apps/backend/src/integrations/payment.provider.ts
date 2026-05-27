export interface PaymentWebhookPayload {
  reference: string;
  status: 'SUCCESS' | 'FAILED';
  amount: number;
}

export class MockPaymentProvider {
  verifyWebhook(payload: PaymentWebhookPayload): PaymentWebhookPayload {
    return payload;
  }
}
