/**
 * AWAS-AI Shared Type Definitions
 * 
 * This package contains all shared TypeScript types used across
 * the AWAS-AI platform - frontend, backend, and mobile apps.
 */

// ============================================================================
// USER & AUTH TYPES
// ============================================================================

export type UserRole = 'customer' | 'worker' | 'admin' | 'super_admin';

export type AuthStatus = 'pending' | 'verified' | 'suspended' | 'banned';

export interface User {
  id: string;
  email: string;
  phone: string;
  role: UserRole;
  firstName: string;
  lastName: string;
  profileImage?: string;
  status: AuthStatus;
  isEmailVerified: boolean;
  isPhoneVerified: boolean;
  createdAt: Date;
  updatedAt: Date;
  lastLoginAt?: Date;
  metadata?: Record<string, unknown>;
}

export interface Customer extends User {
  role: 'customer';
  addresses: Address[];
  preferredLanguage: string;
  loyaltyPoints: number;
  totalSpent: number;
  referralCode: string;
  referredBy?: string;
}

export interface Worker extends User {
  role: 'worker';
  workerProfile: WorkerProfile;
  currentStatus: WorkerStatus;
  rating: number;
  totalJobs: number;
  totalEarnings: number;
}

export interface WorkerProfile {
  id: string;
  workerId: string;
  categories: ServiceCategory[];
  experience: number;
  bio?: string;
  documents: WorkerDocument[];
  kycStatus: KYCStatus;
  bankAccount?: BankAccount;
  serviceAreas: ServiceArea[];
  availability: AvailabilitySchedule;
}

export type WorkerStatus = 'offline' | 'online' | 'available' | 'busy' | 'on_job' | 'suspended';

export type KYCStatus = 'pending' | 'submitted' | 'verified' | 'rejected' | 'expired';

// ============================================================================
// SERVICE & CATEGORY TYPES
// ============================================================================

export type ServiceCategory = 
  | 'ac_repair' 
  | 'ac_installation'
  | 'geyser_repair' 
  | 'geyser_installation'
  | 'fan_repair' 
  | 'fan_installation'
  | 'washing_machine_repair' 
  | 'washing_machine_installation'
  | 'refrigerator_repair' 
  | 'refrigerator_installation'
  | 'electrical'
  | 'plumbing'
  | 'general_maintenance';

export interface Service {
  id: string;
  name: string;
  category: ServiceCategory;
  description: string;
  basePrice: number;
  estimatedDuration: number; // in minutes
  requiresInspection: boolean;
  isActive: boolean;
  metadata?: Record<string, unknown>;
}

export interface ServiceArea {
  id: string;
  city: string;
  locality: string;
  pincode: string;
  coordinates: GeoCoordinates;
  radius: number; // in kilometers
}

export interface AvailabilitySchedule {
  monday: TimeSlot[];
  tuesday: TimeSlot[];
  wednesday: TimeSlot[];
  thursday: TimeSlot[];
  friday: TimeSlot[];
  saturday: TimeSlot[];
  sunday: TimeSlot[];
}

export interface TimeSlot {
  startTime: string; // HH:mm format
  endTime: string; // HH:mm format
}

// ============================================================================
// GEOGRAPHIC TYPES
// ============================================================================

export interface GeoCoordinates {
  latitude: number;
  longitude: number;
}

export interface Address {
  id: string;
  userId: string;
  type: 'home' | 'work' | 'other';
  label?: string;
  addressLine1: string;
  addressLine2?: string;
  city: string;
  state: string;
  pincode: string;
  landmark?: string;
  coordinates: GeoCoordinates;
  isDefault: boolean;
  floorNumber?: number;
  apartmentName?: string;
  gateCode?: string;
}

// ============================================================================
// JOB & BOOKING TYPES
// ============================================================================

export type JobStatus = 
  | 'requested' 
  | 'searching'
  | 'assigned' 
  | 'accepted'
  | 'rejected'
  | 'otp_verified'
  | 'arriving' 
  | 'started' 
  | 'in_progress' 
  | 'completed'
  | 'cancelled' 
  | 'failed'
  | 'disputed';

export type JobPriority = 'normal' | 'urgent' | 'emergency';

export interface Job {
  id: string;
  jobId: string; // Human readable job ID
  customerId: string;
  workerId?: string;
  serviceId: string;
  status: JobStatus;
  priority: JobPriority;
  
  // Location
  serviceAddress: Address;
  serviceCoordinates: GeoCoordinates;
  
  // Pricing
  basePrice: number;
  additionalCharges: number;
  totalAmount: number;
  platformFee: number;
  taxes: number;
  discount: number;
  finalAmount: number;
  
  // Timing
  scheduledAt?: Date;
  startedAt?: Date;
  completedAt?: Date;
  estimatedDuration: number;
  
