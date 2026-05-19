import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/shared/widgets/app_avatar.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('AppAvatar', () {
    testWidgets('renders CachedNetworkImage', (tester) async {
      await tester.pumpApp(
        const AppAvatar(imageUrl: 'https://example.com/pic.jpg', size: 48),
      );
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('renders ClipRRect for circular shape', (tester) async {
      await tester.pumpApp(
        const AppAvatar(imageUrl: 'https://example.com/pic.jpg', size: 48),
      );
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('can be constructed', (_) async {
      const widget = AppAvatar(imageUrl: 'url', size: 48);
      expect(widget, isA<AppAvatar>());
    });
  });
}
