import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/shared/widgets/error_retry_widget.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('ErrorRetryWidget', () {
    testWidgets('shows the error message', (tester) async {
      await tester.pumpApp(
        ErrorRetryWidget(message: 'No internet', onRetry: () {}),
      );
      expect(find.text('No internet'), findsOneWidget);
    });

    testWidgets('shows Retry button', (tester) async {
      await tester.pumpApp(
        ErrorRetryWidget(message: 'Error', onRetry: () {}),
      );
      // l10n errorRetry key resolves to 'Retry' in en locale
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('calls onRetry when button is tapped', (tester) async {
      var called = false;
      await tester.pumpApp(
        ErrorRetryWidget(message: 'Error', onRetry: () => called = true),
      );
      await tester.tap(find.text('Retry'));
      expect(called, true);
    });
  });
}
