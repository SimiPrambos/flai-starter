import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/common/single_response.dart';

void main() {
  group('SingleResponse', () {
    test('parses data from json', () {
      final result = SingleResponse.fromJson(
        {
          'data': {'id': 1, 'name': 'Alice'},
        },
        (json) => {'id': json['id'], 'name': json['name']},
      );
      expect(result.data['id'], 1);
      expect(result.data['name'], 'Alice');
    });

    test('holds data in data field', () {
      const response = SingleResponse(data: 42);
      expect(response.data, 42);
    });
  });
}
