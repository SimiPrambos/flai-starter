import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/shared/widgets/async_value_widget.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('AsyncValueWidget', () {
    Future<void> pumpAsyncValue<T>(
      WidgetTester tester,
      AsyncValue<T> value, {
      Widget Function(T data)? data,
      Widget? loading,
      Widget Function(Object error, StackTrace? stack)? error,
    }) {
      return tester.pumpApp(
        Scaffold(
          body: AsyncValueWidget<T>(
            value: value,
            loading: loading,
            error: error,
            data: data ?? (value) => Text('$value'),
          ),
        ),
      );
    }

    testWidgets('renders data', (tester) async {
      await pumpAsyncValue(tester, const AsyncValue.data('ready'));

      expect(find.text('ready'), findsOneWidget);
    });

    testWidgets('renders default loading widget', (tester) async {
      await pumpAsyncValue<String>(tester, const AsyncValue.loading());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders custom loading widget', (tester) async {
      await pumpAsyncValue<String>(
        tester,
        const AsyncValue.loading(),
        loading: const Text('Loading users'),
      );

      expect(find.text('Loading users'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('renders default error widget', (tester) async {
      await pumpAsyncValue<String>(
        tester,
        AsyncValue.error(Exception('Boom'), StackTrace.empty),
      );

      expect(find.text('Exception: Boom'), findsOneWidget);
    });

    testWidgets('renders custom error widget', (tester) async {
      await pumpAsyncValue<String>(
        tester,
        AsyncValue.error(Exception('Boom'), StackTrace.empty),
        error: (error, stack) => Text('Custom $error'),
      );

      expect(find.text('Custom Exception: Boom'), findsOneWidget);
    });
  });
}
