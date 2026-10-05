// Placeholder Firebase options for the `development` flavor.
//
// Regenerate with the FlutterFire CLI (see README "Firebase"):
//
//   flutterfire configure \
//     --project=<firebase-project-id> \
//     --out=lib/core/firebase/firebase_options_development.dart \
//     --android-out=android/app/src/development/google-services.json \
//     --ios-out=ios/config/development/GoogleService-Info.plist
//
// Until then `currentPlatform` throws. `initializeFirebase` catches it, logs a
// Talker warning and the app runs with Firebase disabled.
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'Firebase is not configured for the development flavor. Run '
      '`flutterfire configure` to generate '
      'lib/core/firebase/firebase_options_development.dart.',
    );
  }
}
