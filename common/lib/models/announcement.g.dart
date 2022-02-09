// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
      id: json['id'] as int,
      pollId: json['poll_id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      postedTime: dateTimeFromJson(json['posted_time'] as int),
      emoji: json['emoji'] as String?,
    );

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'poll_id': instance.pollId,
      'title': instance.title,
      'description': instance.description,
      'posted_time': dateTimeToJson(instance.postedTime),
      'emoji': instance.emoji,
    };
