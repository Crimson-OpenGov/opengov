// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollDetailsResponse _$PollDetailsResponseFromJson(Map<String, dynamic> json) =>
    PollDetailsResponse(
      comments: (json['comments'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PollDetailsResponseToJson(
        PollDetailsResponse instance) =>
    <String, dynamic>{
      'comments': instance.comments,
    };
