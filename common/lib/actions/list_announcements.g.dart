// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_announcements.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListedAnnouncement _$ListedAnnouncementFromJson(Map<String, dynamic> json) =>
    ListedAnnouncement(
      id: json['id'] as int,
      pollId: json['poll_id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      postedTime: dateTimeFromJson(json['posted_time'] as int),
      emoji: json['emoji'] as String?,
      pollEmoji: json['poll_emoji'] as String?,
    );

Map<String, dynamic> _$ListedAnnouncementToJson(ListedAnnouncement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'poll_id': instance.pollId,
      'title': instance.title,
      'description': instance.description,
      'posted_time': dateTimeToJson(instance.postedTime),
      'poll_emoji': instance.pollEmoji,
      'emoji': instance.emoji,
    };

ListAnnouncementsResponse _$ListAnnouncementsResponseFromJson(
        Map<String, dynamic> json) =>
    ListAnnouncementsResponse(
      announcements: (json['announcements'] as List<dynamic>)
          .map((e) => ListedAnnouncement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListAnnouncementsResponseToJson(
        ListAnnouncementsResponse instance) =>
    <String, dynamic>{
      'announcements': instance.announcements,
    };
