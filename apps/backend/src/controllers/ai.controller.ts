import { Request, Response } from 'express';
import { env } from '../config/env';
import { aiService } from '../services/ai.service';
import { created, ok } from '../utils/response';
import { ValidationAppError } from '../utils/AppError';

export class AiController {
  createDiagnostic = async (req: Request, res: Response): Promise<void> => {
    if (!req.file) throw new ValidationAppError('Image is required');
    const imageUrl = `${env.objectStorageBaseUrl}/${req.file.filename}`;
    created(
      res,
      aiService.createDiagnostic(req.user!.id, {
        imageUrl,
        applianceType: req.body.applianceType as string | undefined,
        applianceAssetId: req.body.applianceAssetId as string | undefined
      }),
      'Diagnostic queued'
    );
  };

  history = async (req: Request, res: Response): Promise<void> => {
    ok(res, aiService.history(req.user!.id));
  };

  get = async (req: Request, res: Response): Promise<void> => {
    ok(res, aiService.get(req.user!.id, req.params.id as string));
  };
}
