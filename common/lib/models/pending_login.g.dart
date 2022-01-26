// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingLogin _$PendingLoginFromJson(Map<String, dynamic> json) => PendingLogin(
      id: json['id'] as int,
      token: json['token'] as String,
      code: json['code'] as String,
      expiration: dateTimeFromJson(json['expiration'] as int),
    );

Map<String, dynamic> _$PendingLoginToJson(PendingLogin instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'code': instance.code,
      'expiration': dateTimeToJson(instance.expiration),
    };
