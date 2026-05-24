import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.join(__dirname, '../../.env') });

export const config = {
  port: process.env.PORT || 3000,
  nodeEnv: process.env.NODE_ENV || 'development',
  databaseUrl: process.env.DATABASE_URL || 'mysql://root:password@localhost:3306/awasai',
  
  jwtAccessSecret: process.env.JWT_ACCESS_SECRET || 'your_jwt_access_secret_key_here',
  jwtRefreshSecret: process.env.JWT_REFRESH_SECRET || 'your_jwt_refresh_secret_key_here',
  jwtAccessExpiresIn: '15m',
  jwtRefreshExpiresIn: '7d',

  redisHost: process.env.REDIS_HOST || 'localhost',
  redisPort: parseInt(process.env.REDIS_PORT || '6379', 10),
  
  googleClientId: process.env.GOOGLE_CLIENT_ID || 'your_google_client_id_here',
  googleClientSecret: process.env.GOOGLE_CLIENT_SECRET || 'your_google_client_secret_here',
  
  cloudinary: {
    cloudName: process.env.CLOUDINARY_CLOUD_NAME,
    apiKey: process.env.CLOUDINARY_API_KEY,
    apiSecret: process.env.CLOUDINARY_API_SECRET,
  },
  
  socketCorsOrigin: process.env.SOCKET_CORS_ORIGIN || '*',
};
