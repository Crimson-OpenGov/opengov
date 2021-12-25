import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/comment.dart';

part 'poll_details.g.dart';

@JsonSerializable()
class PollDetailsResponse {
  final List<Comment> comments;

  PollDetailsResponse({required this.comments});

  factory PollDetailsResponse.fromJson(Json json) =>
      _$PollDetailsResponseFromJson(json);

  Json toJson() => _$PollDetailsResponseToJson(this);
}
