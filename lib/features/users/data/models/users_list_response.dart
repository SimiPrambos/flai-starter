import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:template_vgv_app/core/common/paged_response_mapper.dart';
import 'package:template_vgv_app/features/users/data/models/user_model.dart';

part 'users_list_response.freezed.dart';
part 'users_list_response.g.dart';

@freezed
abstract class UsersListResponse
    with _$UsersListResponse, PagedResponseMapper<UserModel> {
  const factory UsersListResponse({
    required int page,
    @JsonKey(name: 'per_page') required int perPage,
    required int total,
    @JsonKey(name: 'total_pages') required int totalPages,
    required List<UserModel> data,
  }) = _UsersListResponse;

  const UsersListResponse._();

  factory UsersListResponse.fromJson(Map<String, dynamic> json) =>
      _$UsersListResponseFromJson(json);
}
