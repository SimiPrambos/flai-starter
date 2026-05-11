import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_card.dart';

void main() {
  group('UserCard', () {
    const user = UserEntity(
      id: 7,
      email: 'michael.lawson@reqres.in',
      firstName: 'Michael',
      lastName: 'Lawson',
      avatar: 'https://reqres.in/img/faces/7-image.jpg',
    );

    testWidgets('renders user details', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UserCard(user: user)),
        ),
      );

      expect(find.text('Michael Lawson'), findsOneWidget);
      expect(find.text('michael.lawson@reqres.in'), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('builds avatar error widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UserCard(user: user)),
        ),
      );

      final image = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      final context = tester.element(find.byType(CachedNetworkImage));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: image.errorWidget!(
              context,
              user.avatar,
              Exception('failed'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });
}
