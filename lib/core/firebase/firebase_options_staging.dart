// Placeholder Firebase options for the `staging` flavor.
//
// Regenerate with the FlutterFire CLI (see README "Firebase"):
//
//   flutterfire configure \
//     --project=<firebase-project-id> \
//     --out=lib/core/firebase/firebase_options_staging.dart \
//     --android-out=android/app/src/staging/google-services.json \
//     --ios-out=ios/config/staging/GoogleService-Info.plist
//
// Until then `currentPlatform` throws. `initializeFirebase` catches it, logs a
// Talker warning and the app runs with Firebase disabled.
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'Firebase is not configured for the staging flavor. Run '
      '`flutterfire configure` to generate '
      'lib/core/firebase/firebase_options_staging.dart.',
    );
  }
}
