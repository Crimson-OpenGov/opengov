// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reply _$ReplyFromJson(Map<String, dynamic> json) => Reply(
      id: json['id'] as int,
      commentId: json['comment_id'] as int,
      userId: json['user_id'] as int?,
      reply: json['reply'] as String,
      timestamp: dateTimeFromJson(json['timestamp'] as int),
      isApproved: json['is_approved'] == null
          ? false
          : boolFromJson(json['is_approved']),
      stats: json['stats'] == null
          ? null
          : ReplyStats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReplyToJson(Reply instance) => <String, dynamic>{
      'id': instance.id,
      'comment_id': instance.commentId,
      'user_id': instance.userId,
      'reply': instance.reply,
      'timestamp': dateTimeToJson(instance.timestamp),
      'is_approved': boolToJson(instance.isApproved),
      'stats': instance.stats,
    };

ReplyStats _$ReplyStatsFromJson(Map<String, dynamic> json) => ReplyStats(
      agreeCount: json['agreeCount'] as int,
      disagreeCount: json['disagreeCount'] as int,
      passCount: json['passCount'] as int,
    );

Map<String, dynamic> _$ReplyStatsToJson(ReplyStats instance) =>
    <String, dynamic>{
      'agreeCount': instance.agreeCount,
      'disagreeCount': instance.disagreeCount,
      'passCount': instance.passCount,
    };
