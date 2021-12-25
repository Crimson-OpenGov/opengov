// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Poll _$PollFromJson(Map<String, dynamic> json) => Poll(
      topic: json['topic'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$PollToJson(Poll instance) => <String, dynamic>{
      'topic': instance.topic,
      'description': instance.description,
    };
