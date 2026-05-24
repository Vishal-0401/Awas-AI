import http from 'http';
import app from './app';
import { PrismaClient } from '@prisma/client';
import { SocketGateway } from './sockets/socket.gateway';
import { initializeQueues } from './queues/queue.service';
import { initializeEvents } from './events/event.service';
import { logger } from './common/helpers/logger';

const PORT = process.env.PORT || 3000;
const server = http.createServer(app);

// Initialize Prisma
export const prisma = new PrismaClient();

// Initialize Socket Gateway
export const socketGateway = new SocketGateway(server);

async function startServer() {
  try {
    await prisma.$connect();
    logger.info('Database connected successfully');

    // Mocks / Placeholders for queue and event initialization
    // initializeQueues();
    // initializeEvents();

    server.listen(PORT, () => {
      logger.info(`🚀 Backend Core Service running on port ${PORT}`);
    });
  } catch (error) {
    logger.error('Failed to start server:', error);
    await prisma.$disconnect();
    process.exit(1);
  }
}

startServer();

// Handle graceful shutdown
process.on('SIGTERM', async () => {
  logger.info('SIGTERM signal received: closing HTTP server');
  server.close(() => {
    logger.info('HTTP server closed');
  });
  await prisma.$disconnect();
});
