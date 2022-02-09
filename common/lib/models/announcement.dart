import 'package:duration/duration.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'announcement.g.dart';

@JsonSerializable()
class Announcement {
  static const noId = -1;

  final int id;

  @JsonKey(name: 'poll_id')
  final int? pollId;

  final String title;
  final String description;

  @JsonKey(
      name: 'posted_time', fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime postedTime;

  final String? emoji;

  const Announcement({
    required this.id,
    this.pollId,
    required this.title,
    required this.description,
    required this.postedTime,
    this.emoji,
  });

  factory Announcement.fromJson(Json json) => _$AnnouncementFromJson(json);

  Json toJson() => _$AnnouncementToJson(this);

  String get postedTimeFormatted => prettyDuration(
    DateTime.now().difference(postedTime),
    tersity: DurationTersity.minute,
    spacer: '',
    conjunction: ', and ',
    abbreviated: true,
  );
}
