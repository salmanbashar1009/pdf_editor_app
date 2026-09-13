import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  ApiConfig._();

  /// Base URL of the FastAPI backend.
  /// Defaults to localhost for desktop/web; use 10.0.2.2 for Android emulator.
  static String get baseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) return envUrl;

    if (!kIsWeb) {
      try {
        if (Platform.isAndroid) {
          return "http://127.0.0.1:8000";
        }
      } catch (_) {}
    }
    return 'http://localhost:8000';
  }

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 120);
  static const Duration sendTimeout = Duration(seconds: 60);
}
