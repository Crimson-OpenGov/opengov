// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as int,
      pollId: json['pollId'] as int,
      userId: json['userId'] as int,
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'pollId': instance.pollId,
      'userId': instance.userId,
      'comment': instance.comment,
    };
