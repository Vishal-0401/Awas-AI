class AppConstants {
  // Networking
  static const String apiOrigin = 'https://awas-ai.onrender.com';
  static const String apiBaseUrl = '$apiOrigin/api';
  static const String apiV1BaseUrl = '$apiOrigin/api/v1';
  static const String socketUrl = apiOrigin;
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_preference';
  
  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
}
