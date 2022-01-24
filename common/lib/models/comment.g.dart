// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as int,
      pollId: json['poll_id'] as int,
      userId: json['user_id'] as int?,
      comment: json['comment'] as String,
      timestamp: dateTimeFromJson(json['timestamp'] as int),
      isApproved: json['is_approved'] == null
          ? false
          : boolFromJson(json['is_approved'] as int),
      stats: json['stats'] == null
          ? null
          : CommentStats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'poll_id': instance.pollId,
      'user_id': instance.userId,
      'comment': instance.comment,
      'timestamp': dateTimeToJson(instance.timestamp),
      'is_approved': boolToJson(instance.isApproved),
      'stats': instance.stats,
    };

CommentStats _$CommentStatsFromJson(Map<String, dynamic> json) => CommentStats(
      agreeCount: json['agreeCount'] as int,
      disagreeCount: json['disagreeCount'] as int,
      passCount: json['passCount'] as int,
    );

Map<String, dynamic> _$CommentStatsToJson(CommentStats instance) =>
    <String, dynamic>{
      'agreeCount': instance.agreeCount,
      'disagreeCount': instance.disagreeCount,
      'passCount': instance.passCount,
    };
