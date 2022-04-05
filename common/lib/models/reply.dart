import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'reply.g.dart';

abstract class ReplyBase {
  const ReplyBase();

  int get id;

  String get reply;

  ReplyStats? get stats;
}

@JsonSerializable()
class Reply extends ReplyBase {
  @override
  final int id;

  @JsonKey(name: 'comment_id')
  final int commentId;

  @JsonKey(name: 'user_id')
  final int? userId;

  @override
  final String reply;

  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime timestamp;

  @JsonKey(name: 'is_approved', fromJson: boolFromJson, toJson: boolToJson)
  final bool isApproved;

  @override
  final ReplyStats? stats;

  const Reply({
    required this.id,
    required this.commentId,
    required this.userId,
    required this.reply,
    required this.timestamp,
    this.isApproved = false,
    this.stats,
  });

  factory Reply.fromJson(Json json) => _$ReplyFromJson(json);

  Reply copyWith({required ReplyStats stats}) => Reply(
      id: id,
      commentId: commentId,
      userId: userId,
      reply: reply,
      timestamp: timestamp,
      isApproved: isApproved,
      stats: stats);

  Json toJson() => _$ReplyToJson(this);
}

@JsonSerializable()
class ReplyStats {
  final int agreeCount;
  final int disagreeCount;
  final int passCount;

  const ReplyStats({
    required this.agreeCount,
    required this.disagreeCount,
    required this.passCount,
  });

  factory ReplyStats.fromJson(Json json) => _$ReplyStatsFromJson(json);

  Json toJson() => _$ReplyStatsToJson(this);
}
