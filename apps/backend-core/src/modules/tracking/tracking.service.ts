import { TrackingRepository } from './tracking.repository';
import { socketGateway } from '../../server';

export class TrackingService {
  private trackingRepository = new TrackingRepository();

  async updateJobLocation(jobId: string, latitude: number, longitude: number, heading?: number, speed?: number) {
    const tracking = await this.trackingRepository.upsertJobTracking(jobId, {
      latitude,
      longitude,
      heading,
      speed,
    });

    // Emit live location update to the job room
    socketGateway.emitToJob(jobId, 'tracking:location_update', {
      jobId,
      latitude,
      longitude,
      heading,
      speed,
    });

    return tracking;
  }

  async getJobLocation(jobId: string) {
    const tracking = await this.trackingRepository.getJobTracking(jobId);
    if (!tracking) throw new Error('Tracking not found for this job');
    return tracking;
  }

  async getNearbyWorkers(latitude: number, longitude: number, radiusKm: number = 5) {
    return this.trackingRepository.getNearbyWorkers(latitude, longitude, radiusKm);
  }
}