  // AI Diagnostics
  aiDiagnosticId?: string;
  aiConfidenceScore?: number;
  
  // OTP
  otp?: string;
  otpVerifiedAt?: Date;
  
  // Description
  problemDescription?: string;
  customerNotes?: string;
  workerNotes?: string;
  
  // Media
  images: JobImage[];
  beforeImages: string[];
  afterImages: string[];
  
  // Tracking
  tracking: JobTracking[];
  
  createdAt: Date;
  updatedAt: Date;
}

export interface JobImage {
  id: string;
  url: string;
  type: 'problem' | 'before' | 'after' | 'document';
  caption?: string;
  uploadedAt: Date;
}

export interface JobTracking {
  id: string;
  jobId: string;
  status: JobStatus;
  previousStatus: JobStatus;
  changedBy: string;
  changedByRole: UserRole;
  reason?: string;
  metadata?: Record<string, unknown>;
  timestamp: Date;
}

// ============================================================================
// AI DIAGNOSTIC TYPES
// ============================================================================

export type ApplianceType = 
  | 'ac' 
  | 'geyser' 
  | 'fan' 
  | 'washing_machine' 
  | 'refrigerator'
  | 'microwave'
  | 'tv'
  | 'other';

export type DiagnosticStatus = 'processing' | 'completed' | 'failed';

export interface AIDiagnostic {
  id: string;
  customerId: string;
  applianceType: ApplianceType;
  brand?: string;
  model?: string;
  
  // Images
  images: string[];
  processedImages: string[];
  
  // Results
  status: DiagnosticStatus;
  detectedIssues: DetectedIssue[];
  confidenceScore: number;
  recommendedService: ServiceCategory;
  estimatedCost: {
    min: number;
    max: number;
  };
  urgency: 'low' | 'medium' | 'high' | 'critical';
  
  // Predictions
  predictedFailureProbability?: number;
  remainingUsefulLife?: number; // in days
  
  // Processing
  processingTimeMs: number;
  modelVersion: string;
  
  createdAt: Date;
  completedAt?: Date;
}

export interface DetectedIssue {
  id: string;
  issueType: string;
  description: string;
  confidence: number;
  boundingBox?: BoundingBox;
  severity: 'low' | 'medium' | 'high';
}

export interface BoundingBox {
  x: number;
  y: number;
  width: number;
  height: number;
}

// ============================================================================
// PAYMENT & WALLET TYPES
// ============================================================================

export type PaymentStatus = 'pending' | 'processing' | 'completed' | 'failed' | 'refunded' | 'disputed';
export type PaymentMethod = 'upi' | 'card' | 'netbanking' | 'wallet' | 'cod';
export type PaymentGateway = 'razorpay' | 'stripe' | 'paytm';

export interface Payment {
  id: string;
  orderId: string;
  jobId: string;
  customerId: string;
  workerId: string;
  
  amount: number;
  platformFee: number;
  workerShare: number;
  taxes: number;
  
  status: PaymentStatus;
  method: PaymentMethod;
  gateway: PaymentGateway;
  gatewayOrderId?: string;
  gatewayPaymentId?: string;
  
  // Escrow
  escrowStatus: 'held' | 'released' | 'refunded';
  escrowReleasedAt?: Date;
  
  // Settlement
  settlementId?: string;
  settlementStatus: 'pending' | 'processed' | 'failed';
  
  // Metadata
  receipt?: string;
  metadata?: Record<string, unknown>;
  
  createdAt: Date;
  updatedAt: Date;
  completedAt?: Date;
}

export interface Wallet {
  id: string;
  userId: string;
  userRole: UserRole;
  
  balance: number;
  pendingBalance: number;
  totalAdded: number;
  totalSpent: number;
  totalEarned: number;
  totalWithdrawn: number;
  
  currency: string;
  isActive: boolean;
  
  createdAt: Date;
  updatedAt: Date;
}

export interface WalletTransaction {
  id: string;
  walletId: string;
  userId: string;
  type: 'credit' | 'debit';
  category: 'payment' | 'refund' | 'add_money' | 'withdrawal' | 'adjustment' | 'incentive';
  
  amount: number;
  balanceBefore: number;
  balanceAfter: number;
  
  referenceId?: string; // Job ID, Payment ID, etc.
  description: string;
  
  metadata?: Record<string, unknown>;
  
  createdAt: Date;
}

export interface EscrowAccount {
  id: string;
  paymentId: string;
  jobId: string;
  customerId: string;
  workerId: string;
  
  amount: number;
  status: 'held' | 'released' | 'refunded' | 'frozen';
  
  releaseConditions: EscrowCondition[];
  freezeReason?: string;
  
  heldAt: Date;
  releasedAt?: Date;
  refundedAt?: Date;
}

