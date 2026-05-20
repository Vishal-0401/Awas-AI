class AppConstants {
  // Networking
  static const String apiBaseUrl = 'http://localhost:3000/api'; // Replace with production URL
  static const String socketUrl = 'http://localhost:3000'; // Replace with production URL
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_preference';
  
  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
}
