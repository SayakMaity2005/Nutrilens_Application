import 'package:flutter/foundation.dart';

class ApiConfig {
  // Toggle between Development and Production here.
  
  // --- Production Configuration ---
  static const String baseUrl = "https://nutrilens-application.onrender.com";

  // --- Localhost Configuration (Uncomment to test locally) ---
  /*
  static String get baseUrl {
    if (kIsWeb) {
      return "http://127.0.0.1:8000"; // For Chrome/Web testing
    } else {
      return "http://10.0.2.2:8000"; // For Android Emulator
    }
  }
  */
}
