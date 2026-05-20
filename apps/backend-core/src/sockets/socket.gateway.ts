import { Server, Socket } from 'socket.io';
import { logger } from '../common/helpers/logger';

interface LocationUpdate {
  workerId: string;
  latitude: number;
  longitude: number;
}

export class SocketGateway {
  private io: Server;

  constructor(io: Server) {
    this.io = io;
    this.initialize();
  }

  private initialize() {
    this.io.on('connection', (socket: Socket) => {
      logger.info(`Socket connected: ${socket.id}`);

      socket.on('worker-location-update', (data: LocationUpdate) => {
        this.io.emit('worker-location', data);
      });

      socket.on('job-status-update', (data) => {
        this.io.emit('job-status', data);
      });

      socket.on('disconnect', () => {
        logger.info(`Socket disconnected: ${socket.id}`);
      });
    });
  }

  emit(event: string, data: any) {
    this.io.emit(event, data);
  }

  toRoom(room: string) {
    return this.io.to(room);
  }
}