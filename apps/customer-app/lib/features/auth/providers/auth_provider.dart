

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/services/api_client.dart';
import '../services/auth_service.dart';

enum AuthState {


  initial,
  unauthenticated,
  onboardingCompleted,
  authenticated,
  profileIncomplete,
}

class AuthNotifier extends StateNotifier<AuthState> {

  final AuthService _authService =
      AuthService(const ApiClient(baseUrl: 'http://localhost:3000'));


  String? pendingPhone;

  AuthNotifier() : super(AuthState.initial) {
    _checkAuthState();
  }

  Future<Map<String, dynamic>?> getStoredUserData() async {
    final box = await Hive.openBox('authBox');
    final userDataStr = box.get('userData');
    if (userDataStr != null) {
      return jsonDecode(userDataStr);
    }
    return null;
  }

  Future<void> _checkAuthState() async {
    final box = await Hive.openBox('authBox');
    final isFirstLaunch = box.get('isFirstLaunch', defaultValue: true);
    final token = box.get('accessToken');
    final isProfileComplete = box.get('isProfileComplete', defaultValue: false);

    if (isFirstLaunch) {
      state = AuthState.unauthenticated;
    } else if (token == null) {
      state = AuthState.onboardingCompleted;
    } else if (!isProfileComplete) {
      state = AuthState.profileIncomplete;
    } else {
      state = AuthState.authenticated;
    }
  }

  Future<void> completeOnboarding() async {
    final box = await Hive.openBox('authBox');
    await box.put('isFirstLaunch', false);
    state = AuthState.onboardingCompleted;
  }

  Future<void> sendOtp(String phone) async {
    await _authService.sendOtp(phone);
    pendingPhone = phone;
  }

  Future<void> verifyOtp(String otp) async {
    if (pendingPhone == null) {
      // No pending phone means the flow is broken; treat as a local validation failure.
      // Keep thrown error message clean and user-friendly.
      throw Exception('Please enter your mobile number first');
    }

    final data = await _authService.verifyOtp(pendingPhone!, otp);
    await _handleLoginSuccess(data);

  }

  Future<void> loginWithGoogle() async {
    final data = await _authService.googleLogin();
    if (data != null) {
      await _handleLoginSuccess(data);
    }
  }

  Future<void> _handleLoginSuccess(Map<String, dynamic> data) async {
    final box = await Hive.openBox('authBox');
    
    // Store core tokens
    if (data['accessToken'] != null) {
      await box.put('accessToken', data['accessToken']);
    }
    if (data['refreshToken'] != null) {
      await box.put('refreshToken', data['refreshToken']);
    }

    // Store user data structurally as a JSON string
    if (data['user'] != null) {
      await box.put('userData', jsonEncode(data['user']));
    }
    
    await box.put('isFirstLaunch', false);
    
    final isProfileComplete = box.get('isProfileComplete', defaultValue: false);
    if (!isProfileComplete) {
      state = AuthState.profileIncomplete;
    } else {
      state = AuthState.authenticated;
    }
  }

  Future<void> completeProfile() async {
    final box = await Hive.openBox('authBox');
    await box.put('isProfileComplete', true);
    state = AuthState.authenticated;
  }

  Future<void> logout() async {
    final box = await Hive.openBox('authBox');
    await box.delete('accessToken');
    await box.delete('refreshToken');
    await box.delete('userData');
    state = AuthState.onboardingCompleted; // Don't show onboarding again
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
