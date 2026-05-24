import { Router } from 'express';

export const healthRoutes = Router();

healthRoutes.get('/', async (req, res) => {
  res.status(200).json({
    status: 'success',
    message: 'Backend Core Service is running.',
    timestamp: new Date().toISOString(),
  });
});

