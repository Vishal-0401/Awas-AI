import { PrismaClient, AiDiagnostic, Prisma } from '@prisma/client';
import { prisma } from '../../server';

export class AiRepository {
  async saveDiagnostic(data: Prisma.AiDiagnosticCreateInput): Promise<AiDiagnostic> {
    return prisma.aiDiagnostic.create({ data });
  }

  async getDiagnosticHistory(userId: string): Promise<AiDiagnostic[]> {
    return prisma.aiDiagnostic.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' }
    });
  }
}
