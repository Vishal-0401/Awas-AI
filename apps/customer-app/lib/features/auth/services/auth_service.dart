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
      '/auth/google',
      body: {'idToken': idToken},
    );

    return api.data;
  }

  Future<void> sendOtp(String phone) async {
    await apiClient.postJson(
      '/auth/send-otp',
      body: {'phone': phone},
      dataParser: (json) => json as Map<String, dynamic>,
    );
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final ApiResponse<Map<String, dynamic>> api = await apiClient.postJson(
      '/auth/verify-otp',
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
}



