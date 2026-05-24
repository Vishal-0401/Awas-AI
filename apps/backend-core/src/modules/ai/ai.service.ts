import { AiRepository } from './ai.repository';

export class AiService {
  private aiRepository = new AiRepository();

  async processScan(userId: string, imageUrl: string) {
    // Placeholder for AI/OCR logic
    const mockOcrText = "SN: 123456789 MODEL: AC-2023";
    const mockAnalysis = {
      applianceType: "Air Conditioner",
      brand: "CoolTech",
      estimatedAge: "2 years",
      issuesFound: ["Dust accumulation", "Low refrigerant pressure"]
    };
    const mockHealthScore = 75;

    return this.aiRepository.saveDiagnostic({
      user: { connect: { id: userId } },
      imageUrl,
      ocrRawText: mockOcrText,
      analysisResult: mockAnalysis,
      healthScore: mockHealthScore
    });
  }

  async getDiagnosticHistory(userId: string) {
    return this.aiRepository.getDiagnosticHistory(userId);
  }
}
