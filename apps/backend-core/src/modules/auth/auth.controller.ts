import { Request, Response } from 'express';
import { prisma } from '../../server';
import { hashPassword, comparePassword, generateToken, generateRefreshToken } from '../../common/utils/auth.utils';
import { logger } from '../../common/helpers/logger';

export class AuthController {
  async register(req: Request, res: Response) {
    try {
      const { email, phone, name, password, role } = req.body;

      const hashedPassword = await hashPassword(password);

      const user = await prisma.user.create({
        data: {
          email,
          phone,
          name,
          password: hashedPassword,
          role: role || 'CUSTOMER',
        },
      });

      const token = generateToken(user.id, user.role);
      const refreshToken = generateRefreshToken(user.id, user.role);

      return res.status(201).json({
        status: 'success',
        message: 'User registered successfully',
        data: {
          user: {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
          },
          token,
          refreshToken,
        },
      });
    } catch (error) {
      logger.error('Registration error:', error);
      return res.status(500).json({
        status: 'error',
        message: 'Registration failed',
      });
    }
  }

  async login(req: Request, res: Response) {
    try {
      const { emailOrPhone, password } = req.body;

      const user = await prisma.user.findFirst({
        where: {
          OR: [{ email: emailOrPhone }, { phone: emailOrPhone }],
        },
      });

      if (!user) {
        return res.status(401).json({
          status: 'error',
          message: 'Invalid credentials',
        });
      }

      const isValid = await comparePassword(password, user.password);

      if (!isValid) {
        return res.status(401).json({
          status: 'error',
          message: 'Invalid credentials',
        });
      }

      const token = generateToken(user.id, user.role);
      const refreshToken = generateRefreshToken(user.id, user.role);

      return res.status(200).json({
        status: 'success',
        message: 'Login successful',
        data: {
          user: {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
          },
          token,
          refreshToken,
        },
      });
    } catch (error) {
      logger.error('Login error:', error);
      return res.status(500).json({
        status: 'error',
        message: 'Login failed',
      });
    }
  }

  async refreshToken(req: Request, res: Response) {
    res.status(200).json({
      status: 'success',
      message: 'Token refresh endpoint',
    });
  }

  async logout(req: Request, res: Response) {
    res.status(200).json({
      status: 'success',
      message: 'Logged out successfully',
    });
  }
}