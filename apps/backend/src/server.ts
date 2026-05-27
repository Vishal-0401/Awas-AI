import http from 'http';
import fs from 'fs';
import path from 'path';
import { createApp } from './app';
import { env } from './config/env';
import { configureSockets } from './sockets';

const uploadsDir = path.resolve(process.cwd(), 'uploads');
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}

const app = createApp();
const server = http.createServer(app);
configureSockets(server, env.socketCorsOrigin);

server.listen(env.port, () => {
  console.log(`[awas-home] API listening on http://localhost:${env.port}`);
});

server.on('error', (error: NodeJS.ErrnoException) => {
  if (error.code === 'EADDRINUSE') {
    console.error(`[awas-home] Port ${env.port} is already in use. Stop the existing server or set PORT to another value.`);
    process.exit(1);
  }

  console.error('[awas-home] Server failed to start', error);
  process.exit(1);
});

const shutdown = (): void => {
  server.close(() => {
    process.exit(0);
  });
};

process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);
