class AppConstants {
  static const String appName = 'SustainU';
  static const String apiUrl = 'https://api.sustainu.com/';
  static const Duration splashDelay = Duration(seconds: 3);
  
  // Texts for the UI
  static const String signInText = 'Sign In';
  static const String signUpText = 'Sign Up';
  static const String phoneNumberLabel = 'Phone number';
  static const String zipCodeLabel = 'Zip code';
  static const String complementLabel = 'Complement';
  static const String acceptNotifications = 'Accept getting notifications from the app';
  
  // Error messages
  static const String networkError = 'Network error. Please try again later.';
  
  // API Endpoints
  static const String loginEndpoint = 'auth/login';
  static const String signUpEndpoint = 'auth/signup';
}
