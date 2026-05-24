import { UserRepository } from './user.repository';
import { Prisma } from '@prisma/client';

export class UserService {
  private userRepository = new UserRepository();

  async getProfile(userId: string) {
    const user = await this.userRepository.findUserById(userId);
    if (!user) throw new Error('User not found');
    return user;
  }

  async updateProfile(userId: string, data: { fullName?: string; avatar?: string; phone?: string }) {
    return this.userRepository.updateUser(userId, data);
  }

  async addAddress(userId: string, data: { title: string; address: string; city: string; state: string; zipCode: string; latitude?: number; longitude?: number; isDefault?: boolean }) {
    return this.userRepository.addAddress({
      ...data,
      user: { connect: { id: userId } }
    });
  }

  async getAddresses(userId: string) {
    return this.userRepository.findUserAddresses(userId);
  }
}
