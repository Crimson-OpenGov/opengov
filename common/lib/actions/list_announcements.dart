import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/announcement.dart';

part 'list_announcements.g.dart';

@JsonSerializable()
class ListedAnnouncement extends Announcement {
  @JsonKey(name: 'poll_emoji')
  final String? pollEmoji;

  ListedAnnouncement(
      {required int id,
      int? pollId,
      required String title,
      required String description,
      required DateTime postedTime,
      String? emoji,
      this.pollEmoji})
      : super(
            id: id,
            pollId: pollId,
            title: title,
            description: description,
            postedTime: postedTime,
            emoji: emoji);

  @override
  String? get emoji => super.emoji ?? pollEmoji;

  factory ListedAnnouncement.fromJson(Json json) =>
      _$ListedAnnouncementFromJson(json);

  @override
  Json toJson() => _$ListedAnnouncementToJson(this);
}

@JsonSerializable()
class ListAnnouncementsResponse {
  final List<ListedAnnouncement> announcements;

  const ListAnnouncementsResponse({required this.announcements});

  factory ListAnnouncementsResponse.fromJson(Json json) =>
      _$ListAnnouncementsResponseFromJson(json);

  Json toJson() => _$ListAnnouncementsResponseToJson(this);
}
