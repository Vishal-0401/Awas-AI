import { Request, Response } from 'express';
import { prisma } from '../../server';

export class UserController {
  async getProfile(req: Request, res: Response) {
    const userId = req.user!.userId;

    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        email: true,
        phone: true,
        name: true,
        role: true,
        createdAt: true,
      },
    });

    if (!user) {
      return res.status(404).json({
        status: 'error',
        message: 'User not found',
      });
    }

    return res.status(200).json({
      status: 'success',
      data: { user },
    });
  }

  async updateProfile(req: Request, res: Response) {
    const userId = req.user!.userId;
    const { name, phone } = req.body;

    const user = await prisma.user.update({
      where: { id: userId },
      data: { name, phone },
    });

    return res.status(200).json({
      status: 'success',
      message: 'Profile updated',
      data: { user },
    });
  }
}