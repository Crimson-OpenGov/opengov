// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      username: json['username'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
    };

VerificationRequest _$VerificationRequestFromJson(Map<String, dynamic> json) =>
    VerificationRequest(
      username: json['username'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$VerificationRequestToJson(
        VerificationRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'code': instance.code,
    };

VerificationResponse _$VerificationResponseFromJson(
        Map<String, dynamic> json) =>
    VerificationResponse(
      token: json['token'] as String?,
    );

Map<String, dynamic> _$VerificationResponseToJson(
        VerificationResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
    };
