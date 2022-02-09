import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/announcement.dart';
import 'package:opengov_common/models/poll.dart';

part 'announcement_details.g.dart';

@JsonSerializable()
class AnnouncementDetailsResponse {
  final Announcement announcement;
  final Poll? poll;

  const AnnouncementDetailsResponse({required this.announcement, this.poll});

  factory AnnouncementDetailsResponse.fromJson(Json json) =>
      _$AnnouncementDetailsResponseFromJson(json);

  Json toJson() => _$AnnouncementDetailsResponseToJson(this);
}
