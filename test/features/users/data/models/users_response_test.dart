import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/features/users/data/models/user_model.dart';
import 'package:template_vgv_app/features/users/data/models/users_response.dart';

void main() {
  group('UsersResponse', () {
    const userJson = {
      'id': 7,
      'email': 'michael.lawson@reqres.in',
      'first_name': 'Michael',
      'last_name': 'Lawson',
      'avatar': 'https://reqres.in/img/faces/7-image.jpg',
    };

    const user = UserModel(
      id: 7,
      email: 'michael.lawson@reqres.in',
      firstName: 'Michael',
      lastName: 'Lawson',
      avatar: 'https://reqres.in/img/faces/7-image.jpg',
    );

    const response = UsersResponse(
      page: 1,
      perPage: 6,
      total: 12,
      totalPages: 2,
      data: [user],
    );

    test('deserializes from json', () {
      expect(
        UsersResponse.fromJson(const {
          'page': 1,
          'per_page': 6,
          'total': 12,
          'total_pages': 2,
          'data': [userJson],
        }),
        response,
      );
    });

    test('serializes to json', () {
      expect(
        response.toJson(),
        const {
          'page': 1,
          'per_page': 6,
          'total': 12,
          'total_pages': 2,
          'data': [user],
        },
      );
    });
  });
}
