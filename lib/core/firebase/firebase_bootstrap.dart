import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:template_vgv_app/firebase_options.dart';

class FirebaseBootstrapResult {
  const FirebaseBootstrapResult({
    required this.firebaseEnabled,
    required this.crashlyticsEnabled,
    this.error,
  });

  final bool firebaseEnabled;
  final bool crashlyticsEnabled;
  final Object? error;
}

Future<FirebaseBootstrapResult> initializeFirebase(Talker talker) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    final crashlyticsEnabled = _isCrashlyticsSupported;
    if (crashlyticsEnabled) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        kReleaseMode,
      );
    } else {
      talker.info('Firebase Crashlytics is not supported on this platform');
    }

    talker.info('Firebase initialized');
    return FirebaseBootstrapResult(
      firebaseEnabled: true,
      crashlyticsEnabled: crashlyticsEnabled,
    );
  } on Object catch (error, stackTrace) {
    talker
      ..warning(
        'Firebase is not configured yet. Run `flutterfire configure` in the '
        'project that consumes this starter to replace '
        '`lib/firebase_options.dart` and enable Analytics and Crashlytics.',
      )
      ..handle(error, stackTrace, 'Firebase initialization skipped');

    return FirebaseBootstrapResult(
      firebaseEnabled: false,
      crashlyticsEnabled: false,
      error: error,
    );
  }
}

void installGlobalErrorHandlers({
  required Talker talker,
  required bool crashlyticsEnabled,
}) {
  FlutterError.onError = (details) {
    talker.handle(
      details.exception,
      details.stack,
      'Uncaught Flutter framework error',
    );

    if (crashlyticsEnabled) {
      unawaited(_recordFlutterFatalError(details));
    }
  };

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    talker.handle(error, stackTrace, 'Uncaught platform error');

    if (crashlyticsEnabled) {
      unawaited(_recordFatalError(error, stackTrace));
    }

    return true;
  };
}

bool get _isCrashlyticsSupported {
  if (kIsWeb) return false;

  return switch (defaultTargetPlatform) {
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.macOS => true,
    _ => false,
  };
}

Future<void> _recordFlutterFatalError(FlutterErrorDetails details) async {
  try {
    await FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  } on Object catch (_) {}
}

Future<void> _recordFatalError(Object error, StackTrace stackTrace) async {
  try {
    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      fatal: true,
    );
  } on Object catch (_) {}
}
