import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:template_vgv_app/core/firebase/crashlytics_talker_observer.dart';

part 'talker_provider.g.dart';

@Riverpod(keepAlive: true)
Talker talker(TalkerRef ref) => TalkerFlutter.init(
  observer: const CrashlyticsTalkerObserver(),
);
