// User Entities
export interface UserEntity {
  id: string;
  fullName: string | null;
  email: string | null;
  phone: string | null;
  avatar: string | null;
  googleId: string | null;
  authProvider: 'LOCAL' | 'GOOGLE' | 'APPLE';
  role: 'CUSTOMER' | 'WORKER' | 'ADMIN' | 'SUPPORT';
  isVerified: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface AddressEntity {
  id: string;
  userId: string;
  title: string;
  address: string;
  city: string;
  state: string;
  zipCode: string;
  latitude: number | null;
  longitude: number | null;
  isDefault: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface OtpSessionEntity {
  id: string;
  phone: string;
  otp: string;
  status: 'PENDING' | 'VERIFIED' | 'EXPIRED';
  attempts: number;
  expiresAt: Date;
  verifiedAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
}
// Booking Entities
export interface CategoryEntity {
  id: string;
  name: string;
  description: string | null;
  icon: string | null;
  createdAt: Date;
  updatedAt: Date;
}

export interface ServiceEntity {
  id: string;
  categoryId: string;
  name: string;
  description: string | null;
  basePrice: number;
  icon: string | null;
  createdAt: Date;
  updatedAt: Date;
}

export interface BookingEntity {
  id: string;
  customerId: string;
  serviceId: string;
  addressId: string;
  status: 'REQUESTED' | 'ASSIGNED' | 'ARRIVING' | 'STARTED' | 'COMPLETED' | 'CANCELLED';
  scheduledFor: Date;
  totalAmount: number;
  notes: string | null;
  createdAt: Date;
  updatedAt: Date;
}

export interface JobEntity {
  id: string;
  bookingId: string;
  workerId: string | null;
  status: 'REQUESTED' | 'ASSIGNED' | 'ARRIVING' | 'STARTED' | 'COMPLETED' | 'CANCELLED';
  startedAt: Date | null;
  completedAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
}

// Tracking Entities
export interface JobTrackingEntity {
  id: string;
  jobId: string;
  latitude: number;
  longitude: number;
  heading: number | null;
  speed: number | null;
  updatedAt: Date;
}

export interface WorkerLocationEntity {
  workerId: string;
  latitude: number;
  longitude: number;
  heading: number | null;
  isOnline: boolean;
  lastUpdated: Date;
}

// Wallet Entities
export interface WalletEntity {
  id: string;
  userId: string;
  balance: number;
  createdAt: Date;
  updatedAt: Date;
}

export interface TransactionEntity {
  id: string;
  walletId: string;
  bookingId: string | null;
  amount: number;
  type: 'CREDIT' | 'DEBIT';
  status: 'PENDING' | 'SUCCESS' | 'FAILED';
  reference: string | null;
  notes: string | null;
  createdAt: Date;
  updatedAt: Date;
}

// Notification & Support Entities
export interface NotificationEntity {
  id: string;
  userId: string;
  title: string;
  message: string;
  type: string;
  isRead: boolean;
  data: any | null;
  createdAt: Date;
}

export interface ReviewEntity {
  id: string;
  userId: string;
  bookingId: string;
  rating: number;
  comment: string | null;
  createdAt: Date;
}

export interface SupportTicketEntity {
  id: string;
  userId: string;
  subject: string;
  message: string;
  status: 'OPEN' | 'IN_PROGRESS' | 'RESOLVED';
  createdAt: Date;
  updatedAt: Date;
}

export interface AuditLogEntity {
  id: string;
  userId: string | null;
  action: string;
  resource: string;
  details: any | null;
  ipAddress: string | null;
  createdAt: Date;
}

// AI Entities
export interface ApplianceAssetEntity {
  id: string;
  userId: string;
  type: string;
  brand: string | null;
  modelNumber: string | null;
  serialNumber: string | null;
  installDate: Date | null;
  createdAt: Date;
  updatedAt: Date;
}

export interface AiDiagnosticEntity {
  id: string;
  userId: string;
  applianceAssetId: string | null;
  imageUrl: string | null;
  ocrRawText: string | null;
  analysisResult: any | null;
  healthScore: number | null;
  createdAt: Date;
  updatedAt: Date;
}

export interface PredictiveScoreEntity {
  id: string;
  applianceAssetId: string;
  overallScore: number;
  failureRisk: 'LOW' | 'MEDIUM' | 'HIGH';
  estimatedDaysLeft: number | null;
  createdAt: Date;
}

export interface RefreshTokenEntity {
  id: string;
  token: string;
  userId: string;
  expiresAt: Date;
  createdAt: Date;
}
