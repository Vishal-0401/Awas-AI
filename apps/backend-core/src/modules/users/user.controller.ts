import { Response } from 'express';
import { UserService } from './user.service';
import { logger } from '../../common/helpers/logger';
import { ApiResponse } from '../../common/helpers/response';
import { AuthRequest } from '../../common/middleware/auth.middleware';
import { updateProfileSchema, addressSchema } from '../../validators';

export class UserController {
  private userService = new UserService();

  getProfile = async (req: AuthRequest, res: Response) => {
    try {
      const userId = req.user!.userId;
      const profile = await this.userService.getProfile(userId);
      return ApiResponse.success(res, 'Profile fetched successfully', profile);
    } catch (error: any) {
      logger.error('Get profile error:', error);
      return ApiResponse.error(res, error.message || 'Profile not found', [], 404);
    }
  };

  updateProfile = async (req: AuthRequest, res: Response) => {
    try {
      const userId = req.user!.userId;
      const data = updateProfileSchema.parse(req.body);
      const updatedProfile = await this.userService.updateProfile(userId, data);
      return ApiResponse.success(res, 'Profile updated successfully', updatedProfile);
    } catch (error: any) {
      logger.error('Update profile error:', error);
      return ApiResponse.error(res, error.message || 'Update failed', error.errors || []);
    }
  };

  addAddress = async (req: AuthRequest, res: Response) => {
    try {
      const userId = req.user!.userId;
      const data = addressSchema.parse(req.body);
      const address = await this.userService.addAddress(userId, data);
      return ApiResponse.success(res, 'Address added successfully', address, 201);
    } catch (error: any) {
      logger.error('Add address error:', error);
      return ApiResponse.error(res, error.message || 'Failed to add address', error.errors || []);
    }
  };

  getAddresses = async (req: AuthRequest, res: Response) => {
    try {
      const userId = req.user!.userId;
      const addresses = await this.userService.getAddresses(userId);
      return ApiResponse.success(res, 'Addresses fetched successfully', addresses);
    } catch (error: any) {
      logger.error('Get addresses error:', error);
      return ApiResponse.error(res, 'Failed to fetch addresses', [], 500);
    }
  };
}
