import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/models/api_response.dart';
import '../../../core/services/api_client.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ApiClient apiClient;

  AuthService(this.apiClient);

  Future<Map<String, dynamic>?> googleLogin() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // user canceled

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      throw Exception('Google authentication failed');
    }

    final ApiResponse<Map<String, dynamic>> api = await apiClient.postJson(
      '/api/v1/auth/google',
      body: {'idToken': idToken},
    );

    return api.data;
  }

  Future<void> sendOtp(String phone) async {
    await apiClient.postJson(
      '/api/v1/auth/send-otp',
      body: {'phone': phone},
      dataParser: (json) => json as Map<String, dynamic>,
    );
  }

  Future<void> sendEmailOtp(String email) async {
    await apiClient.postJson(
      '/api/v1/auth/send-otp',
      body: {'email': email},
      dataParser: (json) => json as Map<String, dynamic>,
    );
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final ApiResponse<Map<String, dynamic>> api = await apiClient.postJson(
      '/api/v1/auth/verify-otp',
      body: {
        'phone': phone,
        'otp': otp,
      },
    );

    final data = api.data;
    if (data == null) {
      // When backend returns success=false, ApiClient throws ApiException already.
      // This only covers unexpected success=true with empty data.
      throw Exception('OTP verification failed');
    }
    return data;
  }

  Future<Map<String, dynamic>> verifyEmailOtp(String email, String otp) async {
    final ApiResponse<Map<String, dynamic>> api = await apiClient.postJson(
      '/api/v1/auth/verify-otp',
      body: {
        'email': email,
        'otp': otp,
      },
    );

    final data = api.data;
    if (data == null) {
      throw Exception('OTP verification failed');
    }
    return data;
  }

  Future<Map<String, dynamic>> completeProfile({
    required String fullName,
    required String address,
    String? email,
  }) async {
    final ApiResponse<Map<String, dynamic>> api = await apiClient.postJson(
      '/api/v1/users/me/complete-profile',
      body: {
        'fullName': fullName,
        'address': address,
        if (email != null) 'email': email,
      },
      requiresAuth: true,
    );

    return api.data ?? <String, dynamic>{};
  }
}



