import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
import 'package:template_vgv_app/core/firebase/crashlytics_talker_observer.dart';
import 'package:template_vgv_app/core/firebase/firebase_bootstrap.dart';
import 'package:template_vgv_app/core/logging/talker_provider.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  final talker = TalkerFlutter.init(
    observer: const CrashlyticsTalkerObserver(),
  );
  final firebase = await initializeFirebase(talker);

  installGlobalErrorHandlers(
    talker: talker,
    crashlyticsEnabled: firebase.crashlyticsEnabled,
  );

  runApp(
    ProviderScope(
      overrides: [
        talkerProvider.overrideWithValue(talker),
      ],
      observers: [
        if (!kReleaseMode) TalkerRiverpodObserver(talker: talker),
      ],
      child: await builder(),
    ),
  );
}
