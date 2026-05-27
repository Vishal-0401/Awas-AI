export type UserRole = 'CUSTOMER' | 'WORKER' | 'ADMIN';
export type AuthProvider = 'LOCAL' | 'GOOGLE' | 'APPLE';
export type OtpPurpose = 'LOGIN' | 'WITHDRAWAL';
export type BookingStatus = 'REQUESTED' | 'SEARCHING' | 'ASSIGNED' | 'ARRIVING' | 'STARTED' | 'COMPLETED' | 'CANCELLED';
export type PaymentStatus = 'PENDING' | 'PAID' | 'FAILED' | 'REFUNDED';
export type JobPriority = 'normal' | 'urgent' | 'emergency';
export type WorkerAvailability = 'offline' | 'online' | 'available' | 'busy' | 'on_job';
export type DiagnosticStatus = 'PROCESSING' | 'COMPLETED' | 'FAILED';
export type TransactionType = 'CREDIT' | 'DEBIT';
export type TransactionCategory = 'ADD_MONEY' | 'BOOKING_ESCROW' | 'ESCROW_RELEASE' | 'REFUND' | 'WITHDRAWAL' | 'ADJUSTMENT';

export interface UserDto {
  id: string;
  fullName: string;
  email?: string;
  phone?: string;
  avatar?: string;
  googleId?: string;
  authProvider: AuthProvider;
  role: UserRole;
  isVerified: boolean;
  isProfileComplete: boolean;
  address?: string;
  createdAt: string;
  updatedAt: string;
}

export interface AddressDto {
  id: string;
  userId: string;
  title: string;
  address: string;
  city: string;
  state: string;
  zipCode: string;
  latitude: number;
  longitude: number;
  isDefault: boolean;
}

export interface CategoryDto {
  id: string;
  name: string;
  description: string;
  icon: string;
  isEmergency: boolean;
}

export interface ServiceDto {
  id: string;
  categoryId: string;
  name: string;
  description: string;
  basePrice: number;
  estimatedDurationMinutes: number;
  icon: string;
}

export interface WorkerDto {
  id: string;
  userId: string;
  fullName: string;
  phone: string;
  avatar?: string;
  categoryIds: string[];
  serviceIds: string[];
  rating: number;
  jobCount: number;
  experienceYears: number;
  verified: boolean;
  availability: WorkerAvailability;
  latitude: number;
  longitude: number;
}

export interface BookingDto {
  id: string;
  customerId: string;
  serviceId: string;
  workerId?: string;
  addressId: string;
  status: BookingStatus;
  priority: JobPriority;
  scheduledFor?: string;
  totalAmount: number;
  basePrice: number;
  platformFee: number;
  taxes: number;
  paymentStatus: PaymentStatus;
  diagnosticId?: string;
  startOtp: string;
  endOtp: string;
  createdAt: string;
  updatedAt: string;
}

export interface JobDto {
  id: string;
  bookingId: string;
  workerId?: string;
  status: BookingStatus;
  etaMinutes?: number;
  startedAt?: string;
  completedAt?: string;
  timeline: JobEventDto[];
}

export interface JobEventDto {
  id: string;
  jobId: string;
  status: BookingStatus;
  label: string;
  occurredAt: string;
}

export interface WalletDto {
  id: string;
  userId: string;
  availableBalance: number;
  escrowBalance: number;
  currency: string;
}

export interface TransactionDto {
  id: string;
  walletId: string;
  bookingId?: string;
  amount: number;
  type: TransactionType;
  category: TransactionCategory;
  status: 'PENDING' | 'SUCCESS' | 'FAILED';
  reference: string;
  balanceBefore: number;
  balanceAfter: number;
  createdAt: string;
}

export interface AiDiagnosticDto {
  id: string;
  userId: string;
  applianceAssetId?: string;
  imageUrl: string;
  status: DiagnosticStatus;
  applianceType: string;
  brand?: string;
  modelNumber?: string;
  confidenceScore?: number;
  healthScore?: number;
  detectedIssues: Array<{ issue: string; confidence: number; severity: string; description: string }>;
  recommendations: Array<{ serviceId: string; service: string; priority: string; estimatedCostMin: number; estimatedCostMax: number; description: string }>;
  recommendation?: string;
  createdAt: string;
  completedAt?: string;
}

export interface NotificationDto {
  id: string;
  userId: string;
  title: string;
  message: string;
  type: string;
  isRead: boolean;
  data: Record<string, unknown>;
  createdAt: string;
}

export interface ChatMessageDto {
  id: string;
  conversationId: string;
  senderId: string;
  body: string;
  createdAt: string;
}
