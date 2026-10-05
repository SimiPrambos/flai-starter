// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UsersListResponse {

 int get page;@JsonKey(name: 'per_page') int get perPage; int get total;@JsonKey(name: 'total_pages') int get totalPages; List<UserModel> get data;
/// Create a copy of UsersListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsersListResponseCopyWith<UsersListResponse> get copyWith => _$UsersListResponseCopyWithImpl<UsersListResponse>(this as UsersListResponse, _$identity);

  /// Serializes this UsersListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsersListResponse&&(identical(other.page, page) || other.page == page)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,perPage,total,totalPages,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'UsersListResponse(page: $page, perPage: $perPage, total: $total, totalPages: $totalPages, data: $data)';
}


}

/// @nodoc
abstract mixin class $UsersListResponseCopyWith<$Res>  {
  factory $UsersListResponseCopyWith(UsersListResponse value, $Res Function(UsersListResponse) _then) = _$UsersListResponseCopyWithImpl;
@useResult
$Res call({
 int page,@JsonKey(name: 'per_page') int perPage, int total,@JsonKey(name: 'total_pages') int totalPages, List<UserModel> data
});




}
/// @nodoc
class _$UsersListResponseCopyWithImpl<$Res>
    implements $UsersListResponseCopyWith<$Res> {
  _$UsersListResponseCopyWithImpl(this._self, this._then);

  final UsersListResponse _self;
  final $Res Function(UsersListResponse) _then;

/// Create a copy of UsersListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? perPage = null,Object? total = null,Object? totalPages = null,Object? data = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<UserModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [UsersListResponse].
extension UsersListResponsePatterns on UsersListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsersListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsersListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsersListResponse value)  $default,){
final _that = this;
switch (_that) {
case _UsersListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsersListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UsersListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page, @JsonKey(name: 'per_page')  int perPage,  int total, @JsonKey(name: 'total_pages')  int totalPages,  List<UserModel> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsersListResponse() when $default != null:
return $default(_that.page,_that.perPage,_that.total,_that.totalPages,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page, @JsonKey(name: 'per_page')  int perPage,  int total, @JsonKey(name: 'total_pages')  int totalPages,  List<UserModel> data)  $default,) {final _that = this;
switch (_that) {
case _UsersListResponse():
return $default(_that.page,_that.perPage,_that.total,_that.totalPages,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page, @JsonKey(name: 'per_page')  int perPage,  int total, @JsonKey(name: 'total_pages')  int totalPages,  List<UserModel> data)?  $default,) {final _that = this;
switch (_that) {
case _UsersListResponse() when $default != null:
return $default(_that.page,_that.perPage,_that.total,_that.totalPages,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UsersListResponse extends UsersListResponse {
  const _UsersListResponse({required this.page, @JsonKey(name: 'per_page') required this.perPage, required this.total, @JsonKey(name: 'total_pages') required this.totalPages, required final  List<UserModel> data}): _data = data,super._();
  factory _UsersListResponse.fromJson(Map<String, dynamic> json) => _$UsersListResponseFromJson(json);

@override final  int page;
@override@JsonKey(name: 'per_page') final  int perPage;
@override final  int total;
@override@JsonKey(name: 'total_pages') final  int totalPages;
 final  List<UserModel> _data;
@override List<UserModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of UsersListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsersListResponseCopyWith<_UsersListResponse> get copyWith => __$UsersListResponseCopyWithImpl<_UsersListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsersListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsersListResponse&&(identical(other.page, page) || other.page == page)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,perPage,total,totalPages,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'UsersListResponse(page: $page, perPage: $perPage, total: $total, totalPages: $totalPages, data: $data)';
}


}

/// @nodoc
abstract mixin class _$UsersListResponseCopyWith<$Res> implements $UsersListResponseCopyWith<$Res> {
  factory _$UsersListResponseCopyWith(_UsersListResponse value, $Res Function(_UsersListResponse) _then) = __$UsersListResponseCopyWithImpl;
@override @useResult
$Res call({
 int page,@JsonKey(name: 'per_page') int perPage, int total,@JsonKey(name: 'total_pages') int totalPages, List<UserModel> data
});




}
/// @nodoc
class __$UsersListResponseCopyWithImpl<$Res>
    implements _$UsersListResponseCopyWith<$Res> {
  __$UsersListResponseCopyWithImpl(this._self, this._then);

  final _UsersListResponse _self;
  final $Res Function(_UsersListResponse) _then;

/// Create a copy of UsersListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? perPage = null,Object? total = null,Object? totalPages = null,Object? data = null,}) {
  return _then(_UsersListResponse(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<UserModel>,
  ));
}


}

// dart format on
