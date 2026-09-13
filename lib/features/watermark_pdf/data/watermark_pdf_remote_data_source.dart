import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/errors/app_failure.dart';

class WatermarkPdfRemoteDataSource {
  WatermarkPdfRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Uint8List> watermarkPdf({
    required String filePath,
    required String text,
    required String position,
    required double opacity,
    required String color,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split(RegExp(r'[/\\]')).last,
        ),
        'text': text,
        'position': position,
        'opacity': opacity,
        'color': color,
      });

      final response = await _dio.post<List<int>>(
        '/editor/pdf/watermark',
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
