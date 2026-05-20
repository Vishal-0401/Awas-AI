import { Request, Response } from 'express';
import { prisma } from '../../server';

export class WorkerController {
  async getNearbyWorkers(req: Request, res: Response) {
    const { lat, lng, radius } = req.query;

    const workers = await prisma.worker.findMany({
      where: {
        availability: true,
      },
    });

    return res.status(200).json({
      status: 'success',
      data: { workers },
    });
  }

  async getWorker(req: Request, res: Response) {
    const { id } = req.params;

    const worker = await prisma.worker.findUnique({
      where: { id },
    });

    if (!worker) {
      return res.status(404).json({
        status: 'error',
        message: 'Worker not found',
      });
    }

    return res.status(200).json({
      status: 'success',
      data: { worker },
    });
  }

  async updateWorkerProfile(req: Request, res: Response) {
    const userId = req.user!.userId;
    const { skills, availability, latitude, longitude } = req.body;

    const worker = await prisma.worker.upsert({
      where: { userId },
      update: { skills, availability },
      create: {
        userId,
        skills: '[]',
        latitude,
        longitude,
      },
    });

    return res.status(200).json({
      status: 'success',
      message: 'Worker profile updated',
      data: { worker },
    });
  }
}