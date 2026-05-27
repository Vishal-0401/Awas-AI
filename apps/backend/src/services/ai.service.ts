import { AiDiagnosticDto } from '../dto/domain';
import { aiRepository, catalogRepository, newId, notificationRepository, timestamp } from '../repositories/store';
import { NotFoundAppError } from '../utils/AppError';
import { emitToUser } from './socketHub';

class AiService {
  createDiagnostic(userId: string, input: { imageUrl: string; applianceType?: string; applianceAssetId?: string }): AiDiagnosticDto {
    const diagnostic: AiDiagnosticDto = {
      id: newId(),
      userId,
      applianceAssetId: input.applianceAssetId,
      imageUrl: input.imageUrl,
      status: 'PROCESSING',
      applianceType: input.applianceType ?? 'ac',
      detectedIssues: [],
      recommendations: [],
      createdAt: timestamp()
    };
    aiRepository.save(diagnostic);
    emitToUser(userId, 'ai:diagnostic:processing', diagnostic);

    setTimeout(() => {
      this.completeDiagnostic(diagnostic.id);
    }, 1200);

    return diagnostic;
  }

  completeDiagnostic(diagnosticId: string): AiDiagnosticDto {
    const existing = aiRepository.findById(diagnosticId);
    if (!existing) throw new NotFoundAppError('Diagnostic not found');
    const recommendedService = catalogRepository.findService('svc_ac_repair');
    const updated: AiDiagnosticDto = {
      ...existing,
      status: 'COMPLETED',
      brand: 'LG',
      modelNumber: 'AS18VMC',
      confidenceScore: 0.98,
      healthScore: 65,
      detectedIssues: [
        {
          issue: 'filter_efficiency_drop',
          confidence: 0.91,
          severity: 'medium',
          description: 'Filter efficiency dropped to 65%. Replace soon.'
        }
      ],
      recommendations: [
        {
          serviceId: recommendedService?.id ?? 'svc_ac_repair',
          service: recommendedService?.name ?? 'AC Technician',
          priority: 'urgent',
          estimatedCostMin: 899,
          estimatedCostMax: 1499,
          description: 'Replace AC filter and inspect cooling line pressure.'
        }
      ],
      recommendation: 'Replace AC filter and run cooling efficiency inspection.',
      completedAt: timestamp()
    };
    aiRepository.save(updated);
    const notification = notificationRepository.create(existing.userId, 'AI diagnostic completed', 'Your appliance scan is ready.', 'predictive', { diagnosticId });
    emitToUser(existing.userId, 'ai:diagnostic:completed', updated);
    emitToUser(existing.userId, 'notification:new', notification);
    return updated;
  }

  get(userId: string, diagnosticId: string): AiDiagnosticDto {
    const diagnostic = aiRepository.findById(diagnosticId);
    if (!diagnostic || diagnostic.userId !== userId) throw new NotFoundAppError('Diagnostic not found');
    return diagnostic;
  }

  history(userId: string): AiDiagnosticDto[] {
    return aiRepository.listByUser(userId);
  }
}

export const aiService = new AiService();
