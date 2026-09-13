import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor_app/app/theme/app_theme.dart';
import 'package:pdf_editor_app/core/files/pdf_file_service.dart';
import 'package:pdf_editor_app/core/network/dio_client.dart';
import 'package:pdf_editor_app/features/translate_pdf/data/translate_pdf_remote_data_source.dart';
import 'package:pdf_editor_app/features/translate_pdf/domain/translate_pdf_repository.dart';
import 'package:pdf_editor_app/features/translate_pdf/presentation/bloc/translate_pdf_cubit.dart';
import 'package:pdf_editor_app/features/translate_pdf/presentation/screen/translate_pdf_screen.dart';
import 'package:pdf_editor_app/features/watermark_pdf/presentation/screen/watermark_pdf_screen.dart';

import '../features/home/home_screen.dart';
import '../features/watermark_pdf/data/watermark_pdf_remote_data_source.dart';
import '../features/watermark_pdf/domain/watermark_pdf_repository.dart';
import '../features/watermark_pdf/presentation/bloc/watermark_pdf_cubit.dart';

class PdfEditorApp extends StatelessWidget {
  const PdfEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = createDio();
    final pdfFileService = PdfFileService();

    final translateRepository = TranslatePdfRepository(
      TranslatePdfRemoteDataSource(dio),
      pdfFileService,
    );
    final watermarkRepository = WatermarkPdfRepository(
      WatermarkPdfRemoteDataSource(dio),
      pdfFileService,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Dio>.value(value: dio),
        RepositoryProvider<PdfFileService>.value(value: pdfFileService),
        RepositoryProvider<TranslatePdfRepository>.value(
          value: translateRepository,
        ),
        RepositoryProvider<WatermarkPdfRepository>.value(
          value: watermarkRepository,
        ),
      ],
      child: MaterialApp(
        title: 'PDF Editor App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: '/',
        routes: {
          '/': (_) => const HomeScreen(),
          '/translate': (context) => BlocProvider(
            create: (_) =>
                TranslatePdfCubit(context.read<TranslatePdfRepository>()),
            child: const TranslatePdfScreen(),
          ),
          '/watermark': (context) => BlocProvider(
            create: (_) =>
                WatermarkPdfCubit(context.read<WatermarkPdfRepository>()),
            child: const WatermarkPdfScreen(),
          ),
        },
      ),
    );
  }
}
