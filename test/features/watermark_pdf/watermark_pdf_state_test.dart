import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_editor_app/features/watermark_pdf/presentation/bloc/watermark_pdf_state.dart';

void main() {
  group('WatermarkPdfState', () {
    test('initial state is idle and cannot submit without file', () {
      const state = WatermarkPdfState();
      expect(state.status, WatermarkStatus.idle);
      expect(state.canSubmit, isFalse);
      expect(state.isProcessing, isFalse);
      expect(state.text, 'CONFIDENTIAL');
    });

    test('copyWith updates text and opacity', () {
      const state = WatermarkPdfState();
      final next = state.copyWith(text: 'SECRET', opacity: 0.5);
      expect(next.text, 'SECRET');
      expect(next.opacity, 0.5);
    });

    test('processing status disables submit', () {
      const state = WatermarkPdfState(status: WatermarkStatus.processing);
      expect(state.isProcessing, isTrue);
      expect(state.canSubmit, isFalse);
    });
  });
}
