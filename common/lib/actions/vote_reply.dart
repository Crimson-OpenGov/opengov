import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'vote_reply.g.dart';

@JsonSerializable()
class VoteReplyRequest {
  final int replyId;
  final int score;
  final String? reason;

  const VoteReplyRequest(
      {required this.replyId, required this.score, this.reason});

  factory VoteReplyRequest.fromJson(Json json) => _$VoteReplyRequestFromJson(json);

  Json toJson() => _$VoteReplyRequestToJson(this);
}
