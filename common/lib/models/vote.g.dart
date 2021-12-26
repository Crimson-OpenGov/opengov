// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vote _$VoteFromJson(Map<String, dynamic> json) => Vote(
      userId: json['userId'] as int,
      commentId: json['commentId'] as int,
      score: json['score'] as int,
    );

Map<String, dynamic> _$VoteToJson(Vote instance) => <String, dynamic>{
      'userId': instance.userId,
      'commentId': instance.commentId,
      'score': instance.score,
    };
