import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/shared/widgets/async_detail_scaffold.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('AsyncDetailScaffold', () {
    testWidgets('shows skeleton when loading', (tester) async {
      await tester.pumpApp(
        const AsyncDetailScaffold<String>(
          title: 'Test',
          value: AsyncLoading(),
          skeleton: Text('__loading__'),
          builder: Text.new,
        ),
      );
      expect(find.text('__loading__'), findsOneWidget);
    });

    testWidgets('shows content when data', (tester) async {
      await tester.pumpApp(
        const AsyncDetailScaffold<String>(
          title: 'Test',
          value: AsyncData('hello'),
          builder: Text.new,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('shows AppBar with title', (tester) async {
      await tester.pumpApp(
        const AsyncDetailScaffold<String>(
          title: 'Detail Page',
          value: AsyncData('content'),
          builder: Text.new,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Detail Page'), findsOneWidget);
    });

    testWidgets('shows default CircularProgressIndicator when no skeleton', (
      tester,
    ) async {
      await tester.pumpApp(
        const AsyncDetailScaffold<String>(
          title: 'Test',
          value: AsyncLoading(),
          builder: Text.new,
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
