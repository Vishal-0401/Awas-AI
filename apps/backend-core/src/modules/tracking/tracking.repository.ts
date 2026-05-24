import { PrismaClient, JobTracking, Prisma } from '@prisma/client';
import { prisma } from '../../server';
import { JobTrackingEntity, WorkerLocationEntity } from '../../entities';

export class TrackingRepository {
  async upsertJobTracking(jobId: string, data: Partial<JobTrackingEntity>): Promise<JobTracking> {
    return prisma.jobTracking.upsert({
      where: { jobId },
      update: {
        latitude: data.latitude!,
        longitude: data.longitude!,
        heading: data.heading,
        speed: data.speed,
      },
      create: {
        job: { connect: { id: jobId } },
        latitude: data.latitude!,
        longitude: data.longitude!,
        heading: data.heading,
        speed: data.speed,
      },
    });
  }

  async getJobTracking(jobId: string): Promise<JobTracking | null> {
    return prisma.jobTracking.findUnique({
      where: { jobId }
    });
  }

  // Placeholder for worker active locations (can be Redis in a real highly scalable app)
  async getNearbyWorkers(latitude: number, longitude: number, radiusKm: number): Promise<WorkerLocationEntity[]> {
    // In a real app, use PostGIS or Redis Geo queries. 
    // Here we return mock data that satisfies the entity.
    return [
      {
        workerId: 'worker-1',
        latitude: latitude + 0.01,
        longitude: longitude + 0.01,
        heading: 90,
        isOnline: true,
        lastUpdated: new Date()
      },
      {
        workerId: 'worker-2',
        latitude: latitude - 0.005,
        longitude: longitude - 0.005,
        heading: 180,
        isOnline: true,
        lastUpdated: new Date()
      }
    ];
  }
}
