import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'comment.g.dart';

abstract class CommentBase {
  const CommentBase();

  int get id;

  String get comment;

  CommentStats? get stats => null;
}

@JsonSerializable()
class Comment extends CommentBase {
  @override
  final int id;

  @JsonKey(name: 'poll_id')
  final int pollId;

  @JsonKey(name: 'user_id')
  final int? userId;

  @override
  final String comment;

  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime timestamp;

  @JsonKey(name: 'is_approved', fromJson: boolFromJson, toJson: boolToJson)
  final bool isApproved;

  @override
  final CommentStats? stats;

  const Comment({
    required this.id,
    required this.pollId,
    required this.userId,
    required this.comment,
    required this.timestamp,
    this.isApproved = false,
    this.stats,
  });

  factory Comment.fromJson(Json json) => _$CommentFromJson(json);

  Comment copyWith({required CommentStats stats}) => Comment(
      id: id,
      pollId: pollId,
      userId: userId,
      comment: comment,
      timestamp: timestamp,
      isApproved: isApproved,
      stats: stats);

  Json toJson() => _$CommentToJson(this);
}

@JsonSerializable()
class CommentStats {
  final int agreeCount;
  final int disagreeCount;
  final int passCount;

  const CommentStats({
    required this.agreeCount,
    required this.disagreeCount,
    required this.passCount,
  });

  factory CommentStats.fromJson(Json json) => _$CommentStatsFromJson(json);

  Json toJson() => _$CommentStatsToJson(this);
}
