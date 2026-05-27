import { randomUUID } from 'crypto';
import {
  AddressDto,
  AiDiagnosticDto,
  BookingDto,
  BookingStatus,
  CategoryDto,
  ChatMessageDto,
  JobDto,
  JobEventDto,
  NotificationDto,
  OtpPurpose,
  ServiceDto,
  TransactionCategory,
  TransactionDto,
  UserDto,
  WalletDto,
  WorkerDto
} from '../dto/domain';

const now = (): string => new Date().toISOString();

export interface OtpSessionRecord {
  id: string;
  phone?: string;
  email?: string;
  purpose: OtpPurpose;
  otpHash: string;
  status: 'PENDING' | 'VERIFIED' | 'EXPIRED' | 'LOCKED';
  attempts: number;
  expiresAt: string;
  ipAddress?: string;
  deviceId?: string;
  createdAt: string;
  verifiedAt?: string;
}

export interface RefreshTokenRecord {
  id: string;
  tokenHash: string;
  userId: string;
  tokenFamily: string;
  replacedByTokenId?: string;
  revokedAt?: string;
  expiresAt: string;
  createdAt: string;
}

class UserRepository {
  private readonly users = new Map<string, UserDto>();

  constructor() {
    this.save({
      id: 'cust_demo',
      fullName: 'Vishal Kumar',
      email: 'vishal@example.com',
      phone: '9876543210',
      authProvider: 'LOCAL',
      role: 'CUSTOMER',
      isVerified: true,
      isProfileComplete: true,
      address: 'A-1204, Tower 3, Cyber City Apartments, Sector 42',
      createdAt: now(),
      updatedAt: now()
    });
  }

  save(user: UserDto): UserDto {
    this.users.set(user.id, user);
    return user;
  }

  findById(id: string): UserDto | undefined {
    return this.users.get(id);
  }

  findByPhone(phone: string): UserDto | undefined {
    return [...this.users.values()].find((user) => user.phone === phone);
  }

  findByEmail(email: string): UserDto | undefined {
    return [...this.users.values()].find((user) => user.email === email);
  }

  findByGoogleId(googleId: string): UserDto | undefined {
    return [...this.users.values()].find((user) => user.googleId === googleId);
  }

  upsertLocal(contact: { phone?: string; email?: string }): UserDto {
    const existing = contact.phone ? this.findByPhone(contact.phone) : contact.email ? this.findByEmail(contact.email) : undefined;
    if (existing) return existing;

    return this.save({
      id: randomUUID(),
      fullName: 'User',
      email: contact.email,
      phone: contact.phone,
      authProvider: 'LOCAL',
      role: 'CUSTOMER',
      isVerified: true,
      isProfileComplete: false,
      createdAt: now(),
      updatedAt: now()
    });
  }

  updateProfile(userId: string, patch: Partial<Pick<UserDto, 'fullName' | 'email' | 'phone' | 'avatar' | 'address' | 'isProfileComplete'>>): UserDto | undefined {
    const user = this.findById(userId);
    if (!user) return undefined;
    const updated = { ...user, ...patch, updatedAt: now() };
    this.save(updated);
    return updated;
  }
}

class OtpRepository {
  private readonly sessions = new Map<string, OtpSessionRecord>();

  save(record: OtpSessionRecord): OtpSessionRecord {
    this.sessions.set(record.id, record);
    return record;
  }

  findById(id: string): OtpSessionRecord | undefined {
    return this.sessions.get(id);
  }

  findLatestPending(contact: { phone?: string; email?: string }, purpose: OtpPurpose): OtpSessionRecord | undefined {
    return [...this.sessions.values()]
      .filter((session) => session.status === 'PENDING' && session.purpose === purpose)
      .filter((session) => (contact.phone ? session.phone === contact.phone : session.email === contact.email))
      .sort((a, b) => b.createdAt.localeCompare(a.createdAt))[0];
  }
}

class TokenRepository {
  private readonly tokens = new Map<string, RefreshTokenRecord>();

  save(record: RefreshTokenRecord): RefreshTokenRecord {
    this.tokens.set(record.id, record);
    return record;
  }

  findById(id: string): RefreshTokenRecord | undefined {
    return this.tokens.get(id);
  }

  revokeFamily(tokenFamily: string): void {
    for (const token of this.tokens.values()) {
      if (token.tokenFamily === tokenFamily) token.revokedAt = now();
    }
  }

