import 'package:dio/dio.dart';

import '../config/api_config.dart';
import '../errors/app_failure.dart';

/// Creates the shared Dio instance for the app.
Dio createDio() {
  return Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      responseType: ResponseType.bytes,
      validateStatus: (status) => status != null && status < 500,
    ),
  );
}

/// Maps Dio / HTTP errors into [AppFailure].
AppFailure mapDioException(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const TimeoutFailure();
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        if (status == 400 || status == 422) {
          return const ValidationFailure(
            'Invalid request. Please check the file and inputs.',
          );
        }
        if (status == 413) {
          return const ValidationFailure(
            'The selected PDF is too large. Please choose a smaller file.',
          );
        }
        return const ServerFailure();
      case DioExceptionType.cancel:
        return const UnexpectedFailure('Request was cancelled.');
      case DioExceptionType.badCertificate:
        return const NetworkFailure('Secure connection failed.');
    }
  }
  return const UnexpectedFailure();
}
