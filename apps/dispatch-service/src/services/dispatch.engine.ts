/**
 * Dispatch Engine
 * ===============
 * Core Uber-like dispatch algorithm with Redis geo-spatial indexing.
 * Handles worker search, job assignment, and distributed locking.
 */

import { RedisService } from './redis.service';
import { logger } from '../utils/logger';

export interface WorkerLocation {
  workerId: string;
  userId: string;
  latitude: number;
  longitude: number;
  status: 'online' | 'available' | 'busy' | 'on_job';
  category?: string[];
  rating?: number;
  lastUpdate: Date;
}

export interface JobRequest {
  jobId: string;
  customerId: string;
  serviceType: string;
  latitude: number;
  longitude: number;
  priority?: 'normal' | 'urgent' | 'emergency';
  createdAt: Date;
}

export class DispatchEngine {
  private static instance: DispatchEngine;
  private static activeWorkers = new Map<string, WorkerLocation>();
  private static pendingJobs = new Map<string, JobRequest>();
  private static jobLocks = new Map<string, string>(); // jobId -> workerId

  static async initialize() {
    logger.info('Initializing dispatch engine');
    
    // Load active workers from Redis on startup
    await this.loadActiveWorkers();
    
    // Start cleanup interval
    setInterval(() => this.cleanupStaleWorkers(), 30000); // Every 30 seconds
  }

  /**
   * Register worker location in Redis geo index
   */
  static async updateWorkerLocation(worker: WorkerLocation) {
    const redis = RedisService.getInstance();
    
    // Store in Redis Geo
    await redis.geoAdd('workers:locations', {
      member: worker.workerId,
      longitude: worker.longitude,
      latitude: worker.latitude,
    });

    // Store worker metadata
    await redis.setEx(
      `worker:${worker.workerId}:meta`,
      300, // 5 minute TTL
      JSON.stringify(worker)
    );

    // Update in-memory cache
    this.activeWorkers.set(worker.workerId, worker);
  }

  /**
   * Find nearest available workers using Redis GEORADIUS
   */
  static async findNearbyWorkers(
    latitude: number,
    longitude: number,
    radius: number = 5000, // 5km default
    serviceType?: string,
    limit: number = 10
  ): Promise<WorkerLocation[]> {
    const redis = RedisService.getInstance();

    // Search Redis geo index
    const nearbyWorkerIds = await redis.geoRadius('workers:locations', {
      longitude,
      latitude,
      radius: { value: radius, unit: 'm' },
      count: limit * 2, // Get more to filter
    });

    const workers: WorkerLocation[] = [];

    for (const workerId of nearbyWorkerIds) {
      const meta = await redis.get(`worker:${workerId}:meta`);
      if (meta) {
        const worker = JSON.parse(meta) as WorkerLocation;
        
        // Filter by status
        if (worker.status !== 'available') continue;
        
        // Filter by service category
        if (serviceType && worker.category && !worker.category.includes(serviceType)) {
          continue;
        }

        // Check if worker is still active (last update within 5 minutes)
        const lastUpdate = new Date(worker.lastUpdate);
        const fiveMinutesAgo = new Date(Date.now() - 5 * 60 * 1000);
        if (lastUpdate < fiveMinutesAgo) continue;

        workers.push(worker);
      }
    }

    // Sort by distance and rating
    return workers
      .sort((a, b) => {
        const distA = this.calculateDistance(latitude, longitude, a.latitude, a.longitude);
        const distB = this.calculateDistance(latitude, longitude, b.latitude, b.longitude);
        
        // Weight: 70% distance, 30% rating
        const scoreA = distA * 0.7 - (a.rating || 4) * 0.3;
        const scoreB = distB * 0.7 - (b.rating || 4) * 0.3;
        
        return scoreA - scoreB;
      })
      .slice(0, limit);
  }

