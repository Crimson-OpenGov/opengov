import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'vote.g.dart';

@JsonSerializable()
class VoteRequest {
  final int commentId;
  final int score;
  final String? reason;

  const VoteRequest(
      {required this.commentId, required this.score, this.reason});

  factory VoteRequest.fromJson(Json json) => _$VoteRequestFromJson(json);

  Json toJson() => _$VoteRequestToJson(this);
}