  revoke(id: string): void {
    const token = this.tokens.get(id);
    if (token) token.revokedAt = now();
  }
}

class CatalogRepository {
  private readonly categories = new Map<string, CategoryDto>();
  private readonly services = new Map<string, ServiceDto>();

  constructor() {
    const categories: CategoryDto[] = [
      { id: 'cat_ac', name: 'AC Service', description: 'Cooling diagnostics and repair', icon: 'ac_unit', isEmergency: true },
      { id: 'cat_plumbing', name: 'Plumbing', description: 'Leaks, taps, pipes, drainage', icon: 'plumbing', isEmergency: true },
      { id: 'cat_electrical', name: 'Electrical', description: 'Switches, wiring, power issues', icon: 'electrical_services', isEmergency: true },
      { id: 'cat_cleaning', name: 'Cleaning', description: 'Deep cleaning and appliance care', icon: 'cleaning_services', isEmergency: false }
    ];

    const services: ServiceDto[] = [
      { id: 'svc_ac_repair', categoryId: 'cat_ac', name: 'AC Capacitor Replacement', description: 'Diagnose and replace AC capacitor', basePrice: 299, estimatedDurationMinutes: 60, icon: 'ac_unit' },
      { id: 'svc_ac_filter', categoryId: 'cat_ac', name: 'AC Filter Service', description: 'Filter cleaning and efficiency restore', basePrice: 899, estimatedDurationMinutes: 30, icon: 'filter_alt' },
      { id: 'svc_plumbing_leak', categoryId: 'cat_plumbing', name: 'Water Leak Repair', description: 'Emergency leak inspection and repair', basePrice: 399, estimatedDurationMinutes: 45, icon: 'water_drop' },
      { id: 'svc_electrician', categoryId: 'cat_electrical', name: 'Electrical Expert Visit', description: 'On-demand electrician service', basePrice: 349, estimatedDurationMinutes: 45, icon: 'bolt' },
      { id: 'svc_cleaning', categoryId: 'cat_cleaning', name: 'Deep Cleaning', description: 'Home and appliance cleaning', basePrice: 650, estimatedDurationMinutes: 120, icon: 'cleaning_services' }
    ];

    categories.forEach((category) => this.categories.set(category.id, category));
    services.forEach((service) => this.services.set(service.id, service));
  }

  listCategories(): CategoryDto[] {
    return [...this.categories.values()];
  }

  listServices(categoryId?: string, q?: string): ServiceDto[] {
    const term = q?.toLowerCase();
    return [...this.services.values()].filter((service) => {
      const categoryMatch = categoryId ? service.categoryId === categoryId : true;
      const searchMatch = term ? `${service.name} ${service.description}`.toLowerCase().includes(term) : true;
      return categoryMatch && searchMatch;
    });
  }

  findService(id: string): ServiceDto | undefined {
    return this.services.get(id);
  }
}

class AddressRepository {
  private readonly addresses = new Map<string, AddressDto>();

  constructor() {
    this.save({
      id: 'addr_demo',
      userId: 'cust_demo',
      title: 'Home',
      address: 'A-1204, Tower 3, Cyber City Apartments, Sector 42',
      city: 'Bengaluru',
      state: 'Karnataka',
      zipCode: '560001',
      latitude: 12.9716,
      longitude: 77.5946,
      isDefault: true
    });
  }

  save(address: AddressDto): AddressDto {
    this.addresses.set(address.id, address);
    return address;
  }

  listByUser(userId: string): AddressDto[] {
    return [...this.addresses.values()].filter((address) => address.userId === userId);
  }

  findById(id: string): AddressDto | undefined {
    return this.addresses.get(id);
  }

  delete(id: string): void {
    this.addresses.delete(id);
  }
}

class WorkerRepository {
  private readonly workers = new Map<string, WorkerDto>();

  constructor() {
    [
      { id: 'worker_amit', fullName: 'Amit Kumar', latitude: 12.974, longitude: 77.599, rating: 4.9, jobCount: 120 },
      { id: 'worker_suresh', fullName: 'Suresh Singh', latitude: 12.965, longitude: 77.588, rating: 4.7, jobCount: 98 },
      { id: 'worker_ramesh', fullName: 'Ramesh Kumar', latitude: 12.982, longitude: 77.604, rating: 4.8, jobCount: 210 }
    ].forEach((worker) => {
      this.save({
        ...worker,
        userId: `${worker.id}_user`,
        phone: '9999999999',
        categoryIds: ['cat_ac', 'cat_electrical'],
        serviceIds: ['svc_ac_repair', 'svc_ac_filter', 'svc_electrician'],
        experienceYears: 5,
        verified: true,
        availability: 'available'
      });
    });
  }

