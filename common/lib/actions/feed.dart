import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/comment.dart';

part 'feed.g.dart';

@JsonSerializable()
class FeedComment extends CommentBase {
  @override
  final int id;

  @JsonKey(name: 'poll_id')
  final int pollId;

  @override
  final String comment;

  @JsonKey(name: 'poll_topic')
  final String pollTopic;

  @JsonKey(name: 'poll_emoji')
  final String pollEmoji;

  @override
  final CommentStats? stats;

  const FeedComment({
    required this.id,
    required this.pollId,
    required this.comment,
    required this.pollTopic,
    required this.pollEmoji,
    this.stats,
  });

  factory FeedComment.fromJson(Json json) => _$FeedCommentFromJson(json);

  FeedComment copyWith({CommentStats? stats}) => FeedComment(
      id: id,
      pollId: pollId,
      comment: comment,
      pollTopic: pollTopic,
      pollEmoji: pollEmoji,
      stats: stats);

  Json toJson() => _$FeedCommentToJson(this);
}

@JsonSerializable()
class FeedResponse {
  final List<FeedComment> comments;

  const FeedResponse({required this.comments});

  factory FeedResponse.fromJson(Json json) => _$FeedResponseFromJson(json);

  Json toJson() => _$FeedResponseToJson(this);
}
