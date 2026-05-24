import { BookingRepository } from './booking.repository';
import { BookingStatus } from '@prisma/client';

export class BookingService {
  private bookingRepository = new BookingRepository();

  async getCategories() {
    return this.bookingRepository.findCategories();
  }

  async getServices() {
    return this.bookingRepository.findServices();
  }

  async createBooking(customerId: string, data: { serviceId: string; addressId: string; scheduledFor: Date; notes?: string }) {
    // Basic calculation for total amount
    const services = await this.bookingRepository.findServices();
    const service = services.find(s => s.id === data.serviceId);
    if (!service) throw new Error('Service not found');

    const totalAmount = service.basePrice; // In a real app, include taxes, add-ons etc.

    return this.bookingRepository.createBooking({
      customer: { connect: { id: customerId } },
      service: { connect: { id: data.serviceId } },
      address: { connect: { id: data.addressId } },
      scheduledFor: data.scheduledFor,
      totalAmount,
      notes: data.notes,
      status: BookingStatus.REQUESTED
    });
  }

  async getCustomerBookings(customerId: string) {
    return this.bookingRepository.findCustomerBookings(customerId);
  }

  async getBookingById(bookingId: string) {
    const booking = await this.bookingRepository.findBookingById(bookingId);
    if (!booking) throw new Error('Booking not found');
    return booking;
  }
}
