import { AddressDto } from '../dto/domain';
import { addressRepository, newId, userRepository } from '../repositories/store';
import { NotFoundAppError } from '../utils/AppError';

class ProfileService {
  me(userId: string) {
    const user = userRepository.findById(userId);
    if (!user) throw new NotFoundAppError('User not found');
    return user;
  }

  update(userId: string, patch: { fullName?: string; email?: string; phone?: string; avatar?: string; address?: string; isProfileComplete?: boolean }) {
    const updated = userRepository.updateProfile(userId, patch);
    if (!updated) throw new NotFoundAppError('User not found');
    return updated;
  }

  completeProfile(userId: string, input: { fullName: string; address: string; email?: string; avatar?: string }) {
    const updated = this.update(userId, { ...input, isProfileComplete: true });
    const existingDefault = addressRepository.listByUser(userId).find((address) => address.isDefault);
    if (!existingDefault) {
      addressRepository.save({
        id: newId(),
        userId,
        title: 'Home',
        address: input.address,
        city: '',
        state: '',
        zipCode: '',
        latitude: 12.9716,
        longitude: 77.5946,
        isDefault: true
      });
    }
    return updated;
  }

  listAddresses(userId: string): AddressDto[] {
    return addressRepository.listByUser(userId);
  }

  createAddress(userId: string, input: Omit<AddressDto, 'id' | 'userId'>): AddressDto {
    const address = addressRepository.save({ ...input, id: newId(), userId });
    if (input.isDefault) {
      userRepository.updateProfile(userId, { address: input.address });
    }
    return address;
  }

  deleteAddress(userId: string, addressId: string): void {
    const address = addressRepository.findById(addressId);
    if (!address || address.userId !== userId) throw new NotFoundAppError('Address not found');
    addressRepository.delete(addressId);
  }
}

export const profileService = new ProfileService();
