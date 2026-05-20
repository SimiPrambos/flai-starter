import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:template_vgv_app/features/auth/domain/entities/auth_entity.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
class AuthModel with _$AuthModel {
  const factory AuthModel({
    required String token,
  }) = _AuthModel;

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);
}

extension AuthModelMapper on AuthModel {
  AuthEntity toEntity() => AuthEntity(token: token);
}
