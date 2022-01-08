// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoteRequest _$VoteRequestFromJson(Map<String, dynamic> json) => VoteRequest(
      commentId: json['commentId'] as int,
      score: json['score'] as int,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$VoteRequestToJson(VoteRequest instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'score': instance.score,
      'reason': instance.reason,
    };
