// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentDetailsResponse _$CommentDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    CommentDetailsResponse(
      comment: Comment.fromJson(json['comment'] as Map<String, dynamic>),
      replies: (json['replies'] as List<dynamic>)
          .map((e) => Reply.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentDetailsResponseToJson(
        CommentDetailsResponse instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'replies': instance.replies,
    };
