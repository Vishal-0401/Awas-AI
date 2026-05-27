import { Router } from 'express';
import multer from 'multer';
import path from 'path';
import { AiController } from '../controllers/ai.controller';
import { authenticate, requireRoles } from '../middleware/auth';
import { asyncHandler } from '../utils/asyncHandler';

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, path.resolve(process.cwd(), 'uploads')),
  filename: (_req, file, cb) => cb(null, `${Date.now()}-${file.originalname.replace(/[^a-zA-Z0-9.]+/g, '-')}`)
});

const upload = multer({
  storage,
  limits: { fileSize: 10 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => {
    cb(null, file.mimetype.startsWith('image/'));
  }
});

const router = Router();
const controller = new AiController();

router.use(authenticate, requireRoles('CUSTOMER'));
router.post('/diagnostics', upload.single('image'), asyncHandler(controller.createDiagnostic));
router.get('/history', asyncHandler(controller.history));
router.get('/diagnostics/:id', asyncHandler(controller.get));
router.get('/reports/:id', asyncHandler(controller.get));

export default router;
