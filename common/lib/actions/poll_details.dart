import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/models/poll.dart';

part 'poll_details.g.dart';

@JsonSerializable()
class PollDetailsResponse {
  final Poll parent;
  final List<Comment> messages;

  PollDetailsResponse({required this.parent, required this.messages});

  factory PollDetailsResponse.fromJson(Json json) =>
      _$PollDetailsResponseFromJson(json);

  Json toJson() => _$PollDetailsResponseToJson(this);
}