export interface EscrowCondition {
  type: 'job_completion' | 'otp_verification' | 'customer_approval' | 'time_elapsed';
  isMet: boolean;
  metAt?: Date;
}

// ============================================================================
// NOTIFICATION TYPES
// ============================================================================

export type NotificationType = 
  | 'job_assigned' 
  | 'job_status_changed' 
  | 'payment_received' 
  | 'payment_failed'
  | 'worker_arrived'
  | 'job_completed'
  | 'review_requested'
  | 'promotional'
  | 'system'
  | 'dispute_created'
  | 'kyc_status_changed';

export type NotificationChannel = 'push' | 'sms' | 'email' | 'in_app';

export interface Notification {
  id: string;
  userId: string;
  userRole: UserRole;
  
  type: NotificationType;
  title: string;
  message: string;
  
  // Channels
  channels: NotificationChannel[];
  sentChannels: NotificationChannel[];
  
  // Data
  actionType?: string;
  actionData?: Record<string, unknown>;
  
  // Status
  isRead: boolean;
  readAt?: Date;
  
  // Delivery
  pushNotificationId?: string;
  smsMessageId?: string;
  emailMessageId?: string;
  
  createdAt: Date;
  sentAt?: Date;
}

// ============================================================================
// SUPPORT & DISPUTE TYPES
// ============================================================================

export type TicketStatus = 'open' | 'in_progress' | 'resolved' | 'closed' | 'escalated';
export type TicketPriority = 'low' | 'medium' | 'high' | 'critical';
export type TicketCategory = 'job_issue' | 'payment_issue' | 'worker_issue' | 'refund' | 'other';

export interface SupportTicket {
  id: string;
  ticketId: string; // Human readable
  customerId: string;
  jobId?: string;
  workerId?: string;
  
  category: TicketCategory;
  priority: TicketPriority;
  status: TicketStatus;
  
  subject: string;
  description: string;
  
  // Assignment
  assignedTo?: string; // Admin ID
  assignedAt?: Date;
  
  // Messages
  messages: TicketMessage[];
  
  // Resolution
  resolution?: string;
  resolvedBy?: string;
  resolvedAt?: Date;
  
  createdAt: Date;
  updatedAt: Date;
}

export interface TicketMessage {
  id: string;
  ticketId: string;
  senderId: string;
  senderRole: UserRole;
  message: string;
  attachments?: string[];
  createdAt: Date;
}

export type DisputeStatus = 'raised' | 'under_review' | 'customer_won' | 'worker_won' | 'settled' | 'rejected';
export type DisputeType = 'incomplete_work' | 'overcharging' | 'damage_caused' | 'no_show' | 'misconduct' | 'other';

export interface Dispute {
  id: string;
  disputeId: string; // Human readable
  jobId: string;
  raisedBy: string;
  raisedByRole: UserRole;
  againstUserId: string;
  againstUserRole: UserRole;
  
  type: DisputeType;
  status: DisputeStatus;
  description: string;
  
  // Evidence
  evidence: DisputeEvidence[];
  
  // Resolution
  assignedAdminId?: string;
  resolution?: DisputeResolution;
  
  // Escrow
  escrowFrozen: boolean;
  escrowReleaseDecision?: 'customer' | 'worker' | 'split';
  
  createdAt: Date;
  updatedAt: Date;
  resolvedAt?: Date;
}

export interface DisputeEvidence {
  id: string;
  disputeId: string;
  type: 'image' | 'video' | 'document' | 'audio';
  url: string;
  description?: string;
  submittedBy: string;
  submittedAt: Date;
}

export interface DisputeResolution {
  decidedBy: string;
  decision: 'customer_won' | 'worker_won' | 'partial_refund' | 'full_refund';
  reasoning: string;
  refundAmount?: number;
  penaltyAmount?: number;
  notes?: string;
  decidedAt: Date;
}

// ============================================================================
// REVIEW & RATING TYPES
// ============================================================================

export interface Review {
  id: string;
  jobId: string;
  customerId: string;
  workerId: string;
  
  rating: number; // 1-5
  categories: ReviewCategories;
  comment?: string;
  images?: string[];
  
  // Worker review of customer (optional)
  customerRating?: number;
  customerComment?: string;
  
  isVerified: boolean; // Only verified jobs can be reviewed
  
  createdAt: Date;
  updatedAt: Date;
}

export interface ReviewCategories {
  quality: number;
  punctuality: number;
  behavior: number;
  valueForMoney: number;
}

// ============================================================================
// PREDICTIVE MAINTENANCE TYPES
// ============================================================================

export interface PredictiveMaintenanceScore {
  id: string;
  customerId: string;
  applianceType: ApplianceType;
  applianceId?: string;
  
