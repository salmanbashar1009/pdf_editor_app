import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/errors/app_failure.dart';

enum WatermarkStatus { idle, processing, success, error }

class WatermarkPdfState extends Equatable {
  const WatermarkPdfState({
    this.selectedFile,
    this.text = 'CONFIDENTIAL',
    this.position = 'center',
    this.opacity = 0.3,
    this.color = '#FF0000',
    this.status = WatermarkStatus.idle,
    this.savedPath,
    this.failure,
  });

  final PlatformFile? selectedFile;
  final String text;
  final String position;
  final double opacity;
  final String color;
  final WatermarkStatus status;
  final String? savedPath;
  final AppFailure? failure;

  bool get isProcessing => status == WatermarkStatus.processing;
  bool get hasFile => selectedFile != null;

  bool get canSubmit =>
      hasFile &&
      text.trim().isNotEmpty &&
      _isValidColor(color) &&
      opacity >= 0.0 &&
      opacity <= 1.0 &&
      !isProcessing;

  static bool _isValidColor(String value) {
    final hex = value.startsWith('#') ? value.substring(1) : value;
    return RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(hex);
  }

  WatermarkPdfState copyWith({
    PlatformFile? selectedFile,
    String? text,
    String? position,
    double? opacity,
    String? color,
    WatermarkStatus? status,
    String? savedPath,
    AppFailure? failure,
    bool clearFile = false,
    bool clearFailure = false,
    bool clearSavedPath = false,
  }) {
    return WatermarkPdfState(
      selectedFile: clearFile ? null : (selectedFile ?? this.selectedFile),
      text: text ?? this.text,
      position: position ?? this.position,
      opacity: opacity ?? this.opacity,
      color: color ?? this.color,
      status: status ?? this.status,
      savedPath: clearSavedPath ? null : (savedPath ?? this.savedPath),
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [
    selectedFile,
    text,
    position,
    opacity,
    color,
    status,
    savedPath,
    failure,
  ];
}