  save(worker: WorkerDto): WorkerDto {
    this.workers.set(worker.id, worker);
    return worker;
  }

  findById(id: string): WorkerDto | undefined {
    return this.workers.get(id);
  }

  listNearby(latitude: number, longitude: number, serviceId?: string): WorkerDto[] {
    return [...this.workers.values()]
      .filter((worker) => worker.availability === 'available')
      .filter((worker) => (serviceId ? worker.serviceIds.includes(serviceId) : true))
      .map((worker) => ({ worker, distance: distanceMeters(latitude, longitude, worker.latitude, worker.longitude) }))
      .filter((entry) => entry.distance <= 10000)
      .sort((a, b) => a.distance - b.distance)
      .map((entry) => entry.worker);
  }
}

class BookingRepository {
  private readonly bookings = new Map<string, BookingDto>();
  private readonly jobs = new Map<string, JobDto>();

  saveBooking(booking: BookingDto): BookingDto {
    this.bookings.set(booking.id, booking);
    return booking;
  }

  saveJob(job: JobDto): JobDto {
    this.jobs.set(job.id, job);
    return job;
  }

  findBooking(id: string): BookingDto | undefined {
    return this.bookings.get(id);
  }

  findJob(id: string): JobDto | undefined {
    return this.jobs.get(id);
  }

  findJobByBookingId(bookingId: string): JobDto | undefined {
    return [...this.jobs.values()].find((job) => job.bookingId === bookingId);
  }

  listBookingsByCustomer(customerId: string, status?: 'active' | 'history'): BookingDto[] {
    return [...this.bookings.values()].filter((booking) => {
      if (booking.customerId !== customerId) return false;
      if (status === 'active') return !['COMPLETED', 'CANCELLED'].includes(booking.status);
      if (status === 'history') return ['COMPLETED', 'CANCELLED'].includes(booking.status);
      return true;
    });
  }

  updateBookingStatus(id: string, status: BookingStatus): BookingDto | undefined {
    const booking = this.bookings.get(id);
    if (!booking) return undefined;
    const updated = { ...booking, status, updatedAt: now() };
    this.saveBooking(updated);
    const job = this.findJobByBookingId(id);
    if (job) {
      job.status = status;
      job.timeline.push({
        id: randomUUID(),
        jobId: job.id,
        status,
        label: statusLabel(status),
        occurredAt: now()
      });
      this.saveJob(job);
    }
    return updated;
  }
}

class WalletRepository {
  private readonly wallets = new Map<string, WalletDto>();
  private readonly transactions = new Map<string, TransactionDto>();

  constructor() {
    this.saveWallet({ id: 'wallet_demo', userId: 'cust_demo', availableBalance: 2450, escrowBalance: 0, currency: 'INR' });
  }

  saveWallet(wallet: WalletDto): WalletDto {
    this.wallets.set(wallet.id, wallet);
    return wallet;
  }

  findByUserId(userId: string): WalletDto {
    const existing = [...this.wallets.values()].find((wallet) => wallet.userId === userId);
    if (existing) return existing;
    return this.saveWallet({ id: randomUUID(), userId, availableBalance: 0, escrowBalance: 0, currency: 'INR' });
  }

  addTransaction(input: Omit<TransactionDto, 'id' | 'createdAt'>): TransactionDto {
    const transaction: TransactionDto = { ...input, id: randomUUID(), createdAt: now() };
    this.transactions.set(transaction.id, transaction);
    return transaction;
  }

  listTransactions(walletId: string): TransactionDto[] {
    return [...this.transactions.values()].filter((transaction) => transaction.walletId === walletId).sort((a, b) => b.createdAt.localeCompare(a.createdAt));
  }

  mutateBalance(userId: string, amount: number, category: TransactionCategory, type: 'CREDIT' | 'DEBIT', bookingId?: string): { wallet: WalletDto; transaction: TransactionDto } {
    const wallet = this.findByUserId(userId);
    const before = wallet.availableBalance;
    const after = type === 'CREDIT' ? before + amount : before - amount;
    wallet.availableBalance = after;
    this.saveWallet(wallet);
    return {
      wallet,
      transaction: this.addTransaction({
        walletId: wallet.id,
        bookingId,
        amount,
        type,
        category,
        status: 'SUCCESS',
        reference: randomUUID(),
        balanceBefore: before,
        balanceAfter: after
      })
    };
  }

