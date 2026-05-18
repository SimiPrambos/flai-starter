// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_by_id_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userByIdNotifierHash() => r'a5660d55a692d3484a7c21e1f0ba747daa772883';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$UserByIdNotifier
    extends BuildlessAutoDisposeAsyncNotifier<UserEntity> {
  late final int id;

  FutureOr<UserEntity> build(int id);
}

/// See also [UserByIdNotifier].
@ProviderFor(UserByIdNotifier)
const userByIdNotifierProvider = UserByIdNotifierFamily();

/// See also [UserByIdNotifier].
class UserByIdNotifierFamily extends Family<AsyncValue<UserEntity>> {
  /// See also [UserByIdNotifier].
  const UserByIdNotifierFamily();

  /// See also [UserByIdNotifier].
  UserByIdNotifierProvider call(int id) {
    return UserByIdNotifierProvider(id);
  }

  @override
  UserByIdNotifierProvider getProviderOverride(
    covariant UserByIdNotifierProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userByIdNotifierProvider';
}

/// See also [UserByIdNotifier].
class UserByIdNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UserByIdNotifier, UserEntity> {
  /// See also [UserByIdNotifier].
  UserByIdNotifierProvider(int id)
    : this._internal(
        () => UserByIdNotifier()..id = id,
        from: userByIdNotifierProvider,
        name: r'userByIdNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userByIdNotifierHash,
        dependencies: UserByIdNotifierFamily._dependencies,
        allTransitiveDependencies:
            UserByIdNotifierFamily._allTransitiveDependencies,
        id: id,
      );

  UserByIdNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  FutureOr<UserEntity> runNotifierBuild(covariant UserByIdNotifier notifier) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(UserByIdNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserByIdNotifierProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserByIdNotifier, UserEntity>
  createElement() {
    return _UserByIdNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserByIdNotifierProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserByIdNotifierRef on AutoDisposeAsyncNotifierProviderRef<UserEntity> {
  /// The parameter `id` of this provider.
  int get id;
}

class _UserByIdNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<UserByIdNotifier, UserEntity>
    with UserByIdNotifierRef {
  _UserByIdNotifierProviderElement(super.provider);

  @override
  int get id => (origin as UserByIdNotifierProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
