import { randomInt } from 'crypto';
import { BookingDto, JobDto, JobPriority } from '../dto/domain';
import {
  addressRepository,
  bookingRepository,
  catalogRepository,
  newId,
  notificationRepository,
  timestamp,
  walletRepository,
  workerRepository
} from '../repositories/store';
import { NotFoundAppError, ValidationAppError } from '../utils/AppError';
import { emitToBooking, emitToJob, emitToUser } from './socketHub';

const serviceOtp = (): string => randomInt(1000, 9999).toString();

class BookingService {
  createBooking(userId: string, input: { serviceId: string; addressId: string; workerId?: string; scheduledFor?: string; priority?: JobPriority; diagnosticId?: string; notes?: string }): { booking: BookingDto; job: JobDto } {
    const service = catalogRepository.findService(input.serviceId);
    if (!service) throw new NotFoundAppError('Service not found');
    const address = addressRepository.findById(input.addressId);
    if (!address || address.userId !== userId) throw new NotFoundAppError('Address not found');
    const worker = input.workerId ? workerRepository.findById(input.workerId) : workerRepository.listNearby(address.latitude, address.longitude, input.serviceId)[0];
    if (!worker) throw new ValidationAppError('No verified worker available for this service');

    const basePrice = service.basePrice;
    const platformFee = Math.round(basePrice * 0.12);
    const taxes = Math.round(basePrice * 0.18);
    const totalAmount = basePrice + platformFee + taxes;
    const bookingId = newId();
    const jobId = newId();
    const booking: BookingDto = {
      id: bookingId,
      customerId: userId,
      serviceId: service.id,
      workerId: worker.id,
      addressId: address.id,
      status: 'ASSIGNED',
      priority: input.priority ?? 'normal',
      scheduledFor: input.scheduledFor,
      totalAmount,
      basePrice,
      platformFee,
      taxes,
      paymentStatus: 'PENDING',
      diagnosticId: input.diagnosticId,
      startOtp: serviceOtp(),
      endOtp: serviceOtp(),
      createdAt: timestamp(),
      updatedAt: timestamp()
    };
    const job: JobDto = {
      id: jobId,
      bookingId: booking.id,
      workerId: worker.id,
      status: 'ASSIGNED',
      etaMinutes: 12,
      timeline: [
        { id: newId(), jobId, status: 'REQUESTED', label: 'Booking Requested', occurredAt: timestamp() },
        { id: newId(), jobId, status: 'ASSIGNED', label: 'Worker Assigned', occurredAt: timestamp() }
      ]
    };

    bookingRepository.saveBooking(booking);
    bookingRepository.saveJob(job);
    const note = notificationRepository.create(userId, 'Expert assigned', `${worker.fullName} is assigned to your ${service.name}.`, 'booking', { bookingId: booking.id, jobId: job.id });
    emitToUser(userId, 'booking:assigned', { booking, job });
    emitToUser(userId, 'notification:new', note);
    return { booking, job };
  }

  list(userId: string, status?: 'active' | 'history') {
    return bookingRepository.listBookingsByCustomer(userId, status);
  }

  detail(userId: string, bookingId: string) {
    const booking = bookingRepository.findBooking(bookingId);
    if (!booking || booking.customerId !== userId) throw new NotFoundAppError('Booking not found');
    const job = bookingRepository.findJobByBookingId(booking.id);
    return { booking, job };
  }

  cancel(userId: string, bookingId: string, reason: string) {
    const booking = bookingRepository.findBooking(bookingId);
    if (!booking || booking.customerId !== userId) throw new NotFoundAppError('Booking not found');
    const updated = bookingRepository.updateBookingStatus(bookingId, 'CANCELLED');
    emitToBooking(bookingId, 'booking:cancelled', { booking: updated, reason });
    return updated;
  }

  payEscrow(userId: string, bookingId: string) {
    const booking = bookingRepository.findBooking(bookingId);
    if (!booking || booking.customerId !== userId) throw new NotFoundAppError('Booking not found');
    const wallet = walletRepository.holdEscrow(userId, bookingId, booking.totalAmount);
    const updated = { ...booking, paymentStatus: 'PAID' as const, updatedAt: timestamp() };
    bookingRepository.saveBooking(updated);
    emitToBooking(bookingId, 'payment:escrow:held', { booking: updated, wallet });
    emitToUser(userId, 'payment:escrow:held', { booking: updated, wallet });
    return { booking: updated, wallet };
  }

  tracking(userId: string, jobId: string) {
    const job = bookingRepository.findJob(jobId);
    if (!job) throw new NotFoundAppError('Job not found');
    const booking = bookingRepository.findBooking(job.bookingId);
    if (!booking || booking.customerId !== userId) throw new NotFoundAppError('Job not found');
    const worker = job.workerId ? workerRepository.findById(job.workerId) : undefined;
    return {
      job,
      booking,
      worker,
      location: worker ? { latitude: worker.latitude, longitude: worker.longitude, heading: 45, speed: 24 } : null,
      etaMinutes: job.etaMinutes ?? 12,
      startOtp: booking.startOtp
    };
  }

  updateTracking(workerId: string, jobId: string, input: { latitude: number; longitude: number; heading?: number; speed?: number }) {
    const job = bookingRepository.findJob(jobId);
    if (!job || job.workerId !== workerId) throw new NotFoundAppError('Job not found');
    emitToJob(jobId, 'worker:location:update', { jobId, ...input, updatedAt: timestamp() });
    return { jobId, ...input, updatedAt: timestamp() };
  }
}

export const bookingService = new BookingService();
