// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoteReply _$VoteReplyFromJson(Map<String, dynamic> json) => VoteReply(
      userId: json['user_id'] as int?,
      replyId: json['reply_id'] as int,
      score: json['score'] as int,
      timestamp: dateTimeFromJson(json['timestamp'] as int),
    );

Map<String, dynamic> _$VoteReplyToJson(VoteReply instance) => <String, dynamic>{
      'user_id': instance.userId,
      'reply_id': instance.replyId,
      'score': instance.score,
      'timestamp': dateTimeToJson(instance.timestamp),
    };
