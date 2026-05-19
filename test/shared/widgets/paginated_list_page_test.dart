import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/shared/widgets/paginated_list_page.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('PaginatedListPage', () {
    testWidgets('shows skeleton items when loading', (tester) async {
      await tester.pumpApp(
        PaginatedListPage<String>(
          title: 'Test',
          value: const AsyncLoading(),
          itemBuilder: Text.new,
          skeletonItem: const Text('__skeleton__'),
          onRefresh: () async {},
          onLoadMore: () async {},
          hasMore: false,
          skeletonCount: 3,
        ),
      );
      expect(find.text('__skeleton__'), findsNWidgets(3));
    });

    testWidgets('shows items when data arrives', (tester) async {
      await tester.pumpApp(
        PaginatedListPage<String>(
          title: 'Test',
          value: const AsyncData(['hello', 'world']),
          itemBuilder: Text.new,
          skeletonItem: const Text('__skeleton__'),
          onRefresh: () async {},
          onLoadMore: () async {},
          hasMore: false,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('hello'), findsOneWidget);
      expect(find.text('world'), findsOneWidget);
    });

    testWidgets('shows error message and Retry button on error', (
      tester,
    ) async {
      await tester.pumpApp(
        PaginatedListPage<String>(
          title: 'Test',
          value: const AsyncError('No internet', StackTrace.empty),
          itemBuilder: Text.new,
          skeletonItem: const Text('__skeleton__'),
          onRefresh: () async {},
          onLoadMore: () async {},
          hasMore: false,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No internet'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows Load More button when hasMore is true', (tester) async {
      await tester.pumpApp(
        PaginatedListPage<String>(
          title: 'Test',
          value: const AsyncData(['item']),
          itemBuilder: Text.new,
          skeletonItem: const Text('__skeleton__'),
          onRefresh: () async {},
          onLoadMore: () async {},
          hasMore: true,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Load More'), findsOneWidget);
    });

    testWidgets('calls onLoadMore when Load More is tapped', (tester) async {
      var called = false;
      await tester.pumpApp(
        PaginatedListPage<String>(
          title: 'Test',
          value: const AsyncData(['item']),
          itemBuilder: Text.new,
          skeletonItem: const Text('__skeleton__'),
          onRefresh: () async {},
          onLoadMore: () async => called = true,
          hasMore: true,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Load More'));
      expect(called, true);
    });

    testWidgets('shows AppBar with given title', (tester) async {
      await tester.pumpApp(
        PaginatedListPage<String>(
          title: 'My Feature',
          value: const AsyncData([]),
          itemBuilder: Text.new,
          skeletonItem: const Text('__skeleton__'),
          onRefresh: () async {},
          onLoadMore: () async {},
          hasMore: false,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('My Feature'), findsOneWidget);
    });
  });
}
