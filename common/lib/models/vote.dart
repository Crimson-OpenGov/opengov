import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'vote.g.dart';

@JsonSerializable()
class Vote {
  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'comment_id')
  final int commentId;

  final int score;

  const Vote(
      {required this.userId, required this.commentId, required this.score});

  factory Vote.fromJson(Json json) => _$VoteFromJson(json);

  Json toJson() => _$VoteToJson(this);
}