  // Scores
  healthScore: number; // 0-100
  failureProbability: number; // 0-1
  remainingUsefulLife: number; // days
  
  // Factors
  age: number; // months since installation
  usageHours: number;
  lastServiceDate?: Date;
  serviceHistory: string[];
  
  // Predictions
  predictedIssues: PredictedIssue[];
  maintenanceRecommendations: MaintenanceRecommendation[];
  
  // Alerts
  alerts: MaintenanceAlert[];
  
  createdAt: Date;
  updatedAt: Date;
}

export interface PredictedIssue {
  issueType: string;
  probability: number;
  estimatedTimeframe: number; // days
  severity: 'low' | 'medium' | 'high' | 'critical';
}

export interface MaintenanceRecommendation {
  type: 'service' | 'repair' | 'replacement' | 'inspection';
  urgency: 'now' | 'soon' | 'scheduled';
  description: string;
  estimatedCost?: number;
}

export interface MaintenanceAlert {
  id: string;
  scoreId: string;
  type: 'maintenance_due' | 'failure_warning' | 'service_reminder';
  message: string;
  isRead: boolean;
  actionRequired: boolean;
  createdAt: Date;
}

// ============================================================================
// WORKER LOCATION & TRACKING TYPES
// ============================================================================

export interface WorkerLocation {
  workerId: string;
  coordinates: GeoCoordinates;
  accuracy: number; // meters
  speed?: number; // km/h
  heading?: number; // degrees
  timestamp: Date;
  batteryLevel?: number;
  isOnline: boolean;
  currentStatus: WorkerStatus;
}

export interface LiveTracking {
  jobId: string;
  workerId: string;
  customerId: string;
  
  // Current position
  workerLocation: WorkerLocation;
  
  // Route
  distance: number; // km
  eta: number; // minutes
  routePolyline?: string;
  
  // Updates
  locationHistory: WorkerLocation[];
  
  startedAt: Date;
  lastUpdated: Date;
}

// ============================================================================
// SOCKET EVENT TYPES
// ============================================================================

export interface SocketEvent<T = unknown> {
  event: string;
  data: T;
  timestamp: Date;
  correlationId?: string;
}

// Worker Socket Events
export interface WorkerOnlineEvent {
  workerId: string;
  location: GeoCoordinates;
  status: WorkerStatus;
}

export interface WorkerLocationUpdateEvent {
  workerId: string;
  location: GeoCoordinates;
  accuracy: number;
  status: WorkerStatus;
  jobId?: string;
}

export interface JobOfferEvent {
  jobId: string;
  customerId: string;
  serviceType: ServiceCategory;
  location: GeoCoordinates;
  estimatedEarnings: number;
  distance: number;
  expiresAt: Date;
}

// Customer Socket Events
export interface JobStatusUpdateEvent {
  jobId: string;
  status: JobStatus;
  workerId?: string;
  workerName?: string;
  workerLocation?: GeoCoordinates;
  eta?: number;
  message?: string;
}

export interface WorkerArrivingEvent {
  jobId: string;
  workerId: string;
  workerName: string;
  eta: number;
  distance: number;
  location: GeoCoordinates;
}

// Admin Socket Events
export interface SystemAlertEvent {
  alertId: string;
  type: 'high_load' | 'worker_shortage' | 'dispute_escalated' | 'payment_failure' | 'system_error';
  severity: 'low' | 'medium' | 'high' | 'critical';
  message: string;
  metadata?: Record<string, unknown>;
  createdAt: Date;
}

// ============================================================================
// ANALYTICS & TELEMETRY TYPES
// ============================================================================

export interface SystemMetrics {
  timestamp: Date;
  
  // Users
  activeUsers: number;
  activeWorkers: number;
  activeCustomers: number;
  
  // Jobs
  activeJobs: number;
  completedJobsToday: number;
  cancelledJobsToday: number;
  avgCompletionTime: number; // minutes
  
  // Financial
  revenueToday: number;
  pendingSettlements: number;
  escrowHeld: number;
  
  // Performance
  avgResponseTime: number; // ms
  errorRate: number; // percentage
  apiCallsPerMinute: number;
  
  // Quality
  avgRating: number;
  disputeRate: number; // percentage
}

export interface WorkerMetrics {
  workerId: string;
  date: Date;
  
  // Activity
  onlineHours: number;
  jobsCompleted: number;
  jobsAccepted: number;
  jobsRejected: number;
  acceptanceRate: number;
  
  // Earnings
  totalEarnings: number;
  tips: number;
  incentives: number;
  
  // Quality
  avgRating: number;
  totalReviews: number;
  cancellations: number;
  
  // Efficiency
  avgCompletionTime: number;
  onTimeArrivalRate: number;
}

// ============================================================================
// ONDC TYPES (Open Network for Digital Commerce)
// ============================================================================

