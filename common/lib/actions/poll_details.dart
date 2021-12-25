import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/comment.dart';

part 'poll_details.g.dart';

@JsonSerializable()
class PollDetailsRequest {
  final int pollId;

  PollDetailsRequest({required this.pollId});

  factory PollDetailsRequest.fromJson(Json json) =>
      _$PollDetailsRequestFromJson(json);

  Json toJson() => _$PollDetailsRequestToJson(this);
}

@JsonSerializable()
class PollDetailsResponse {
  final List<Comment> comments;

  PollDetailsResponse({required this.comments});
}
