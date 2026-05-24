import { PrismaClient, Booking, Service, Category, Prisma, BookingStatus } from '@prisma/client';
import { prisma } from '../../server';

export class BookingRepository {
  async findCategories(): Promise<Category[]> {
    return prisma.category.findMany({ include: { services: true } });
  }

  async findServices(): Promise<Service[]> {
    return prisma.service.findMany({ include: { category: true } });
  }

  async createBooking(data: Prisma.BookingCreateInput): Promise<Booking> {
    return prisma.booking.create({ data });
  }

  async findCustomerBookings(customerId: string): Promise<Booking[]> {
    return prisma.booking.findMany({
      where: { customerId },
      include: { service: true, address: true, job: true },
      orderBy: { createdAt: 'desc' }
    });
  }

  async findBookingById(id: string): Promise<Booking | null> {
    return prisma.booking.findUnique({
      where: { id },
      include: { service: true, address: true, job: { include: { worker: true, tracking: true } } }
    });
  }

  async updateBookingStatus(id: string, status: BookingStatus): Promise<Booking> {
    return prisma.booking.update({
      where: { id },
      data: { status }
    });
  }
}
