import { Server, Socket } from 'socket.io';
import { Server as HttpServer } from 'http';
import { verifyAccessToken } from '../utils/jwt';
import { userRepository, chatRepository } from '../repositories/store';
import { setSocketServer } from '../services/socketHub';

interface AuthenticatedSocket extends Socket {
  user?: {
    id: string;
    role: string;
  };
}

export const configureSockets = (server: HttpServer, corsOrigin: string): Server => {
  const io = new Server(server, {
    cors: {
      origin: corsOrigin,
      methods: ['GET', 'POST']
    },
    transports: ['websocket', 'polling']
  });

  io.use((socket: AuthenticatedSocket, next) => {
    const tokenCandidate = socket.handshake.auth.token ?? socket.handshake.headers.authorization;
    const token = typeof tokenCandidate === 'string' && tokenCandidate.startsWith('Bearer ')
      ? tokenCandidate.slice('Bearer '.length)
      : typeof tokenCandidate === 'string'
        ? tokenCandidate
        : '';

    try {
      const payload = verifyAccessToken(token);
      const user = userRepository.findById(payload.sub);
      if (!user) return next(new Error('Invalid socket user'));
      socket.user = { id: user.id, role: user.role };
      return next();
    } catch {
      return next(new Error('Unauthorized socket'));
    }
  });

  io.on('connection', (socket: AuthenticatedSocket) => {
    const user = socket.user;
    if (!user) {
      socket.disconnect(true);
      return;
    }

    socket.join(`user:${user.id}`);
    if (user.role === 'WORKER') socket.join(`worker:${user.id}`);

    socket.on('booking:join', (payload: { bookingId?: string; jobId?: string }) => {
      if (payload.bookingId) socket.join(`booking:${payload.bookingId}`);
      if (payload.jobId) socket.join(`job:${payload.jobId}`);
    });

    socket.on('worker:location:update', (payload: { jobId: string; latitude: number; longitude: number; heading?: number; speed?: number }) => {
      io.to(`job:${payload.jobId}`).emit('worker:location:update', {
        ...payload,
        updatedAt: new Date().toISOString()
      });
    });

    socket.on('chat:message:new', (payload: { conversationId: string; body: string }) => {
      const message = chatRepository.create(payload.conversationId, user.id, payload.body);
      io.to(`booking:${payload.conversationId}`).emit('chat:message:new', message);
      io.to(`user:${user.id}`).emit('chat:message:new', message);
    });

    socket.on('disconnect', () => {
      socket.leave(`user:${user.id}`);
    });
  });

  setSocketServer(io);
  return io;
};
