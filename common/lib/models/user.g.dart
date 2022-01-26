// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      token: json['token'] as String,
      isAdmin: json['is_admin'] == null
          ? false
          : boolFromJson(json['is_admin'] as int),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'is_admin': boolToJson(instance.isAdmin),
    };
