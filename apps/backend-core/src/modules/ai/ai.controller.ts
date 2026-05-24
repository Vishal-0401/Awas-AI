import { Response } from 'express';
import { AiService } from './ai.service';
import { logger } from '../../common/helpers/logger';
import { ApiResponse } from '../../common/helpers/response';
import { scanSchema } from '../../validators';
import { AuthRequest } from '../../common/middleware/auth.middleware';

export class AiController {
  private aiService = new AiService();

  scanAppliance = async (req: AuthRequest, res: Response) => {
    try {
      const userId = req.user!.userId;
      const { imageUrl } = scanSchema.parse(req.body);
      const diagnostic = await this.aiService.processScan(userId, imageUrl);
      return ApiResponse.success(res, 'Scan processed successfully', diagnostic);
    } catch (error: any) {
      logger.error('Scan appliance error:', error);
      return ApiResponse.error(res, error.message || 'Scan failed', error.errors || []);
    }
  };

  getHistory = async (req: AuthRequest, res: Response) => {
    try {
      const userId = req.user!.userId;
      const history = await this.aiService.getDiagnosticHistory(userId);
      return ApiResponse.success(res, 'Diagnostic history fetched successfully', history);
    } catch (error: any) {
      logger.error('Get AI history error:', error);
      return ApiResponse.error(res, 'Failed to fetch diagnostic history', [], 500);
    }
  };
}
