// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCommentRequest _$AddCommentRequestFromJson(Map<String, dynamic> json) =>
    AddCommentRequest(
      pollId: json['pollId'] as int,
      comment: json['comment'] as String,
      parentId: json['parentId'] as int?,
    );

Map<String, dynamic> _$AddCommentRequestToJson(AddCommentRequest instance) =>
    <String, dynamic>{
      'pollId': instance.pollId,
      'comment': instance.comment,
      'parentId': instance.parentId,
    };

AddCommentResponse _$AddCommentResponseFromJson(Map<String, dynamic> json) =>
    AddCommentResponse(
      reason: $enumDecode(_$AddCommentResponseReasonEnumMap, json['reason']),
    );

Map<String, dynamic> _$AddCommentResponseToJson(AddCommentResponse instance) =>
    <String, dynamic>{
      'reason': _$AddCommentResponseReasonEnumMap[instance.reason],
    };

const _$AddCommentResponseReasonEnumMap = {
  AddCommentResponseReason.curseWords: 'curseWords',
  AddCommentResponseReason.error: 'error',
  AddCommentResponseReason.needsApproval: 'needsApproval',
  AddCommentResponseReason.approved: 'approved',
};
