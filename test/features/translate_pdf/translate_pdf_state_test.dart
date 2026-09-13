import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_editor_app/features/translate_pdf/presentation/bloc/translate_pdf_state.dart';

void main() {
  group('TranslatePdfState', () {
    test('initial state is idle and cannot submit', () {
      const state = TranslatePdfState();
      expect(state.status, TranslateStatus.idle);
      expect(state.canSubmit, isFalse);
      expect(state.isProcessing, isFalse);
    });

    test('copyWith updates languages', () {
      const state = TranslatePdfState();
      final next = state.copyWith(sourceLanguage: 'bn', targetLanguage: 'en');
      expect(next.sourceLanguage, 'bn');
      expect(next.targetLanguage, 'en');
    });

    test('processing status disables submit', () {
      const state = TranslatePdfState(status: TranslateStatus.processing);
      expect(state.isProcessing, isTrue);
      expect(state.canSubmit, isFalse);
    });
  });
}