export interface ONDCProvider {
  id: string;
  name: string;
  type: 'service_provider';
  categoryCodes: string[]; // ONDC category codes
  fulfillmentTypes: string[];
  location: GeoCoordinates;
  serviceableArea: ServiceArea[];
  rating: number;
  timeSlot: TimeSlot;
  credentials?: ONDCCredentials;
}

export interface ONDCCredentials {
  id: string;
  privateKey: string;
  publicKey: string;
  subscriberId: string;
  uniqueKeyId: string;
  signedAt: Date;
  validUntil: Date;
}

export interface ONDCOrder {
  ondcOrderId: string;
  internalJobId: string;
  context: ONDCContext;
  items: ONDCItem[];
  provider: ONDCProvider;
  fulfillment: ONDCFulfillment;
  quote: ONDCQuote;
  payment: ONDCPayment;
  status: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface ONDCContext {
  domain: string;
  action: string;
  country: string;
  city: string;
  coreVersion: string;
  bapId: string;
  bppId: string;
  transactionId: string;
  messageId: string;
  timestamp: Date;
  ttl: string;
}

export interface ONDCItem {
  id: string;
  categoryIds: string[];
  descriptor: ONDCDescriptor;
  price: ONDCPrice;
  timeSlot?: TimeSlot;
  fulfillmentIds: string[];
}

export interface ONDCDescriptor {
  name: string;
  code: string;
  symbol: string;
  shortDesc: string;
  longDesc: string;
  images: string[];
}

export interface ONDCPrice {
  currency: string;
  value: string;
  estimatedValue?: string;
  maximumValue?: string;
  offeredBy?: ONDCProvider;
}

export interface ONDCFulfillment {
  id: string;
  type: 'delivery' | 'self_pickup';
  customer: ONDCCustomer;
  providerId: string;
  tracking: boolean;
  stops: ONDCStop[];
}

export interface ONDCCustomer {
  person: ONDCPerson;
  contact: ONDCContact;
}

export interface ONDCPerson {
  name: string;
}

export interface ONDCContact {
  phone: string;
  email?: string;
}

export interface ONDCStop {
  type: 'start' | 'end';
  location: ONDCLocation;
  time: ONDCTime;
  instructions?: string;
}

export interface ONDCLocation {
  gps: string;
  address: ONDCAddress;
}

export interface ONDCAddress {
  name: string;
  building: string;
  street: string;
  locality: string;
  ward: string;
  city: string;
  state: string;
  country: string;
  areaCode: string;
}

export interface ONDCTime {
  label: string;
  timestamp: Date;
  range?: ONDCRange;
}

export interface ONDCRange {
  start: Date;
  end: Date;
}

export interface ONDCQuote {
  price: ONDCPrice;
  breakup: ONDCBreakup[];
  ttl?: string;
}

export interface ONDCBreakup {
  '@type': string;
  title: string;
  price: ONDCPrice;
}

export interface ONDCPayment {
  '@type': string;
  collectedBy: 'bpp' | 'bap';
  tag: string;
  params: ONDCPaymentParams;
  status: 'paid' | 'unpaid' | 'partially_paid';
  time?: ONDCTime;
}

export interface ONDCPaymentParams {
  amount: string;
  currency: string;
  transactionId?: string;
}

// ============================================================================
// KYC DOCUMENT TYPES
// ============================================================================

export interface WorkerDocument {
  id: string;
  workerId: string;
  type: 'aadhaar' | 'pan' | 'driving_license' | 'voter_id' | 'passport' | 'police_verification' | 'certificate';
  number?: string;
  frontImage: string;
  backImage?: string;
  selfeImage?: string;
  status: KYCStatus;
  verifiedBy?: string;
  verifiedAt?: Date;
  rejectionReason?: string;
  expiryDate?: Date;
  createdAt: Date;
  updatedAt: Date;
}

export interface BankAccount {
  id: string;
  workerId: string;
  accountHolderName: string;
  accountNumber: string;
  ifscCode: string;
  bankName: string;
  branchName?: string;
  accountType: 'savings' | 'current';
  isVerified: boolean;
  verificationMethod?: 'penny_drop' | 'manual';
  createdAt: Date;
  updatedAt: Date;
}

// ============================================================================
// API RESPONSE TYPES
// ============================================================================

export interface ApiResponse<T = unknown> {
  success: boolean;
  data?: T;
  error?: ApiError;
  metadata?: ResponseMetadata;
  timestamp: Date;
}

export interface ApiError {
  code: string;
  message: string;
  details?: Record<string, unknown>;
  stack?: string;
}

export interface ResponseMetadata {
  requestId: string;
  version: string;
  region?: string;
}

// ============================================================================
// PAGINATION TYPES
// ============================================================================

export interface PaginatedResponse<T> {
  items: T[];
  pagination: PaginationInfo;
}

export interface PaginationInfo {
  page: number;
  limit: number;
  totalItems: number;
  totalPages: number;
  hasNextPage: boolean;
  hasPrevPage: boolean;
}

export interface PaginationParams {
  page?: number;
  limit?: number;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
  search?: string;
  filters?: Record<string, unknown>;
}

// ============================================================================
// GEO SPATIAL TYPES
// ============================================================================

export interface GeoQuery {
  center: GeoCoordinates;
  radius: number; // in meters
  unit?: 'm' | 'km' | 'mi';
}

export interface GeoResult<T> {
  item: T;
  distance: number; // in meters
}

// ============================================================================
// RATE LIMITING TYPES
// ============================================================================

export interface RateLimitConfig {
  windowMs: number;
  max: number;
  message?: string;
  skipSuccessfulRequests?: boolean;
  skipFailedRequests?: boolean;
}

export interface RateLimitInfo {
  remaining: number;
  reset: Date;
  total: number;
}

// ============================================================================
// HEALTH CHECK TYPES
// ============================================================================

export interface HealthCheckResult {
  status: 'healthy' | 'unhealthy' | 'degraded';
  timestamp: Date;
  checks: Record<string, HealthCheck>;
  version: string;
  uptime: number;
}

export interface HealthCheck {
  status: 'healthy' | 'unhealthy';
  message?: string;
  responseTime?: number;
  lastChecked: Date;
}

// ============================================================================
// FEATURE FLAG TYPES
// ============================================================================

export interface FeatureFlag {
  id: string;
  name: string;
  description?: string;
  enabled: boolean;
  percentage?: number; // For gradual rollouts
  userSegments?: string[];
  conditions?: FeatureCondition[];
  createdAt: Date;
  updatedAt: Date;
}

export interface FeatureCondition {
  attribute: string;
  operator: 'equals' | 'not_equals' | 'contains' | 'greater_than' | 'less_than';
  value: unknown;
}

// ============================================================================
// WEBHOOK TYPES
// ============================================================================

export interface Webhook {
  id: string;
  url: string;
  events: string[];
  secret?: string;
  isActive: boolean;
  headers?: Record<string, string>;
  retryConfig?: RetryConfig;
  createdAt: Date;
  updatedAt: Date;
}

export interface WebhookEvent {
  id: string;
  webhookId: string;
  event: string;
  payload: Record<string, unknown>;
  status: 'pending' | 'sent' | 'failed' | 'retries_exhausted';
  attempts: number;
  lastAttemptAt?: Date;
  response?: WebhookResponse;
  createdAt: Date;
}

export interface WebhookResponse {
  statusCode: number;
  headers: Record<string, string>;
  body?: string;
  responseTime: number;
}

export interface RetryConfig {
  maxAttempts: number;
  backoffMs: number;
  maxBackoffMs: number;
}

// ============================================================================
// AUDIT LOG TYPES
// ============================================================================

export interface AuditLog {
  id: string;
  action: string;
  resourceType: string;
  resourceId: string;
  userId: string;
  userRole: UserRole;
  