  holdEscrow(userId: string, bookingId: string, amount: number): WalletDto {
    const wallet = this.findByUserId(userId);
    const before = wallet.availableBalance;
    wallet.availableBalance -= amount;
    wallet.escrowBalance += amount;
    this.saveWallet(wallet);
    this.addTransaction({
      walletId: wallet.id,
      bookingId,
      amount,
      type: 'DEBIT',
      category: 'BOOKING_ESCROW',
      status: 'SUCCESS',
      reference: randomUUID(),
      balanceBefore: before,
      balanceAfter: wallet.availableBalance
    });
    return wallet;
  }
}

class AiRepository {
  private readonly diagnostics = new Map<string, AiDiagnosticDto>();

  save(diagnostic: AiDiagnosticDto): AiDiagnosticDto {
    this.diagnostics.set(diagnostic.id, diagnostic);
    return diagnostic;
  }

  findById(id: string): AiDiagnosticDto | undefined {
    return this.diagnostics.get(id);
  }

  listByUser(userId: string): AiDiagnosticDto[] {
    return [...this.diagnostics.values()].filter((diagnostic) => diagnostic.userId === userId).sort((a, b) => b.createdAt.localeCompare(a.createdAt));
  }
}

class NotificationRepository {
  private readonly notifications = new Map<string, NotificationDto>();

  constructor() {
    this.create('cust_demo', 'Predictive Alert: AC', 'Your AC is showing signs of cooling loss. Schedule maintenance soon.', 'predictive', {});
  }

  create(userId: string, title: string, message: string, type: string, data: Record<string, unknown>): NotificationDto {
    const notification: NotificationDto = { id: randomUUID(), userId, title, message, type, data, isRead: false, createdAt: now() };
    this.notifications.set(notification.id, notification);
    return notification;
  }

  listByUser(userId: string): NotificationDto[] {
    return [...this.notifications.values()].filter((notification) => notification.userId === userId).sort((a, b) => b.createdAt.localeCompare(a.createdAt));
  }

  markRead(id: string): NotificationDto | undefined {
    const notification = this.notifications.get(id);
    if (!notification) return undefined;
    notification.isRead = true;
    this.notifications.set(id, notification);
    return notification;
  }
}

class ChatRepository {
  private readonly messages = new Map<string, ChatMessageDto>();

  create(conversationId: string, senderId: string, body: string): ChatMessageDto {
    const message: ChatMessageDto = { id: randomUUID(), conversationId, senderId, body, createdAt: now() };
    this.messages.set(message.id, message);
    return message;
  }

  list(conversationId: string): ChatMessageDto[] {
    return [...this.messages.values()].filter((message) => message.conversationId === conversationId).sort((a, b) => a.createdAt.localeCompare(b.createdAt));
  }
}

const distanceMeters = (lat1: number, lon1: number, lat2: number, lon2: number): number => {
  const earthRadiusMeters = 6371000;
  const toRadians = (value: number): number => (value * Math.PI) / 180;
  const dLat = toRadians(lat2 - lat1);
  const dLon = toRadians(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRadians(lat1)) * Math.cos(toRadians(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
  return earthRadiusMeters * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
};

const statusLabel = (status: BookingStatus): string => {
  const labels: Record<BookingStatus, string> = {
    REQUESTED: 'Booking Requested',
    SEARCHING: 'Finding Expert',
    ASSIGNED: 'Worker Assigned',
    ARRIVING: 'Worker Moving',
    STARTED: 'Service Running',
    COMPLETED: 'Complete',
    CANCELLED: 'Cancelled'
  };
  return labels[status];
};

export const userRepository = new UserRepository();
export const otpRepository = new OtpRepository();
export const tokenRepository = new TokenRepository();
export const catalogRepository = new CatalogRepository();
export const addressRepository = new AddressRepository();
export const workerRepository = new WorkerRepository();
export const bookingRepository = new BookingRepository();
export const walletRepository = new WalletRepository();
export const aiRepository = new AiRepository();
export const notificationRepository = new NotificationRepository();
export const chatRepository = new ChatRepository();

export const newId = (): string => randomUUID();
export const timestamp = now;
