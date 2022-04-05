import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'vote_reply.g.dart';

@JsonSerializable()
class VoteReply {
  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'reply_id')
  final int replyId;

  final int score;

  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime timestamp;

  const VoteReply({
    required this.userId,
    required this.replyId,
    required this.score,
    required this.timestamp,
  });

  factory VoteReply.fromJson(Json json) => _$VoteReplyFromJson(json);

  Json toJson() => _$VoteReplyToJson(this);
}
