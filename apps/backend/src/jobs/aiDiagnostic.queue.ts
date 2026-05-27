export interface AiDiagnosticJobPayload {
  diagnosticId: string;
  userId: string;
}

class InProcessAiDiagnosticQueue {
  private readonly jobs: AiDiagnosticJobPayload[] = [];

  async add(_name: string, payload: AiDiagnosticJobPayload): Promise<AiDiagnosticJobPayload> {
    this.jobs.push(payload);
    return payload;
  }

  pending(): AiDiagnosticJobPayload[] {
    return [...this.jobs];
  }
}

export const aiDiagnosticQueue = new InProcessAiDiagnosticQueue();
