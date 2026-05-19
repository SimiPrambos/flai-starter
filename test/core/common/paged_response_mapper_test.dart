import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/common/paged_response_mapper.dart';

class _Resp with PagedResponseMapper<int> {
  const _Resp({
    required this.page,
    required this.totalPages,
    required this.data,
  });
  @override
  final int page;
  @override
  final int totalPages;
  @override
  final List<int> data;
}

void main() {
  group('PagedResponseMapper.toPaginatedResult', () {
    test('maps items with the provided mapper', () {
      const r = _Resp(page: 1, totalPages: 3, data: [1, 2, 3]);
      final result = r.toPaginatedResult<String>((i) => 'item-$i');
      expect(result.items, ['item-1', 'item-2', 'item-3']);
    });

    test('carries page and totalPages through', () {
      const r = _Resp(page: 2, totalPages: 5, data: []);
      final result = r.toPaginatedResult<String>((i) => '$i');
      expect(result.currentPage, 2);
      expect(result.totalPages, 5);
    });

    test('hasMore is true when currentPage < totalPages', () {
      const r = _Resp(page: 1, totalPages: 2, data: []);
      expect(r.toPaginatedResult<int>((i) => i).hasMore, true);
    });

    test('hasMore is false when currentPage == totalPages', () {
      const r = _Resp(page: 2, totalPages: 2, data: []);
      expect(r.toPaginatedResult<int>((i) => i).hasMore, false);
    });
  });
}
