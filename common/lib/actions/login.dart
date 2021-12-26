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

@JsonSerializable()
class VerificationRequest {
  final String username;
  final String code;

  const VerificationRequest({required this.username, required this.code});

  factory VerificationRequest.fromJson(Json json) =>
      _$VerificationRequestFromJson(json);

  Json toJson() => _$VerificationRequestToJson(this);
}

@JsonSerializable()
class VerificationResponse {
  final String? token;

  const VerificationResponse({required this.token});

  factory VerificationResponse.fromJson(Json json) =>
      _$VerificationResponseFromJson(json);

  Json toJson() => _$VerificationResponseToJson(this);
}
