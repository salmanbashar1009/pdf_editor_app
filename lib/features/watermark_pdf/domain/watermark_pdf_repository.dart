import '../../../core/files/pdf_file_service.dart';
import '../data/watermark_pdf_remote_data_source.dart';

class WatermarkPdfRepository {
  WatermarkPdfRepository(this._remote, this._files);

  final WatermarkPdfRemoteDataSource _remote;
  final PdfFileService _files;

  Future<String> watermarkAndSave({
    required String filePath,
    required String text,
    required String position,
    required double opacity,
    required String color,
  }) async {
    final bytes = await _remote.watermarkPdf(
      filePath: filePath,
      text: text,
      position: position,
      opacity: opacity,
      color: color,
    );

    return _files.savePdfBytes(bytes: bytes, prefix: 'watermarked');
  }
}
