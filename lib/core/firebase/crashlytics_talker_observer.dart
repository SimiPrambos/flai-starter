import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:talker/talker.dart';

class CrashlyticsTalkerObserver extends TalkerObserver {
  const CrashlyticsTalkerObserver();

  @override
  void onError(TalkerError err) {
    _writeBreadcrumb(err);
    _recordNonFatal(
      err.error ?? err.message ?? err,
      err.stackTrace,
      err.message,
    );
  }

  @override
  void onException(TalkerException err) {
    _writeBreadcrumb(err);
    _recordNonFatal(
      err.exception ?? err.message ?? err,
      err.stackTrace,
      err.message,
    );
  }

  @override
  void onLog(TalkerData log) {
    _writeBreadcrumb(log);
  }

  bool get _isCrashlyticsReady {
    if (!_isCrashlyticsSupported) return false;

    try {
      return Firebase.apps.isNotEmpty;
    } on Object catch (_) {
      return false;
    }
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

  void _writeBreadcrumb(TalkerData data) {
    if (!_isCrashlyticsReady) return;

    unawaited(
      FirebaseCrashlytics.instance.log(_shortMessage(data)).catchError((_) {}),
    );
  }

  void _recordNonFatal(
    Object error,
    StackTrace? stackTrace,
    String? reason,
  ) {
    if (!_isCrashlyticsReady) return;

    unawaited(
      FirebaseCrashlytics.instance
          .recordError(
            error,
            stackTrace,
            reason: reason,
          )
          .catchError((_) {}),
    );
  }

  String _shortMessage(TalkerData data) {
    final key = data.key ?? 'talker';
    final message = data.message ?? data.title ?? data.runtimeType.toString();
    final text = '[$key] $message';

    return text.length <= 1024 ? text : text.substring(0, 1024);
  }
}
