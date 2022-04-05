// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateReplyRequest _$UpdateReplyRequestFromJson(Map<String, dynamic> json) =>
    UpdateReplyRequest(
      replyId: json['replyId'] as int,
      action: $enumDecode(_$UpdateReplyActionEnumMap, json['action']),
    );

Map<String, dynamic> _$UpdateReplyRequestToJson(UpdateReplyRequest instance) =>
    <String, dynamic>{
      'replyId': instance.replyId,
      'action': _$UpdateReplyActionEnumMap[instance.action],
    };

const _$UpdateReplyActionEnumMap = {
  UpdateReplyAction.delete: 'delete',
  UpdateReplyAction.approve: 'approve',
};
