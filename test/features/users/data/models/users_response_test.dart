import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/features/users/data/models/user_model.dart';
import 'package:template_vgv_app/features/users/data/models/user_single_response.dart';
import 'package:template_vgv_app/features/users/data/models/users_list_response.dart';

void main() {
  const userJson = {
    'id': 7,
    'email': 'michael.lawson@reqres.in',
    'first_name': 'Michael',
    'last_name': 'Lawson',
    'avatar': 'https://reqres.in/img/faces/7-image.jpg',
  };

  const listResponseJson = {
    'page': 1,
    'per_page': 6,
    'total': 12,
    'total_pages': 2,
    'data': [userJson],
  };

  const singleResponseJson = {'data': userJson};

  group('UsersListResponse', () {
    test('deserializes from json', () {
      final response = UsersListResponse.fromJson(listResponseJson);

      expect(response.page, 1);
      expect(response.perPage, 6);
      expect(response.total, 12);
      expect(response.totalPages, 2);
      expect(response.data.length, 1);
      expect(response.data.first.id, 7);
      expect(response.data.first.email, 'michael.lawson@reqres.in');
    });

    test('toPaginatedResult maps entities correctly', () {
      final response = UsersListResponse.fromJson(listResponseJson);
      final result = response.toPaginatedResult((m) => m.toEntity());

      expect(result.currentPage, 1);
      expect(result.totalPages, 2);
      expect(result.items.length, 1);
      expect(result.items.first.email, 'michael.lawson@reqres.in');
      expect(result.hasMore, true);
    });
  });

  group('UserSingleResponse', () {
    test('deserializes from json', () {
      final response = UserSingleResponse.fromJson(singleResponseJson);

      expect(response.data, isA<UserModel>());
      expect(response.data.id, 7);
      expect(response.data.email, 'michael.lawson@reqres.in');
    });
  });
}
