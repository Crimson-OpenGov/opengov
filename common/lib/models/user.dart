import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String username;

  @JsonKey(name: 'is_admin', fromJson: boolFromJson)
  final bool isAdmin;

  const User({required this.id, required this.username, this.isAdmin = false});

  factory User.fromJson(Json json) => _$UserFromJson(json);

  Json toJson() => _$UserToJson(this);
}
