// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollDetailsResponse _$PollDetailsResponseFromJson(Map<String, dynamic> json) =>
    PollDetailsResponse(
      parent: Poll.fromJson(json['parent'] as Map<String, dynamic>),
      messages: (json['messages'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PollDetailsResponseToJson(
        PollDetailsResponse instance) =>
    <String, dynamic>{
      'parent': instance.parent,
      'messages': instance.messages,
    };
