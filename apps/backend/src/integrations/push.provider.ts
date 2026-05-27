export interface PushPayload {
  userId: string;
  title: string;
  body: string;
  data?: Record<string, string>;
}

export class ConsolePushProvider {
  async send(payload: PushPayload): Promise<void> {
    console.log('[push]', payload);
  }
}
