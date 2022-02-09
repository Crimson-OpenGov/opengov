import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/announcement.dart';
import 'package:opengov_common/models/poll.dart';

part 'list_announcements.g.dart';

@JsonSerializable()
class ListAnnouncementsResponse {
  final List<Announcement> announcements;

  /// Map from [Announcement.id] to [Poll] for [Announcement]s that have a
  /// corresponding [Poll].
  final Map<int, Poll> announcementToPoll;

  const ListAnnouncementsResponse(
      {required this.announcements, required this.announcementToPoll});

  factory ListAnnouncementsResponse.fromJson(Json json) =>
      _$ListAnnouncementsResponseFromJson(json);

  Json toJson() => _$ListAnnouncementsResponseToJson(this);
}
