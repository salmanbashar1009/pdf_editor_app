import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/errors/app_failure.dart';

class TranslatePdfRemoteDataSource {
  TranslatePdfRemoteDataSource(this._dio);

  final Dio _dio;

  /// Calls GET /health to verify backend connectivity.
  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get<dynamic>('/health');
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Calls POST /api/translate-pdf and returns the PDF bytes.
  Future<Uint8List> translatePdf({
    required String filePath,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split(RegExp(r'[/\\]')).last,
        ),
        'source_language': sourceLanguage,
        'target_language': targetLanguage,
        'source_lang': sourceLanguage,
        'target_lang': targetLanguage,
        'source': sourceLanguage,
        'target': targetLanguage,
      });

      final response = await _dio.post<List<int>>(
        '/api/translate-pdf',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return Uint8List.fromList(response.data!);
      }

      throw mapDioException(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ),
      );
    } on AppFailure {
      rethrow;
    } catch (e) {
      throw mapDioException(e);
    }
  }
}
