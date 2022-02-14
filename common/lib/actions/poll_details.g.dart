// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollDetailsResponse _$PollDetailsResponseFromJson(Map<String, dynamic> json) =>
    PollDetailsResponse(
      poll: Poll.fromJson(json['poll'] as Map<String, dynamic>),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PollDetailsResponseToJson(
        PollDetailsResponse instance) =>
    <String, dynamic>{
      'poll': instance.poll,
      'comments': instance.comments,
    };
