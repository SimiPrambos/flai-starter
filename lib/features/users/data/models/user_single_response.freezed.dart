// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_single_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserSingleResponse {

 UserModel get data;
/// Create a copy of UserSingleResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSingleResponseCopyWith<UserSingleResponse> get copyWith => _$UserSingleResponseCopyWithImpl<UserSingleResponse>(this as UserSingleResponse, _$identity);

  /// Serializes this UserSingleResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSingleResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'UserSingleResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class $UserSingleResponseCopyWith<$Res>  {
  factory $UserSingleResponseCopyWith(UserSingleResponse value, $Res Function(UserSingleResponse) _then) = _$UserSingleResponseCopyWithImpl;
@useResult
$Res call({
 UserModel data
});


$UserModelCopyWith<$Res> get data;

}
/// @nodoc
class _$UserSingleResponseCopyWithImpl<$Res>
    implements $UserSingleResponseCopyWith<$Res> {
  _$UserSingleResponseCopyWithImpl(this._self, this._then);

  final UserSingleResponse _self;
  final $Res Function(UserSingleResponse) _then;

/// Create a copy of UserSingleResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as UserModel,
  ));
}
/// Create a copy of UserSingleResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get data {
  
  return $UserModelCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserSingleResponse].
extension UserSingleResponsePatterns on UserSingleResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSingleResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSingleResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSingleResponse value)  $default,){
final _that = this;
switch (_that) {
case _UserSingleResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSingleResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UserSingleResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSingleResponse() when $default != null:
return $default(_that.data);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel data)  $default,) {final _that = this;
switch (_that) {
case _UserSingleResponse():
return $default(_that.data);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel data)?  $default,) {final _that = this;
switch (_that) {
case _UserSingleResponse() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserSingleResponse implements UserSingleResponse {
  const _UserSingleResponse({required this.data});
  factory _UserSingleResponse.fromJson(Map<String, dynamic> json) => _$UserSingleResponseFromJson(json);

@override final  UserModel data;

/// Create a copy of UserSingleResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSingleResponseCopyWith<_UserSingleResponse> get copyWith => __$UserSingleResponseCopyWithImpl<_UserSingleResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserSingleResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSingleResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'UserSingleResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class _$UserSingleResponseCopyWith<$Res> implements $UserSingleResponseCopyWith<$Res> {
  factory _$UserSingleResponseCopyWith(_UserSingleResponse value, $Res Function(_UserSingleResponse) _then) = __$UserSingleResponseCopyWithImpl;
@override @useResult
$Res call({
 UserModel data
});


@override $UserModelCopyWith<$Res> get data;

}
/// @nodoc
class __$UserSingleResponseCopyWithImpl<$Res>
    implements _$UserSingleResponseCopyWith<$Res> {
  __$UserSingleResponseCopyWithImpl(this._self, this._then);

  final _UserSingleResponse _self;
  final $Res Function(_UserSingleResponse) _then;

/// Create a copy of UserSingleResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_UserSingleResponse(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as UserModel,
  ));
}

/// Create a copy of UserSingleResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get data {
  
  return $UserModelCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
