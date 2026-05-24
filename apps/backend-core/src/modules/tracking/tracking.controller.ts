import { Request, Response } from 'express';
import { TrackingService } from './tracking.service';
import { logger } from '../../common/helpers/logger';
import { ApiResponse } from '../../common/helpers/response';
import { updateLocationSchema } from '../../validators';
import { AuthRequest } from '../../common/middleware/auth.middleware';

export class TrackingController {
  private trackingService = new TrackingService();

  updateLocation = async (req: AuthRequest, res: Response) => {
    try {
      const jobId = req.params.jobId;
      const { latitude, longitude, heading } = updateLocationSchema.parse(req.body);
      
      const tracking = await this.trackingService.updateJobLocation(
        jobId,
        latitude,
        longitude,
        heading
      );
      return ApiResponse.success(res, 'Location updated successfully', tracking);
    } catch (error: any) {
      logger.error('Update location error:', error);
      return ApiResponse.error(res, error.message || 'Invalid request', error.errors || []);
    }
  };

  getLocation = async (req: AuthRequest, res: Response) => {
    try {
      const jobId = req.params.jobId;
      const tracking = await this.trackingService.getJobLocation(jobId);
      return ApiResponse.success(res, 'Location fetched successfully', tracking);
    } catch (error: any) {
      logger.error('Get location error:', error);
      return ApiResponse.error(res, error.message || 'Location not found', [], 404);
    }
  };

  getNearbyWorkers = async (req: AuthRequest, res: Response) => {
    try {
      const lat = parseFloat(req.query.lat as string);
      const lng = parseFloat(req.query.lng as string);
      
      if (isNaN(lat) || isNaN(lng)) {
        return ApiResponse.error(res, 'Valid latitude and longitude are required');
      }

      const workers = await this.trackingService.getNearbyWorkers(lat, lng);
      return ApiResponse.success(res, 'Nearby workers fetched successfully', workers);
    } catch (error: any) {
      logger.error('Get nearby workers error:', error);
      return ApiResponse.error(res, 'Failed to fetch workers', [], 500);
    }
  };
}
