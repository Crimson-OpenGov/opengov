// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_announcements.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListAnnouncementsResponse _$ListAnnouncementsResponseFromJson(
        Map<String, dynamic> json) =>
    ListAnnouncementsResponse(
      announcements: (json['announcements'] as List<dynamic>)
          .map((e) => Announcement.fromJson(e as Map<String, dynamic>))
          .toList(),
      announcementToPoll:
          (json['announcementToPoll'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(int.parse(k), Poll.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$ListAnnouncementsResponseToJson(
        ListAnnouncementsResponse instance) =>
    <String, dynamic>{
      'announcements': instance.announcements,
      'announcementToPoll':
          instance.announcementToPoll.map((k, e) => MapEntry(k.toString(), e)),
    };
