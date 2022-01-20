// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingLogin _$PendingLoginFromJson(Map<String, dynamic> json) => PendingLogin(
      id: json['id'] as int,
      username: json['username'] as String,
      code: codeFromJson(json['code'] as int),
      expiration: dateTimeFromJson(json['expiration'] as int),
    );

Map<String, dynamic> _$PendingLoginToJson(PendingLogin instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'code': codeToJson(instance.code),
      'expiration': dateTimeToJson(instance.expiration),
    };
