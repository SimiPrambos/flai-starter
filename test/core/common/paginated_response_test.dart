import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/common/paginated_response.dart';

void main() {
  group('PaginatedResponse', () {
    final sampleJson = {
      'page': 1,
      'total_pages': 3,
      'data': [
        {'id': 1},
        {'id': 2},
      ],
    };

    test('parses page and totalPages from json', () {
      final r = PaginatedResponse.fromJson(sampleJson, (j) => j['id'] as int);
      expect(r.page, 1);
      expect(r.totalPages, 3);
    });

    test('maps data items with fromJsonT', () {
      final r = PaginatedResponse.fromJson(sampleJson, (j) => j['id'] as int);
      expect(r.data, [1, 2]);
    });

    test('toPaginatedResult maps items correctly', () {
      final r = PaginatedResponse.fromJson(sampleJson, (j) => j['id'] as int);
      final result = r.toPaginatedResult((id) => 'item-$id');
      expect(result.items, ['item-1', 'item-2']);
      expect(result.currentPage, 1);
      expect(result.totalPages, 3);
    });

    test('hasMore is true when more pages remain', () {
      final r = PaginatedResponse.fromJson(sampleJson, (j) => j['id'] as int);
      expect(r.toPaginatedResult((i) => i).hasMore, true);
    });
  });
}
