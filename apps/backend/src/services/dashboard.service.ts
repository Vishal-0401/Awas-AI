import { addressRepository, aiRepository, bookingRepository, catalogRepository, userRepository, workerRepository } from '../repositories/store';
import { NotFoundAppError } from '../utils/AppError';

class DashboardService {
  getDashboard(userId: string): Record<string, unknown> {
    const user = userRepository.findById(userId);
    if (!user) throw new NotFoundAppError('User not found');
    const defaultAddress = addressRepository.listByUser(userId).find((address) => address.isDefault);
    const history = aiRepository.listByUser(userId);
    const nearbyWorkers = workerRepository.listNearby(defaultAddress?.latitude ?? 12.9716, defaultAddress?.longitude ?? 77.5946);
    const activeBooking = bookingRepository.listBookingsByCustomer(userId, 'active')[0];
    const latestDiagnostic = history[0];

    return {
      user,
      address: defaultAddress?.address ?? user.address ?? 'Add your home address',
      healthScore: latestDiagnostic?.healthScore ?? 87,
      alertsCount: latestDiagnostic?.detectedIssues.length ?? 2,
      appliancesCount: 8,
      lastScan: latestDiagnostic ? latestDiagnostic.createdAt : 'Never',
      predictiveAlerts: [
        {
          title: 'AC Filter Replacement',
          description: 'Estimated 85% efficiency drop in 7 days',
          severity: 'medium'
        },
        {
          title: 'Water Purifier Service',
          description: 'RO membrane nearing end of life',
          severity: 'high'
        }
      ],
      nearbyWorkers: nearbyWorkers.length,
      activeBooking,
      categories: catalogRepository.listCategories().slice(0, 4)
    };
  }
}

export const dashboardService = new DashboardService();
