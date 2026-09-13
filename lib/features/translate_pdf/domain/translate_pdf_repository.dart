import '../../../core/files/pdf_file_service.dart';
import '../data/translate_pdf_remote_data_source.dart';

class TranslatePdfRepository {
  TranslatePdfRepository(this._remote, this._files);

  final TranslatePdfRemoteDataSource _remote;
  final PdfFileService _files;

  /// Translates the PDF and saves the result. Returns the local path of the saved file.
  Future<String> translateAndSave({
    required String filePath,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final bytes = await _remote.translatePdf(
      filePath: filePath,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );

    final prefix = 'translated_${sourceLanguage}_to_$targetLanguage';
    return _files.savePdfBytes(bytes: bytes, prefix: prefix);
  }
}