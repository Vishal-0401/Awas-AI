import { getRedisClient } from '../config/redis';
import { WorkerDto } from '../dto/domain';
import { workerRepository } from '../repositories/store';

class DispatchService {
  async nearby(latitude: number, longitude: number, serviceId?: string): Promise<Array<WorkerDto & { etaMinutes: number; distanceKm: number }>> {
    const redis = await getRedisClient();
    const workers = workerRepository.listNearby(latitude, longitude, serviceId);

    if (redis) {
      await Promise.all(
        workers.map((worker) =>
          redis.geoAdd('workers:locations', {
            member: worker.id,
            longitude: worker.longitude,
            latitude: worker.latitude
          })
        )
      );
    }

    return workers.map((worker, index) => ({
      ...worker,
      etaMinutes: 10 + index * 5,
      distanceKm: Number((2.5 + index * 0.9).toFixed(1))
    }));
  }

  workerProfile(workerId: string): WorkerDto | undefined {
    return workerRepository.findById(workerId);
  }
}

export const dispatchService = new DispatchService();
