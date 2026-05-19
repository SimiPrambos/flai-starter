import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:template_vgv_app/features/users/data/models/user_model.dart';

part 'user_single_response.freezed.dart';
part 'user_single_response.g.dart';

@freezed
class UserSingleResponse with _$UserSingleResponse {
  const factory UserSingleResponse({required UserModel data}) =
      _UserSingleResponse;

  factory UserSingleResponse.fromJson(Map<String, dynamic> json) =>
      _$UserSingleResponseFromJson(json);
}
