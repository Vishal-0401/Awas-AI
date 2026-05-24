import { Server as SocketServer, Socket } from 'socket.io';
import { Server } from 'http';
import jwt from 'jsonwebtoken';
import { config } from '../config';
import { logger } from '../common/helpers/logger';

export class SocketGateway {
  private io: SocketServer;

  constructor(server: Server) {
    this.io = new SocketServer(server, {
      cors: {
        origin: config.socketCorsOrigin,
        methods: ['GET', 'POST'],
      },
    });

    this.initialize();
  }

  private initialize() {
    this.io.use((socket, next) => {
      const token = socket.handshake.auth.token;
      if (!token) {
        return next(new Error('Authentication error: Token missing'));
      }
      try {
        const decoded = jwt.verify(token, config.jwtAccessSecret) as any;
        socket.data.user = decoded;
        next();
      } catch (err) {
        next(new Error('Authentication error: Invalid token'));
      }
    });

    this.io.on('connection', (socket: Socket) => {
      logger.info(`Client connected: ${socket.id}, User: ${socket.data.user.userId}`);
      
      const { userId, role } = socket.data.user;

      // Join a room specific to the user for direct messages
      socket.join(userId);

      if (role === 'WORKER') {
        socket.join('workers');
        
        // Worker events
        socket.on('worker:online', (data) => {
          logger.info(`Worker ${userId} went online at ${data.latitude}, ${data.longitude}`);
          // Update worker location in Redis or DB
        });

        socket.on('worker:location_update', (data) => {
          // data: { jobId: string, latitude: number, longitude: number, heading: number }
          // Broadcast location to the specific job/booking room
          if (data.jobId) {
            this.io.to(`job:${data.jobId}`).emit('tracking:location_update', data);
          }
        });
        
        socket.on('worker:accept_booking', (data) => {
          // data: { bookingId: string }
          logger.info(`Worker ${userId} accepted booking ${data.bookingId}`);
          this.io.to(`booking:${data.bookingId}`).emit('booking:worker_assigned', { workerId: userId, bookingId: data.bookingId });
        });
      }

      if (role === 'CUSTOMER') {
        socket.join('customers');

        // Customer can join a specific booking tracking room
        socket.on('customer:track_booking', (data) => {
          // data: { bookingId: string, jobId: string }
          socket.join(`booking:${data.bookingId}`);
          if (data.jobId) socket.join(`job:${data.jobId}`);
          logger.info(`Customer ${userId} started tracking booking ${data.bookingId}`);
        });
      }

      socket.on('disconnect', () => {
        logger.info(`Client disconnected: ${socket.id}`);
      });
    });
  }

  // Public methods to trigger events from controllers/services
  public emitToUser(userId: string, event: string, data: any) {
    this.io.to(userId).emit(event, data);
  }

  public emitToJob(jobId: string, event: string, data: any) {
    this.io.to(`job:${jobId}`).emit(event, data);
  }
}
