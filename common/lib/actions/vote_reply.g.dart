// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoteReplyRequest _$VoteReplyRequestFromJson(Map<String, dynamic> json) =>
    VoteReplyRequest(
      replyId: json['replyId'] as int,
      score: json['score'] as int,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$VoteReplyRequestToJson(VoteReplyRequest instance) =>
    <String, dynamic>{
      'replyId': instance.replyId,
      'score': instance.score,
      'reason': instance.reason,
    };
