import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:template_vgv_app/core/common/paged_response_mapper.dart';
import 'package:template_vgv_app/features/users/data/models/user_model.dart';

part 'users_response.freezed.dart';
part 'users_response.g.dart';

@freezed
class UsersResponse with _$UsersResponse, PagedResponseMapper<UserModel> {
  const factory UsersResponse({
    required int page,
    @JsonKey(name: 'per_page') required int perPage,
    required int total,
    @JsonKey(name: 'total_pages') required int totalPages,
    required List<UserModel> data,
  }) = _UsersResponse;

  const UsersResponse._();

  factory UsersResponse.fromJson(Map<String, dynamic> json) =>
      _$UsersResponseFromJson(json);
}
