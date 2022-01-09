// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCommentRequest _$UpdateCommentRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateCommentRequest(
      commentId: json['commentId'] as int,
      action: $enumDecode(_$UpdateCommentActionEnumMap, json['action']),
    );

Map<String, dynamic> _$UpdateCommentRequestToJson(
        UpdateCommentRequest instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'action': _$UpdateCommentActionEnumMap[instance.action],
    };

const _$UpdateCommentActionEnumMap = {
  UpdateCommentAction.delete: 'delete',
  UpdateCommentAction.approve: 'approve',
};
