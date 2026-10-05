// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionNotifierHash() => r'a1155cee52b230d8bc113e75e73d907112d43a0b';

/// App-wide signed-in flag.
///
/// `appRouter` listens to this provider and re-runs its redirect on every
/// change, so callers never navigate after [signIn] or [signOut].
///
/// Copied from [SessionNotifier].
@ProviderFor(SessionNotifier)
final sessionNotifierProvider =
    AsyncNotifierProvider<SessionNotifier, bool>.internal(
      SessionNotifier.new,
      name: r'sessionNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sessionNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SessionNotifier = AsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
