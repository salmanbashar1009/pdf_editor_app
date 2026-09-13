import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/errors/app_failure.dart';

enum TranslateStatus { idle, processing, success, error }

class TranslatePdfState extends Equatable {
  const TranslatePdfState({
    this.selectedFile,
    this.sourceLanguage = 'en',
    this.targetLanguage = 'bn',
    this.status = TranslateStatus.idle,
    this.savedPath,
    this.failure,
  });

  final PlatformFile? selectedFile;
  final String sourceLanguage;
  final String targetLanguage;
  final TranslateStatus status;
  final String? savedPath;
  final AppFailure? failure;

  bool get isProcessing => status == TranslateStatus.processing;
  bool get hasFile => selectedFile != null;
  bool get canSubmit =>
      hasFile &&
      sourceLanguage.isNotEmpty &&
      targetLanguage.isNotEmpty &&
      !isProcessing;

  TranslatePdfState copyWith({
    PlatformFile? selectedFile,
    String? sourceLanguage,
    String? targetLanguage,
    TranslateStatus? status,
    String? savedPath,
    AppFailure? failure,
    bool clearFile = false,
    bool clearFailure = false,
    bool clearSavedPath = false,
  }) {
    return TranslatePdfState(
      selectedFile: clearFile ? null : (selectedFile ?? this.selectedFile),
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      status: status ?? this.status,
      savedPath: clearSavedPath ? null : (savedPath ?? this.savedPath),
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [
    selectedFile,
    sourceLanguage,
    targetLanguage,
    status,
    savedPath,
    failure,
  ];
}
