class ApiConfig {
  ApiConfig._();

  /// Base URL of the FastAPI backend.
  /// Defaults to localhost for desktop/web; use 10.0.2.2 for Android emulator.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 120);
  static const Duration sendTimeout = Duration(seconds: 60);
}