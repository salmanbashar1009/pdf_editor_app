import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../../core/widgets/errors_view.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/translate_pdf_cubit.dart';
import '../bloc/translate_pdf_state.dart';


class TranslatePdfScreen extends StatelessWidget {
  const TranslatePdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranslatePdfCubit, TranslatePdfState>(
      builder: (context, state) {
        final cubit = context.read<TranslatePdfCubit>();
        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(title: const Text('Translate PDF')),
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
                const SizedBox(height: 24),
                Text('Languages', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _LanguageDropdown(
                        label: 'From',
                        value: state.sourceLanguage,
                        onChanged: cubit.setSourceLanguage,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LanguageDropdown(
                        label: 'To',
                        value: state.targetLanguage,
                        onChanged: cubit.setTargetLanguage,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                if (state.status == TranslateStatus.error &&
                    state.failure != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ErrorView(
                      message: state.failure!.message,
                      onRetry: cubit.retry,
                    ),
                  ),
                if (state.status == TranslateStatus.success &&
                    state.savedPath != null) ...[
                  _SuccessCard(
                    path: state.savedPath!,
                    onOpen: () => _openPdf(context, state.savedPath!),
                    onNew: cubit.reset,
                  ),
                ] else ...[
                  PrimaryButton(
                    label:
                    state.isProcessing ? 'Translating…' : 'Translate PDF',
                    isLoading: state.isProcessing,
                    icon: Icons.translate_rounded,
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

class _LanguageDropdown extends StatelessWidget {
  const _LanguageDropdown({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: TranslatePdfCubit.supportedLanguages.entries
          .map(
            (e) => DropdownMenuItem(
          value: e.key,
          child: Text(e.value),
        ),
      )
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard({
    required this.path,
    required this.onOpen,
    required this.onNew,
  });

  final String path;
  final VoidCallback onOpen;
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
                Text('Translation complete',
                    style: theme.textTheme.titleMedium),
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
            OutlinedButton(
              onPressed: onNew,
              child: const Text('Translate another'),
            ),
          ],
        ),
      ),
    );
  }
}