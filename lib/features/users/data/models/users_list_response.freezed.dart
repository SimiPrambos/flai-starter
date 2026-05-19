// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UsersListResponse _$UsersListResponseFromJson(Map<String, dynamic> json) {
  return _UsersListResponse.fromJson(json);
}

/// @nodoc
mixin _$UsersListResponse {
  int get page => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page')
  int get perPage => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pages')
  int get totalPages => throw _privateConstructorUsedError;
  List<UserModel> get data => throw _privateConstructorUsedError;

  /// Serializes this UsersListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UsersListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UsersListResponseCopyWith<UsersListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsersListResponseCopyWith<$Res> {
  factory $UsersListResponseCopyWith(
    UsersListResponse value,
    $Res Function(UsersListResponse) then,
  ) = _$UsersListResponseCopyWithImpl<$Res, UsersListResponse>;
  @useResult
  $Res call({
    int page,
    @JsonKey(name: 'per_page') int perPage,
    int total,
    @JsonKey(name: 'total_pages') int totalPages,
    List<UserModel> data,
  });
}

/// @nodoc
class _$UsersListResponseCopyWithImpl<$Res, $Val extends UsersListResponse>
    implements $UsersListResponseCopyWith<$Res> {
  _$UsersListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsersListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? perPage = null,
    Object? total = null,
    Object? totalPages = null,
    Object? data = null,
  }) {
    return _then(
      _value.copyWith(
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            perPage: null == perPage
                ? _value.perPage
                : perPage // ignore: cast_nullable_to_non_nullable
                      as int,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<UserModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UsersListResponseImplCopyWith<$Res>
    implements $UsersListResponseCopyWith<$Res> {
  factory _$$UsersListResponseImplCopyWith(
    _$UsersListResponseImpl value,
    $Res Function(_$UsersListResponseImpl) then,
  ) = __$$UsersListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int page,
    @JsonKey(name: 'per_page') int perPage,
    int total,
    @JsonKey(name: 'total_pages') int totalPages,
    List<UserModel> data,
  });
}

/// @nodoc
class __$$UsersListResponseImplCopyWithImpl<$Res>
    extends _$UsersListResponseCopyWithImpl<$Res, _$UsersListResponseImpl>
    implements _$$UsersListResponseImplCopyWith<$Res> {
  __$$UsersListResponseImplCopyWithImpl(
    _$UsersListResponseImpl _value,
    $Res Function(_$UsersListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsersListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? perPage = null,
    Object? total = null,
    Object? totalPages = null,
    Object? data = null,
  }) {
    return _then(
      _$UsersListResponseImpl(
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        perPage: null == perPage
            ? _value.perPage
            : perPage // ignore: cast_nullable_to_non_nullable
                  as int,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<UserModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UsersListResponseImpl extends _UsersListResponse {
  const _$UsersListResponseImpl({
    required this.page,
    @JsonKey(name: 'per_page') required this.perPage,
    required this.total,
    @JsonKey(name: 'total_pages') required this.totalPages,
    required final List<UserModel> data,
  }) : _data = data,
       super._();

  factory _$UsersListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsersListResponseImplFromJson(json);

  @override
  final int page;
  @override
  @JsonKey(name: 'per_page')
  final int perPage;
  @override
  final int total;
  @override
  @JsonKey(name: 'total_pages')
  final int totalPages;
  final List<UserModel> _data;
  @override
  List<UserModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'UsersListResponse(page: $page, perPage: $perPage, total: $total, totalPages: $totalPages, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsersListResponseImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    page,
    perPage,
    total,
    totalPages,
    const DeepCollectionEquality().hash(_data),
  );

  /// Create a copy of UsersListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsersListResponseImplCopyWith<_$UsersListResponseImpl> get copyWith =>
      __$$UsersListResponseImplCopyWithImpl<_$UsersListResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UsersListResponseImplToJson(this);
  }
}

abstract class _UsersListResponse extends UsersListResponse {
  const factory _UsersListResponse({
    required final int page,
    @JsonKey(name: 'per_page') required final int perPage,
    required final int total,
    @JsonKey(name: 'total_pages') required final int totalPages,
    required final List<UserModel> data,
  }) = _$UsersListResponseImpl;
  const _UsersListResponse._() : super._();

  factory _UsersListResponse.fromJson(Map<String, dynamic> json) =
      _$UsersListResponseImpl.fromJson;

  @override
  int get page;
  @override
  @JsonKey(name: 'per_page')
  int get perPage;
  @override
  int get total;
  @override
  @JsonKey(name: 'total_pages')
  int get totalPages;
  @override
  List<UserModel> get data;

  /// Create a copy of UsersListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsersListResponseImplCopyWith<_$UsersListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
