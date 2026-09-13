import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_editor_app/app/app.dart';

void main() {
  testWidgets('App boots and shows home title', (tester) async {
    await tester.pumpWidget(const PdfEditorApp());
    expect(find.text('PDF Editor'), findsOneWidget);
    expect(find.text('Translate PDF'), findsOneWidget);
    expect(find.text('Watermark PDF'), findsOneWidget);
  });
}
