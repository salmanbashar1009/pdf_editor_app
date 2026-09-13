import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../../core/widgets/errors_view.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/watermark_pdf_cubit.dart';
import '../bloc/watermark_pdf_state.dart';


class WatermarkPdfScreen extends StatelessWidget {
  const WatermarkPdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatermarkPdfCubit, WatermarkPdfState>(
      builder: (context, state) {
        final cubit = context.read<WatermarkPdfCubit>();
        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(title: const Text('Watermark PDF')),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Source PDF', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                _FilePickerCard(
                  fileName: state.selectedFile?.name,
                  onPick: cubit.pickPdf,
                  onClear: state.hasFile ? cubit.clearFile : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: state.text,
                  decoration: const InputDecoration(
                    labelText: 'Watermark text',
                    hintText: 'CONFIDENTIAL',
                  ),
                  onChanged: cubit.setText,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: state.position,
                  decoration: const InputDecoration(labelText: 'Position'),
                  items: WatermarkPdfCubit.positions.entries
                      .map(
                        (e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    ),
                  )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) cubit.setPosition(v);
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Opacity: ${state.opacity.toStringAsFixed(2)}',
                  style: theme.textTheme.titleSmall,
                ),
                Slider(
                  value: state.opacity,
                  min: 0.0,
                  max: 1.0,
                  divisions: 20,
                  label: state.opacity.toStringAsFixed(2),
                  onChanged: cubit.setOpacity,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: state.color,
                  decoration: const InputDecoration(
                    labelText: 'Color (#RRGGBB)',
                    hintText: '#FF0000',
                    prefixIcon: Icon(Icons.color_lens_outlined),
                  ),
                  onChanged: cubit.setColor,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final c in const [
                      '#FF0000',
                      '#000000',
                      '#1565C0',
                      '#059669',
                      '#D97706',
                      '#7C3AED',
                    ])
                      GestureDetector(
                        onTap: () => cubit.setColor(c),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Color(
                              int.parse(c.substring(1), radix: 16) + 0xFF000000,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: state.color.toUpperCase() == c
                                  ? theme.colorScheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 28),
                if (state.status == WatermarkStatus.error &&
                    state.failure != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ErrorView(
                      message: state.failure!.message,
                      onRetry: cubit.retry,
                    ),
                  ),
                if (state.status == WatermarkStatus.success &&
                    state.savedPath != null) ...[
                  _SuccessCard(
                    path: state.savedPath!,
                    onOpen: () => _openPdf(context, state.savedPath!),
                    onDownload: () => _downloadPdf(context, state.savedPath!),
                    onNew: cubit.reset,
                  ),
                ] else ...[
                  PrimaryButton(
                    label: state.isProcessing
                        ? 'Applying watermark…'
                        : 'Apply Watermark',
                    isLoading: state.isProcessing,
                    icon: Icons.branding_watermark_rounded,
                    onPressed: state.canSubmit ? cubit.submit : null,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _openPdf(BuildContext context, String path) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Preview')),
          body: PdfViewer.file(path),
        ),
      ),
    );
  }

  Future<void> _downloadPdf(BuildContext context, String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File not found.')),
        );
        return;
      }
      final bytes = await file.readAsBytes();
      final fileName = path.split(RegExp(r'[/\\]')).last;

      final result = await FilePicker.saveFile(
        fileName: fileName,
        bytes: bytes,
        mimeType: 'application/pdf',
        dialogTitle: 'Download Watermarked PDF',
      );

      if (!context.mounted) return;
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF downloaded successfully: ${result.path}')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download PDF: $e')),
      );
    }
  }
}

class _FilePickerCard extends StatelessWidget {
  const _FilePickerCard({
    required this.fileName,
    required this.onPick,
    this.onClear,
  });

  final String? fileName;
  final VoidCallback onPick;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasFile = fileName != null;

    return Card(
      child: InkWell(
        onTap: onPick,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                hasFile
                    ? Icons.picture_as_pdf_rounded
                    : Icons.upload_file_rounded,
                color: theme.colorScheme.primary,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasFile ? fileName! : 'Select a PDF file',
                      style: theme.textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      hasFile ? 'Tap to change' : 'PDF only',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (hasFile && onClear != null)
                IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.close),
                  tooltip: 'Clear',
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard({
    required this.path,
    required this.onOpen,
    required this.onDownload,
    required this.onNew,
  });

  final String path;
  final VoidCallback onOpen;
  final VoidCallback onDownload;
  final VoidCallback onNew;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle_rounded,
                    color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('Watermark applied', style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              path.split(RegExp(r'[/\\]')).last,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Open / Preview',
              icon: Icons.visibility_rounded,
              onPressed: onOpen,
            ),
            const SizedBox(height: 8),
            PrimaryButton(
              label: 'Download PDF',
              icon: Icons.download_rounded,
              onPressed: onDownload,
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: onNew,
              child: const Text('Watermark another'),
            ),
          ],
        ),
      ),
    );
  }
}
