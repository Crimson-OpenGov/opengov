// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementDetailsResponse _$AnnouncementDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    AnnouncementDetailsResponse(
      announcement:
          Announcement.fromJson(json['announcement'] as Map<String, dynamic>),
      poll: json['poll'] == null
          ? null
          : Poll.fromJson(json['poll'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnnouncementDetailsResponseToJson(
        AnnouncementDetailsResponse instance) =>
    <String, dynamic>{
      'announcement': instance.announcement,
      'poll': instance.poll,
    };
