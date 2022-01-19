// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vote _$VoteFromJson(Map<String, dynamic> json) => Vote(
      userId: json['user_id'] as int?,
      commentId: json['comment_id'] as int,
      score: json['score'] as int,
      timestamp: dateTimeFromJson(json['timestamp'] as int),
    );

Map<String, dynamic> _$VoteToJson(Vote instance) => <String, dynamic>{
      'user_id': instance.userId,
      'comment_id': instance.commentId,
      'score': instance.score,
      'timestamp': dateTimeToJson(instance.timestamp),
    };
