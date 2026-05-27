import { Server } from 'socket.io';

let ioRef: Server | null = null;

export const setSocketServer = (io: Server): void => {
  ioRef = io;
};

export const emitToUser = (userId: string, event: string, payload: unknown): void => {
  ioRef?.to(`user:${userId}`).emit(event, payload);
};

export const emitToJob = (jobId: string, event: string, payload: unknown): void => {
  ioRef?.to(`job:${jobId}`).emit(event, payload);
};

export const emitToBooking = (bookingId: string, event: string, payload: unknown): void => {
  ioRef?.to(`booking:${bookingId}`).emit(event, payload);
};
