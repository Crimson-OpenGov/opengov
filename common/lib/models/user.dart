import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;

  @Deprecated('Use token instead')
  final String username;

  final String token;

  @JsonKey(name: 'is_admin', fromJson: boolFromJson, toJson: boolToJson)
  final bool isAdmin;

  const User({
    required this.id,
    this.username = '',
    required this.token,
    this.isAdmin = false,
  });

  factory User.fromJson(Json json) => _$UserFromJson(json);

  bool get isNotAdmin => !isAdmin;

  Json toJson() => _$UserToJson(this);
}
