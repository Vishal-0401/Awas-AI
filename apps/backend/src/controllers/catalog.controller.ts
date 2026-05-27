import { Request, Response } from 'express';
import { catalogService } from '../services/catalog.service';
import { ok } from '../utils/response';

export class CatalogController {
  categories = async (_req: Request, res: Response): Promise<void> => {
    ok(res, catalogService.listCategories());
  };

  services = async (req: Request, res: Response): Promise<void> => {
    const query = req.query as { categoryId?: string; q?: string };
    ok(res, catalogService.listServices(query.categoryId, query.q));
  };
}
