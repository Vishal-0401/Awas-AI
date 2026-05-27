export interface SmsProvider {
  sendOtp(phone: string, otp: string): Promise<void>;
}

export class ConsoleSmsProvider implements SmsProvider {
  async sendOtp(phone: string, otp: string): Promise<void> {
    console.log(`[sms] OTP for ${phone}: ${otp}`);
  }
}
