import { Request, Response } from 'express';
import { prisma } from '../../server';

export class JobController {
  async getMyJobs(req: Request, res: Response) {
    const userId = req.user!.userId;
    const role = req.user!.role;

    const jobs = await prisma.job.findMany({
      where: role === 'WORKER' ? { workerId: userId } : {},
      include: {
        booking: true,
      },
    });

    return res.status(200).json({
      status: 'success',
      data: { jobs },
    });
  }

  async getJob(req: Request, res: Response) {
    const { id } = req.params;

    const job = await prisma.job.findUnique({
      where: { id },
      include: {
        booking: true,
        worker: true,
      },
    });

    if (!job) {
      return res.status(404).json({
        status: 'error',
        message: 'Job not found',
      });
    }

    return res.status(200).json({
      status: 'success',
      data: { job },
    });
  }

  async updateJobStatus(req: Request, res: Response) {
    const { id } = req.params;
    const { status } = req.body;

    const job = await prisma.job.update({
      where: { id },
      data: { status },
    });

    return res.status(200).json({
      status: 'success',
      message: 'Job status updated',
      data: { job },
    });
  }
}