import { Router } from 'express';
import { CatalogController } from '../controllers/catalog.controller';
import { authenticate } from '../middleware/auth';
import { validateQuery } from '../middleware/validate';
import { servicesQuerySchema } from '../validators/schemas';
import { asyncHandler } from '../utils/asyncHandler';

const router = Router();
const controller = new CatalogController();

router.get('/categories', authenticate, asyncHandler(controller.categories));
router.get('/services', authenticate, validateQuery(servicesQuerySchema), asyncHandler(controller.services));

export default router;
