import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_failure.dart';

import '../../domain/translate_pdf_repository.dart';
import 'translate_pdf_state.dart';

class TranslatePdfCubit extends Cubit<TranslatePdfState> {
  TranslatePdfCubit(this._repository) : super(const TranslatePdfState());

  final TranslatePdfRepository _repository;

  static const supportedLanguages = {
    'en': 'English',
    'bn': 'Bangla',
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
        emit(state.copyWith(
          status: TranslateStatus.error,
          failure: const FileFailure('Could not access the selected file.'),
        ));
        return;
      }

      emit(state.copyWith(
        selectedFile: file,
        status: TranslateStatus.idle,
        clearFailure: true,
        clearSavedPath: true,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: TranslateStatus.error,
        failure: const FileFailure('Failed to pick a PDF file.'),
      ));
    }
  }

  void clearFile() {
    emit(state.copyWith(
      clearFile: true,
      clearSavedPath: true,
      clearFailure: true,
    ));
  }

  void setSourceLanguage(String code) {
    emit(state.copyWith(sourceLanguage: code, clearFailure: true));
  }

  void setTargetLanguage(String code) {
    emit(state.copyWith(targetLanguage: code, clearFailure: true));
  }

  Future<void> submit() async {
    if (!state.canSubmit || state.isProcessing) return;

    final path = state.selectedFile?.path;
    if (path == null) {
      emit(state.copyWith(
        status: TranslateStatus.error,
        failure: const ValidationFailure('Please select a PDF file.'),
      ));
      return;
    }

    if (state.sourceLanguage == state.targetLanguage) {
      emit(state.copyWith(
        status: TranslateStatus.error,
        failure: const ValidationFailure(
          'Source and target languages must be different.',
        ),
      ));
      return;
    }

    emit(state.copyWith(
      status: TranslateStatus.processing,
      clearFailure: true,
      clearSavedPath: true,
    ));

    try {
      final savedPath = await _repository.translateAndSave(
        filePath: path,
        sourceLanguage: state.sourceLanguage,
        targetLanguage: state.targetLanguage,
      );
      emit(state.copyWith(
        status: TranslateStatus.success,
        savedPath: savedPath,
      ));
    } on AppFailure catch (f) {
      emit(state.copyWith(status: TranslateStatus.error, failure: f));
    } catch (_) {
      emit(state.copyWith(
        status: TranslateStatus.error,
        failure: const UnexpectedFailure(),
      ));
    }
  }

  void reset() {
    emit(const TranslatePdfState());
  }

  void retry() {
    emit(state.copyWith(
      status: TranslateStatus.idle,
      clearFailure: true,
      clearSavedPath: true,
    ));
  }
}