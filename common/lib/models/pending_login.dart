import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'pending_login.g.dart';

@JsonSerializable()
class PendingLogin {
  final int id;
  final String username;

  @JsonKey(fromJson: codeFromJson, toJson: codeToJson)
  final String code;

  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime expiration;

  const PendingLogin({
    required this.id,
    required this.username,
    required this.code,
    required this.expiration,
  });

  factory PendingLogin.fromJson(Json json) => _$PendingLoginFromJson(json);

  bool get isActive => expiration.isAfter(DateTime.now());

  Json toJson() => _$PendingLoginToJson(this);
}
