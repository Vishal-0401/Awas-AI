/**
 * Socket.io Handler
 * 
 * Real-time WebSocket communication for worker dispatch,
 * job tracking, and live notifications.
 */

import { Server, Socket } from 'socket.io';
import { Server as HTTPServer } from 'http';
import { config } from '@awas-ai/config';
import { logger } from '../utils/logger';
import { verifyToken } from '../middleware/auth';

// Socket.io server instance reference
let io: Server;

// Connected users tracking (for horizontal scaling, use Redis)
const connectedUsers = new Map<string, Set<string>>(); // userId -> Set<socketIds>
const connectedWorkers = new Map<string, WorkerSocketData>(); // workerId -> worker data

// Worker socket data interface
interface WorkerSocketData {
  socketId: string;
  workerId: string;
  userId: string;
  status: 'online' | 'offline' | 'available' | 'busy' | 'on_job';
  location?: {
    latitude: number;
    longitude: number;
    accuracy: number;
    timestamp: Date;
  };
  currentJobId?: string;
}

// Socket event types
interface SocketEvents {
  // Worker events
  'worker:online': (data: WorkerOnlineData) => void;
  'worker:offline': (data: WorkerOfflineData) => void;
  'worker:location': (data: WorkerLocationData) => void;
  'worker:status': (data: WorkerStatusData) => void;
  'worker:accept': (data: JobAcceptData) => void;
  'worker:reject': (data: JobRejectData) => void;
  
  // Customer events
  'customer:createJob': (data: CreateJobData) => void;
  'customer:cancelJob': (data: CancelJobData) => void;
  'customer:trackWorker': (data: TrackWorkerData) => void;
  
  // Admin events
  'admin:monitor': (data: AdminMonitorData) => void;
  'admin:freezeWorker': (data: FreezeWorkerData) => void;
  
  // System events (broadcast)
  'job:assigned': (data: JobAssignedData) => void;
  'job:tracking': (data: JobTrackingData) => void;
  'job:completed': (data: JobCompletedData) => void;
  'job:cancelled': (data: JobCancelledData) => void;
  'dispute:created': (data: DisputeCreatedData) => void;
}

// Event data interfaces
interface WorkerOnlineData {
  workerId: string;
  location: {
    latitude: number;
    longitude: number;
  };
}

interface WorkerOfflineData {
  workerId: string;
}

interface WorkerLocationData {
  workerId: string;
  location: {
    latitude: number;
    longitude: number;
    accuracy: number;
  };
  jobId?: string;
}

interface WorkerStatusData {
  workerId: string;
  status: 'online' | 'offline' | 'available' | 'busy' | 'on_job';
  jobId?: string;
}

interface JobAcceptData {
  jobId: string;
  workerId: string;
}

interface JobRejectData {
  jobId: string;
  workerId: string;
  reason?: string;
}

interface CreateJobData {
  customerId: string;
  serviceType: string;
  location: {
    latitude: number;
    longitude: number;
    address: string;
  };
  description?: string;
  priority?: 'normal' | 'urgent' | 'emergency';
}

interface CancelJobData {
  jobId: string;
  customerId: string;
  reason: string;
}

interface TrackWorkerData {
  jobId: string;
  customerId: string;
}

interface AdminMonitorData {
  adminId: string;
  filters?: Record<string, unknown>;
}

interface FreezeWorkerData {
  workerId: string;
  adminId: string;
  reason: string;
}

interface JobAssignedData {
  jobId: string;
  workerId: string;
  customerId: string;
  serviceType: string;
  location: {
    latitude: number;
    longitude: number;
  };
}

interface JobTrackingData {
  jobId: string;
  workerId: string;
  location: {
    latitude: number;
    longitude: number;
  };
  status: string;
}

interface JobCompletedData {
  jobId: string;
  workerId: string;
  customerId: string;
  completionData: {
    beforeImages: string[];
    afterImages: string[];
    notes: string;
    amount: number;
  };
}

