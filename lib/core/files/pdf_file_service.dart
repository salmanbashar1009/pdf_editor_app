import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../errors/app_failure.dart';

class PdfFileService {
  /// Saves PDF bytes to a temporary location with a descriptive name.
  /// Returns the absolute path of the saved file.
  Future<String> savePdfBytes({
    required Uint8List bytes,
    required String prefix,
  }) async {
    try {
      final dir = await getTemporaryDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filename = '${prefix}_$timestamp.pdf';
      final file = File(p.join(dir.path, filename));
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } catch (_) {
      throw const FileFailure('Failed to save the PDF. Please try again.');
    }
  }

  String displayName(String path) => p.basename(path);
}
