// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddReplyRequest _$AddReplyRequestFromJson(Map<String, dynamic> json) =>
    AddReplyRequest(
      commentId: json['commentId'] as int,
      reply: json['reply'] as String,
    );

Map<String, dynamic> _$AddReplyRequestToJson(AddReplyRequest instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'reply': instance.reply,
    };

AddReplyResponse _$AddReplyResponseFromJson(Map<String, dynamic> json) =>
    AddReplyResponse(
      reason: $enumDecode(_$AddReplyResponseReasonEnumMap, json['reason']),
    );

Map<String, dynamic> _$AddReplyResponseToJson(AddReplyResponse instance) =>
    <String, dynamic>{
      'reason': _$AddReplyResponseReasonEnumMap[instance.reason],
    };

const _$AddReplyResponseReasonEnumMap = {
  AddReplyResponseReason.curseWords: 'curseWords',
  AddReplyResponseReason.error: 'error',
  AddReplyResponseReason.needsApproval: 'needsApproval',
  AddReplyResponseReason.approved: 'approved',
};