interface JobCancelledData {
  jobId: string;
  cancelledBy: string;
  reason: string;
}

interface DisputeCreatedData {
  disputeId: string;
  jobId: string;
  raisedBy: string;
  againstUser: string;
  type: string;
}

// Socket.io handler setup
export const socketHandler = (server: Server) => {
  io = server;

  // Middleware for authentication
  io.use((socket: Socket, next) => {
    const token = socket.handshake.auth.token || socket.handshake.headers.authorization?.replace('Bearer ', '');
    
    if (!token) {
      return next(new Error('Authentication required'));
    }
    
    try {
      const decoded = verifyToken(token);
      socket.data.user = decoded;
      next();
    } catch (error) {
      next(new Error('Invalid or expired token'));
    }
  });

  // Connection handler
  io.on('connection', (socket: Socket) => {
    const user = socket.data.user;
    logger.info('Socket connected', {
      socketId: socket.id,
      userId: user?.id,
      role: user?.role,
    });

    // Join user-specific room
    if (user?.id) {
      socket.join(`user:${user.id}`);
      socket.join(`role:${user.role}`);
      
      // Track connected users
      if (!connectedUsers.has(user.id)) {
        connectedUsers.set(user.id, new Set());
      }
      connectedUsers.get(user.id)!.add(socket.id);
    }

    // ========================================================================
    // WORKER EVENTS
    // ========================================================================

    socket.on('worker:online', (data: WorkerOnlineData) => {
      if (user?.role !== 'worker') {
        socket.emit('error', { message: 'Only workers can go online' });
        return;
      }

      // Store worker data
      connectedWorkers.set(user.id, {
        socketId: socket.id,
        workerId: data.workerId,
        userId: user.id,
        status: 'online',
        location: {
          latitude: data.location.latitude,
          longitude: data.location.longitude,
          timestamp: new Date(),
        },
      });

      // Join worker room
      socket.join(`worker:${data.workerId}`);
      socket.join('workers:online');

      // Broadcast to admin
      io.to('role:admin').emit('worker:online', {
        workerId: data.workerId,
        location: data.location,
        timestamp: new Date(),
      });

      logger.info('Worker went online', { workerId: data.workerId });
    });

    socket.on('worker:offline', (data: WorkerOfflineData) => {
      // Remove from connected workers
      connectedWorkers.delete(user?.id);
      
      // Leave worker room
      socket.leave('workers:online');

      // Broadcast to admin
      io.to('role:admin').emit('worker:offline', {
        workerId: data.workerId,
        timestamp: new Date(),
      });

      logger.info('Worker went offline', { workerId: data.workerId });
    });

    socket.on('worker:location', (data: WorkerLocationData) => {
      const worker = connectedWorkers.get(user?.id);
      
      if (worker) {
        worker.location = {
          latitude: data.location.latitude,
          longitude: data.location.longitude,
          accuracy: data.location.accuracy,
          timestamp: new Date(),
        };
        
        // If worker has a job, broadcast location to customer
        if (worker.currentJobId) {
          io.to(`job:${worker.currentJobId}`).emit('job:tracking', {
            jobId: worker.currentJobId,
            workerId: worker.workerId,
            location: data.location,
            timestamp: new Date(),
          });
        }

        // Update Redis geo index (for dispatch)
        // await redis.geoadd('workers:locations', data.location.longitude, data.location.latitude, worker.workerId);
      }
    });

    socket.on('worker:accept', (data: JobAcceptData) => {
      // TODO: Implement distributed lock for job acceptance
      // First worker to accept gets the job
      
      const worker = connectedWorkers.get(user?.id);
      if (worker) {
        worker.currentJobId = data.jobId;
        worker.status = 'on_job';
      }

      // Notify customer
      io.to(`user:${user.id}`).emit('job:accepted', {
        jobId: data.jobId,
        workerId: data.workerId,
        timestamp: new Date(),
      });

      // Join job room
      socket.join(`job:${data.jobId}`);

      logger.info('Worker accepted job', { jobId: data.jobId, workerId: data.workerId });
    });

    socket.on('worker:reject', (data: JobRejectData) => {
      logger.info('Worker rejected job', { 
        jobId: data.jobId, 
        workerId: data.workerId, 
        reason: data.reason 
      });
      
      // TODO: Re-assign job to next available worker
    });

    // ========================================================================
    // CUSTOMER EVENTS
    // ========================================================================

    socket.on('customer:createJob', (data: CreateJobData) => {
      // TODO: Create job in database
      // Find nearby workers
      // Broadcast job offer to nearby workers
      
      const jobId = `job_${Date.now()}`;
      
      // Join customer to job room
      socket.join(`job:${jobId}`);

      // Broadcast to nearby workers
      io.to('workers:online').emit('job:offer', {
        jobId,
        customerId: data.customerId,
        serviceType: data.serviceType,
        location: data.location,
        estimatedEarnings: 500, // TODO: Calculate
        priority: data.priority || 'normal',
        expiresAt: new Date(Date.now() + 30000), // 30 seconds
      });

      logger.info('Job created', { jobId, customerId: data.customerId });
    });

    socket.on('customer:cancelJob', (data: CancelJobData) => {
      // Notify worker if assigned
      io.to(`job:${data.jobId}`).emit('job:cancelled', {
        jobId: data.jobId,
        reason: data.reason,
        cancelledBy: data.customerId,
        timestamp: new Date(),
      });

      logger.info('Job cancelled by customer', { jobId: data.jobId });
    });

    socket.on('customer:trackWorker', (data: TrackWorkerData) => {
      socket.join(`job:${data.jobId}`);
      
      // Get worker location if available
      // Send current location to customer
    });

    // ========================================================================
    // ADMIN EVENTS
    // ========================================================================

    socket.on('admin:monitor', (data: AdminMonitorData) => {
      // Join admin monitoring room
      socket.join(`admin:monitor:${data.adminId}`);
      
      // Send current system status
      socket.emit('system:status', {
        activeWorkers: connectedWorkers.size,
        activeJobs: 0, // TODO: Get from database
        timestamp: new Date(),
      });
    });

    socket.on('admin:freezeWorker', (data: FreezeWorkerData) => {
      // Freeze worker account
      const workerSocket = Array.from(connectedWorkers.values())
        .find(w => w.workerId === data.workerId);
      
      if (workerSocket) {
        workerSocket.socketId && io.to(workerSocket.socketId).emit('worker:frozen', {
          workerId: data.workerId,
          reason: data.reason,
          frozenBy: data.adminId,
          timestamp: new Date(),
        });
      }

      logger.warn('Worker frozen by admin', {
        workerId: data.workerId,
        reason: data.reason,
        adminId: data.adminId,
      });
    });

    // ========================================================================
    // DISCONNECTION
    // ========================================================================

    socket.on('disconnect', () => {
      // Remove from connected users
      if (user?.id) {
        const userSockets = connectedUsers.get(user.id);
        if (userSockets) {
          userSockets.delete(socket.id);
          if (userSockets.size === 0) {
            connectedUsers.delete(user.id);
          }
        }
      }

      // Remove worker if connected
      if (connectedWorkers.has(user?.id)) {
        const worker = connectedWorkers.get(user.id);
        connectedWorkers.delete(user.id);
        
        io.to('role:admin').emit('worker:offline', {
          workerId: worker?.workerId,
          timestamp: new Date(),
        });
      }

      logger.info('Socket disconnected', {
        socketId: socket.id,
        userId: user?.id,
      });
    });

    // Error handling
    socket.on('error', (error: Error) => {
      logger.error('Socket error', error, {
        socketId: socket.id,
        userId: user?.id,
      });
    });
  });

  return io;
};

// Export io instance for use in other modules
export const getIO = (): Server => {
  if (!io) {
    throw new Error('Socket.io not initialized. Call socketHandler first.');
  }
  return io;
};

// Export connected workers for dispatch service
export { connectedWorkers };