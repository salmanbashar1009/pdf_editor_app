import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_failure.dart';

import '../../domain/watermark_pdf_repository.dart';
import 'watermark_pdf_state.dart';

class WatermarkPdfCubit extends Cubit<WatermarkPdfState> {
  WatermarkPdfCubit(this._repository) : super(const WatermarkPdfState());

  final WatermarkPdfRepository _repository;

  /// Exact position values required by the API contract.
  static const positions = <String, String>{
    'top-left': 'Top Left',
    'top-center': 'Top Center',
    'top-right': 'Top Right',
    'center': 'Center',
    'bottom-left': 'Bottom Left',
    'bottom-center': 'Bottom Center',
    'bottom-right': 'Bottom Right',
  };

  Future<void> pickPdf() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
      );
      if (result.isEmpty) return;

      final file = result.single;
      if (file.path == null) {
        emit(
          state.copyWith(
            status: WatermarkStatus.error,
            failure: const FileFailure('Could not access the selected file.'),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          selectedFile: file,
          status: WatermarkStatus.idle,
          clearFailure: true,
          clearSavedPath: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: WatermarkStatus.error,
          failure: const FileFailure('Failed to pick a PDF file.'),
        ),
      );
    }
  }

  void clearFile() {
    emit(
      state.copyWith(clearFile: true, clearSavedPath: true, clearFailure: true),
    );
  }

  void setText(String value) {
    emit(state.copyWith(text: value, clearFailure: true));
  }

  void setPosition(String value) {
    emit(state.copyWith(position: value, clearFailure: true));
  }

  void setOpacity(double value) {
    emit(state.copyWith(opacity: value.clamp(0.0, 1.0), clearFailure: true));
  }

  void setColor(String value) {
    var normalized = value.trim();
    if (!normalized.startsWith('#') && normalized.length == 6) {
      normalized = '#$normalized';
    }
    emit(state.copyWith(color: normalized.toUpperCase(), clearFailure: true));
  }

  Future<void> submit() async {
    if (!state.canSubmit || state.isProcessing) return;

    final path = state.selectedFile?.path;
    if (path == null) {
      emit(
        state.copyWith(
          status: WatermarkStatus.error,
          failure: const ValidationFailure('Please select a PDF file.'),
        ),
      );
      return;
    }

    if (state.text.trim().isEmpty) {
      emit(
        state.copyWith(
          status: WatermarkStatus.error,
          failure: const ValidationFailure('Watermark text is required.'),
        ),
      );
      return;
    }

    final color = state.color.startsWith('#') ? state.color : '#${state.color}';
    if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(color)) {
      emit(
        state.copyWith(
          status: WatermarkStatus.error,
          failure: const ValidationFailure(
            'Color must be a valid #RRGGBB value.',
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: WatermarkStatus.processing,
        clearFailure: true,
        clearSavedPath: true,
      ),
    );

    try {
      final savedPath = await _repository.watermarkAndSave(
        filePath: path,
        text: state.text.trim(),
        position: state.position,
        opacity: state.opacity,
        color: color,
      );
      emit(
        state.copyWith(status: WatermarkStatus.success, savedPath: savedPath),
      );
    } on AppFailure catch (f) {
      emit(state.copyWith(status: WatermarkStatus.error, failure: f));
    } catch (_) {
      emit(
        state.copyWith(
          status: WatermarkStatus.error,
          failure: const UnexpectedFailure(),
        ),
      );
    }
  }

  void reset() {
    emit(const WatermarkPdfState());
  }

  void retry() {
    emit(
      state.copyWith(
        status: WatermarkStatus.idle,
        clearFailure: true,
        clearSavedPath: true,
      ),
    );
  }
}
