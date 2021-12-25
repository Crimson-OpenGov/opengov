// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCommentRequest _$AddCommentRequestFromJson(Map<String, dynamic> json) =>
    AddCommentRequest(
      pollId: json['pollId'] as int,
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$AddCommentRequestToJson(AddCommentRequest instance) =>
    <String, dynamic>{
      'pollId': instance.pollId,
      'comment': instance.comment,
    };
