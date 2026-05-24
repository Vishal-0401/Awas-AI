import { PrismaClient, User, Address, Prisma } from '@prisma/client';
import { prisma } from '../../server';

export class UserRepository {
  async findUserById(id: string): Promise<User | null> {
    return prisma.user.findUnique({ where: { id } });
  }

  async updateUser(id: string, data: Prisma.UserUpdateInput): Promise<User> {
    return prisma.user.update({ where: { id }, data });
  }

  async addAddress(data: Prisma.AddressCreateInput): Promise<Address> {
    return prisma.address.create({ data });
  }

  async findUserAddresses(userId: string): Promise<Address[]> {
    return prisma.address.findMany({ where: { userId } });
  }
}