  previousState?: Record<string, unknown>;
  newState?: Record<string, unknown>;
  changes?: AuditChange[];
  
  ipAddress?: string;
  userAgent?: string;
  metadata?: Record<string, unknown>;
  
  createdAt: Date;
}

export interface AuditChange {
  field: string;
  oldValue: unknown;
  newValue: unknown;
}

// ============================================================================
// RBAC & PERMISSION TYPES
// ============================================================================

export type Permission = 
  | 'jobs:read' | 'jobs:write' | 'jobs:delete'
  | 'payments:read' | 'payments:write' | 'payments:refund'
  | 'workers:read' | 'workers:write' | 'workers:suspend' | 'workers:ban'
  | 'customers:read' | 'customers:write'
  | 'disputes:read' | 'disputes:write' | 'disputes:resolve'
  | 'admin:read' | 'admin:write' | 'admin:super'
  | 'analytics:read' | 'analytics:export'
  | 'settings:read' | 'settings:write';

export interface Role {
  id: string;
  name: string;
  description?: string;
  permissions: Permission[];
  isSystem: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface UserRoles {
  userId: string;
  roleId: string;
  assignedBy: string;
  assignedAt: Date;
  expiresAt?: Date;
}

// ============================================================================
// JOB MATCHING TYPES
// ============================================================================

export interface JobMatch {
  jobId: string;
  workerId: string;
  score: number; // 0-100 match score
  factors: MatchFactors;
  distance: number; // km
  estimatedArrivalTime: number; // minutes
}

export interface MatchFactors {
  distanceScore: number;
  availabilityScore: number;
  ratingScore: number;
  categoryScore: number;
  languageScore: number;
  previousJobsScore: number;
}

// ============================================================================
// INSURANCE TYPES
// ============================================================================

export interface ServiceInsurance {
  id: string;
  jobId: string;
  provider: string;
  policyNumber: string;
  coverageAmount: number;
  premium: number;
  status: 'active' | 'claimed' | 'expired' | 'cancelled';
  validFrom: Date;
  validUntil: Date;
  terms: string;
}

export interface InsuranceClaim {
  id: string;
  insuranceId: string;
  jobId: string;
  claimedBy: string;
  claimedByRole: UserRole;
  amount: number;
  reason: string;
  status: 'pending' | 'approved' | 'rejected' | 'paid';
  evidence: string[];
  assessedBy?: string;
  assessmentNotes?: string;
  decidedAt?: Date;
  paidAt?: Date;
  createdAt: Date;
}

// ============================================================================
// SUBSCRIPTION TYPES
// ============================================================================

export type SubscriptionPlan = 'basic' | 'premium' | 'enterprise';
export type SubscriptionStatus = 'active' | 'cancelled' | 'expired' | 'trial';

export interface Subscription {
  id: string;
  customerId: string;
  plan: SubscriptionPlan;
  status: SubscriptionStatus;
  
