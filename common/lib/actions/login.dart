import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'login.g.dart';

@JsonSerializable()
class LoginRequest {
  final String username;

  const LoginRequest({required this.username});

  factory LoginRequest.fromJson(Json json) => _$LoginRequestFromJson(json);

  Json toJson() => _$LoginRequestToJson(this);
}