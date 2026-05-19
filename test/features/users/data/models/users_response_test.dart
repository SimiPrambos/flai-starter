import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/common/paginated_response.dart';
import 'package:template_vgv_app/features/users/data/models/user_model.dart';

void main() {
  group('PaginatedResponse<UserModel>', () {
    const userJson = {
      'id': 7,
      'email': 'michael.lawson@reqres.in',
      'first_name': 'Michael',
      'last_name': 'Lawson',
      'avatar': 'https://reqres.in/img/faces/7-image.jpg',
    };

    const responseJson = {
      'page': 1,
      'total_pages': 2,
      'data': [userJson],
    };

    test('deserializes from json', () {
      final response = PaginatedResponse.fromJson(
        responseJson,
        UserModel.fromJson,
      );

      expect(response.page, 1);
      expect(response.totalPages, 2);
      expect(response.data.length, 1);
      expect(response.data.first.id, 7);
      expect(response.data.first.email, 'michael.lawson@reqres.in');
    });

    test('toPaginatedResult maps entities correctly', () {
      final response = PaginatedResponse.fromJson(
        responseJson,
        UserModel.fromJson,
      );
      final result = response.toPaginatedResult((m) => m.toEntity());

      expect(result.currentPage, 1);
      expect(result.totalPages, 2);
      expect(result.items.length, 1);
      expect(result.items.first.email, 'michael.lawson@reqres.in');
      expect(result.hasMore, true);
    });
  });
}
