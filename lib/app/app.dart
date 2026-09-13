import 'package:flutter/material.dart';
import 'package:pdf_editor_app/features/translate_pdf/presentation/screen/translate_pdf_screen.dart';
import 'package:pdf_editor_app/features/watermark_pdf/presentation/screen/watermark_pdf_screen.dart';

import '../features/home/home_screen.dart';

class PdfEditorApp extends StatelessWidget {
  const PdfEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Editor App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/':(_) => const HomeScreen(),
        '/translate':(_) => const TranslatePdfScreen(),
        '/watermark':(_) => const WatermarkPdfScreen(),
      },
    );
  }
}
