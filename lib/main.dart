import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pdf_editor_app/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const PdfEditorApp());
}
