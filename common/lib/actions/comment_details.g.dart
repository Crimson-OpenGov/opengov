// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentDetailsResponse _$CommentDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    CommentDetailsResponse(
      parent: Comment.fromJson(json['parent'] as Map<String, dynamic>),
      messages: (json['messages'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentDetailsResponseToJson(
        CommentDetailsResponse instance) =>
    <String, dynamic>{
      'parent': instance.parent,
      'messages': instance.messages,
    };