  /**
   * Create job and broadcast to nearby workers
   */
  static async createJob(job: JobRequest): Promise<string> {
    // Store job
    this.pendingJobs.set(job.jobId, job);
    
    // Set job expiration (auto-cancel after 60 seconds)
    setTimeout(() => {
      if (this.pendingJobs.has(job.jobId)) {
        this.cancelJob(job.jobId, 'timeout');
      }
    }, 60000);

    // Find nearby workers
    const nearbyWorkers = await this.findNearbyWorkers(
      job.latitude,
      job.longitude,
      5000,
      job.serviceType,
      10
    );

    logger.info('Job created, broadcasting to workers', {
      jobId: job.jobId,
      workerCount: nearbyWorkers.length,
    });

    return job.jobId;
  }

  /**
   * Accept job with distributed lock (first accept wins)
   */
  static async acceptJob(jobId: string, workerId: string): Promise<boolean> {
    // Check if job exists
    const job = this.pendingJobs.get(jobId);
    if (!job) {
      logger.warn('Job not found', { jobId });
      return false;
    }

    // Try to acquire lock
    const lockKey = `job:${jobId}:lock`;
    const redis = RedisService.getInstance();
    const acquired = await redis.set(lockKey, workerId, {
      NX: true, // Only set if not exists
      EX: 30,   // 30 second lock
    });

    if (!acquired) {
      logger.info('Job already accepted by another worker', { jobId, workerId });
      return false;
    }

    // Remove from pending
    this.pendingJobs.delete(jobId);
    this.jobLocks.set(jobId, workerId);

    // Update worker status
    const worker = this.activeWorkers.get(workerId);
    if (worker) {
      worker.status = 'on_job';
      worker.currentJobId = jobId;
    }

    logger.info('Job accepted', { jobId, workerId });
    return true;
  }

  /**
   * Cancel job
   */
  static cancelJob(jobId: string, reason: string) {
    this.pendingJobs.delete(jobId);
    this.jobLocks.delete(jobId);
    
    logger.info('Job cancelled', { jobId, reason });
  }

  /**
   * Complete job
   */
  static completeJob(jobId: string, workerId: string) {
    this.jobLocks.delete(jobId);
    
    // Update worker status back to available
    const worker = this.activeWorkers.get(workerId);
    if (worker) {
      worker.status = 'available';
      worker.currentJobId = undefined;
    }

    logger.info('Job completed', { jobId, workerId });
  }

  /**
   * Calculate distance between two coordinates (Haversine formula)
   */
  private static calculateDistance(
    lat1: number,
    lon1: number,
    lat2: number,
    lon2: number
  ): number {
    const R = 6371e3; // Earth's radius in meters
    const φ1 = (lat1 * Math.PI) / 180;
    const φ2 = (lat2 * Math.PI) / 180;
    const Δφ = ((lat2 - lat1) * Math.PI) / 180;
    const Δλ = ((lon2 - lon1) * Math.PI) / 180;

    const a =
      Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
      Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return R * c;
  }

  /**
   * Load active workers from Redis on startup
   */
  private static async loadActiveWorkers() {
    const redis = RedisService.getInstance();
    const keys = await redis.keys('worker:*:meta');
    
    for (const key of keys) {
      const data = await redis.get(key);
      if (data) {
        const worker = JSON.parse(data) as WorkerLocation;
        this.activeWorkers.set(worker.workerId, worker);
      }
    }

    logger.info('Loaded active workers from Redis', {
      count: this.activeWorkers.size,
    });
  }

  /**
   * Cleanup stale workers (no update for 5 minutes)
   */
  private static cleanupStaleWorkers() {
    const fiveMinutesAgo = new Date(Date.now() - 5 * 60 * 1000);
    
    for (const [workerId, worker] of this.activeWorkers) {
      if (new Date(worker.lastUpdate) < fiveMinutesAgo) {
        this.activeWorkers.delete(workerId);
        logger.info('Removed stale worker', { workerId });
      }
    }
  }

  static getActiveWorkerCount(): number {
    return this.activeWorkers.size;
  }

  static getPendingJobCount(): number {
    return this.pendingJobs.size;
  }
}