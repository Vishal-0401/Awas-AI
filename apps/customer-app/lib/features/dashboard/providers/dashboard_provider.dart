import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/models/api_response.dart';
import '../../../core/services/api_client.dart';
import '../../../core/constants/app_constants.dart';


class DashboardData {


  final String userName;
  final String address;
  final int healthScore;
  final int alertsCount;
  final int appliancesCount;
  final String lastScan;
  final List<dynamic> predictiveAlerts;
  final int nearbyWorkers;

  DashboardData({
    required this.userName,
    required this.address,
    required this.healthScore,
    required this.alertsCount,
    required this.appliancesCount,
    required this.lastScan,
    required this.predictiveAlerts,
    required this.nearbyWorkers,
  });
}

class DashboardNotifier extends StateNotifier<AsyncValue<DashboardData>> {
  DashboardNotifier() : super(const AsyncValue.loading()) {
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      state = const AsyncValue.loading();

      // Local cache for instant UI rendering
      final box = await Hive.openBox('authBox');
      final userJsonStr = box.get('userData');
      Map<String, dynamic>? localUser;
      if (userJsonStr != null) {
        localUser = jsonDecode(userJsonStr) as Map<String, dynamic>;
      }

      const baseUrl = AppConstants.apiV1BaseUrl;
      const client = ApiClient(baseUrl: baseUrl);

      ApiResponse<Map<String, dynamic>>? userApi;
      ApiResponse<List<dynamic>>? historyApi;
      ApiResponse<List<dynamic>>? trackingApi;

      try {
        userApi = await client.getJson<Map<String, dynamic>>(
          '/users/me',
          dataParser: (json) => (json as Map).cast<String, dynamic>(),
          requiresAuth: true,
        );
      } catch (_) {}

      try {
        historyApi = await client.getJson<List<dynamic>>(
          '/ai/history',
          dataParser: (json) => json as List<dynamic>,
          requiresAuth: true,
        );
      } catch (_) {}

      try {
        trackingApi = await client.getJson<List<dynamic>>(
          '/tracking/nearby',
          query: {'lat': '12.9716', 'lng': '77.5946'},
          dataParser: (json) => json as List<dynamic>,
          requiresAuth: true,
        );
      } catch (_) {}

      // Merge local cached user JSON with remote if available
      final user = userApi?.data ??
          localUser ??
          <String, dynamic>{};

      // Store latest user info in JSON format locally
      if (userApi?.data != null) {
        await box.put('userData', jsonEncode(userApi!.data));
      }

      final history = historyApi?.data ?? <dynamic>[];
      final workers = trackingApi?.data ?? <dynamic>[];


      final String name = user['fullName'] ?? 'User';
      final String addr = user['address'] ?? '123 Smart Ave, Tech Park';
      final int health =
          history.isNotEmpty ? (history[0]['healthScore'] ?? 85) : 100;

      final data = DashboardData(
        userName: name,
        address: addr,
        healthScore: health,
        alertsCount: 2,
        appliancesCount: 8,
        lastScan: history.isNotEmpty ? 'Today' : 'Never',
        predictiveAlerts: [
          {
            'title': 'AC Filter Replacement',
            'description': 'Estimated 85% efficiency drop in 7 days',
            'severity': 'medium',
          },
          {
            'title': 'Water Purifier Service',
            'description': 'RO membrane nearing end of life',
            'severity': 'high',
          },
        ],
        nearbyWorkers: workers.length,
      );

      state = AsyncValue.data(data);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardData>>((ref) {
  return DashboardNotifier();
});