  // Pricing
  monthlyPrice: number;
  yearlyPrice: number;
  currentPeriodStart: Date;
  currentPeriodEnd: Date;
  
  // Features
  priorityBooking: boolean;
  discountedRates: number; // percentage
  freeInspections: number;
  dedicatedSupport: boolean;
  
  // Billing
  billingCycle: 'monthly' | 'yearly';
  nextBillingDate: Date;
  paymentMethod?: string;
  
  createdAt: Date;
  updatedAt: Date;
  cancelledAt?: Date;
}

// ============================================================================
// LOYALTY PROGRAM TYPES
// ============================================================================

export interface LoyaltyProgram {
  id: string;
  name: string;
  description?: string;
  tiers: LoyaltyTier[];
  rules: LoyaltyRules;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface LoyaltyTier {
  name: string;
  minPoints: number;
  maxPoints?: number;
  benefits: string[];
  multiplier: number; // Points earning multiplier
}

export interface LoyaltyRules {
  pointsPerRupee: number;
  redemptionRate: number; // Points per rupee of discount
  minRedemptionPoints: number;
  maxRedemptionPerOrder: number;
  expiryMonths: number;
}

export interface LoyaltyTransaction {
  id: string;
  customerId: string;
  type: 'earn' | 'redeem' | 'adjust' | 'expire';
  points: number;
  balanceBefore: number;
  balanceAfter: number;
  referenceId?: string; // Job ID, Order ID
  description: string;
  expiresAt?: Date;
  createdAt: Date;
}

// ============================================================================
// REFERRAL TYPES
// ============================================================================

export interface ReferralProgram {
  id: string;
  name: string;
  referrerBonus: number;
  refereeBonus: number;
  bonusType: 'fixed' | 'percentage';
  maxReferrals?: number;
  minOrderValue?: number;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface Referral {
  id: string;
  programId: string;
  referrerId: string;
  refereeId: string;
  referralCode: string;
  status: 'pending' | 'completed' | 'expired';
  bonusPaid: boolean;
  refereeFirstOrderId?: string;
  createdAt: Date;
  completedAt?: Date;
  expiresAt: Date;
}

// ============================================================================
// PROMO & DISCOUNT TYPES
// ============================================================================

export type PromoType = 'percentage' | 'fixed' | 'bogo';
export type PromoScope = 'all' | 'category' | 'service' | 'user';

export interface PromoCode {
  id: string;
  code: string;
  type: PromoType;
  value: number;
  scope: PromoScope;
  scopeIds?: string[]; // Category IDs, Service IDs, User IDs
  
  // Usage limits
  maxUses?: number;
  maxUsesPerUser?: number;
  currentUses: number;
  
  // Validity
  minOrderValue?: number;
  maxDiscount?: number;
  validFrom: Date;
  validUntil: Date;
  
  // Conditions
  applicableDays?: string[]; // Monday, Tuesday, etc.
  applicableHours?: TimeSlot;
  firstTimeUserOnly?: boolean;
  newUsersOnly?: boolean;
  
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

// ============================================================================
// COMMISSION TYPES
// ============================================================================

export interface CommissionStructure {
  id: string;
  name: string;
  category?: ServiceCategory;
  
  // Commission rates
  platformCommission: number; // percentage
  paymentGatewayFee: number; // percentage
  gst: number; // percentage
  
  // Worker tiers
  workerTier: 'bronze' | 'silver' | 'gold' | 'platinum';
  minRating?: number;
  minJobs?: number;
  
