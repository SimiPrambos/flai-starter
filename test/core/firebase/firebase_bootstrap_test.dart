import 'package:flutter_test/flutter_test.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:template_vgv_app/core/firebase/firebase_bootstrap.dart';

void main() {
  group('initializeFirebase', () {
    test('returns a disabled result when options cannot be resolved', () async {
      final talker = Talker();

      final result = await initializeFirebase(
        talker,
        options: () => throw UnsupportedError('Firebase is not configured'),
      );

      expect(result.firebaseEnabled, isFalse);
      expect(result.crashlyticsEnabled, isFalse);
      expect(result.error, isA<UnsupportedError>());
      expect(
        talker.history.map((data) => data.message),
        contains(contains('Firebase initialization failed')),
      );
    });
  });
}
