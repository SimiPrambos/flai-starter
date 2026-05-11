import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/features/users/data/models/user_model.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';

void main() {
  group('UserModel', () {
    const json = {
      'id': 7,
      'email': 'michael.lawson@reqres.in',
      'first_name': 'Michael',
      'last_name': 'Lawson',
      'avatar': 'https://reqres.in/img/faces/7-image.jpg',
    };

    const model = UserModel(
      id: 7,
      email: 'michael.lawson@reqres.in',
      firstName: 'Michael',
      lastName: 'Lawson',
      avatar: 'https://reqres.in/img/faces/7-image.jpg',
    );

    test('deserializes from json', () {
      expect(UserModel.fromJson(json), model);
    });

    test('serializes to json', () {
      expect(model.toJson(), json);
    });

    test('maps to entity', () {
      expect(
        model.toEntity(),
        const UserEntity(
          id: 7,
          email: 'michael.lawson@reqres.in',
          firstName: 'Michael',
          lastName: 'Lawson',
          avatar: 'https://reqres.in/img/faces/7-image.jpg',
        ),
      );
    });
  });
}