  // Incentives
  bonusThreshold?: number; // jobs per month
  bonusAmount?: number;
  
  isActive: boolean;
  validFrom: Date;
  validUntil?: Date;
  createdAt: Date;
  updatedAt: Date;
}

export interface CommissionSettlement {
  id: string;
  workerId: string;
  periodStart: Date;
  periodEnd: Date;
  
  // Earnings
  grossEarnings: number;
  platformCommission: number;
  paymentFees: number;
  taxes: number;
  bonuses: number;
  penalties: number;
  netEarnings: number;
  
  // Settlement
  status: 'pending' | 'processing' | 'completed' | 'failed';
  settlementDate?: Date;
  settlementReference?: string;
  
  createdAt: Date;
  updatedAt: Date;
}

// ============================================================================
// SLA & QUALITY TYPES
// ============================================================================

export interface ServiceLevelAgreement {
  id: string;
  name: string;
  category?: ServiceCategory;
  
  // Time commitments
  maxResponseTime: number; // minutes
  maxArrivalTime: number; // minutes
  maxCompletionTime: number; // minutes
  
  // Quality standards
  minRating: number;
  maxCancellationRate: number; // percentage
  maxDisputeRate: number; // percentage
  
  // Penalties
  lateArrivalPenalty: number; // percentage
  cancellationPenalty: number; // percentage
  lowRatingPenalty: number; // percentage
  
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface SLABreach {
  id: string;
  slaId: string;
  jobId: string;
  workerId: string;
  breachType: 'response' | 'arrival' | 'completion' | 'rating' | 'cancellation';
  expectedValue: number;
  actualValue: number;
  penaltyAmount: number;
  reason?: string;
  waived: boolean;
  waivedBy?: string;
  waivedReason?: string;
  createdAt: Date;
}

// ============================================================================
// INVENTORY TYPES (for workers)
// ============================================================================

export interface WorkerInventory {
  id: string;
  workerId: string;
  items: InventoryItem[];
  lastUpdated: Date;
}

export interface InventoryItem {
  id: string;
  name: string;
  category: string;
  quantity: number;
  unit: string;
  minStock: number;
  costPerUnit: number;
  supplier?: string;
  lastRestocked?: Date;
}

// ============================================================================
// SHIFT MANAGEMENT TYPES
// ============================================================================

export interface WorkerShift {
  id: string;
  workerId: string;
  date: Date;
  startTime: string; // HH:mm
  endTime: string; // HH:mm
  status: 'scheduled' | 'active' | 'completed' | 'cancelled';
  breakSlots?: TimeSlot[];
  assignedArea?: ServiceArea;
  notes?: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface ShiftMetrics {
  shiftId: string;
  workerId: string;
  date: Date;
  
  // Activity
  onlineDuration: number; // minutes
  idleDuration: number; // minutes
  jobDuration: number; // minutes
  
  // Performance
  jobsCompleted: number;
  jobsAssigned: number;
  acceptanceRate: number;
  avgResponseTime: number;
  
  // Earnings
  earnings: number;
  tips: number;
  
  createdAt: Date;
}

// ============================================================================
// VEHICLE TYPES (for workers)
// ============================================================================

export interface WorkerVehicle {
  id: string;
  workerId: string;
  type: 'bike' | 'scooter' | 'car' | 'auto' | 'cycle';
  registrationNumber: string;
  model: string;
  color: string;
  
  // Documents
  insuranceNumber?: string;
  insuranceExpiry?: Date;
  pollutionCertificate?: string;
  pollutionExpiry?: Date;
  
  // Verification
  isVerified: boolean;
  verifiedBy?: string;
  verifiedAt?: Date;
  
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

// ============================================================================
// TRAINING & CERTIFICATION TYPES
// ============================================================================

export interface TrainingModule {
  id: string;
  title: string;
  description?: string;
  category?: ServiceCategory;
  duration: number; // minutes
  type: 'video' | 'document' | 'quiz' | 'practical';
  
  // Content
  contentUrl?: string;
  passingScore?: number; // for quizzes
  
  // Prerequisites
  requiredModules?: string[];
  requiredExperience?: number; // months
  
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface WorkerTraining {
  id: string;
  workerId: string;
  moduleId: string;
  status: 'not_started' | 'in_progress' | 'completed' | 'failed';
  startedAt?: Date;
  completedAt?: Date;
  score?: number;
  attempts: number;
  certificateUrl?: string;
}

export interface Certification {
  id: string;
  workerId: string;
  name: string;
  issuer: string;
  certificateNumber: string;
  validFrom: Date;
  validUntil: Date;
  documentUrl: string;
  isVerified: boolean;
  verifiedBy?: string;
  verifiedAt?: Date;
  createdAt: Date;
  updatedAt: Date;
}
