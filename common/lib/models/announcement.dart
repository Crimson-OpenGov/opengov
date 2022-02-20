import 'package:intl/intl.dart';
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

  String get durationFormatted {
    final duration = DateTime.now().difference(postedTime);

    final weeks = duration.inDays ~/ 7;
    if (weeks > 0) {
      return Intl.plural(weeks, one: '$weeks week', other: '$weeks weeks');
    }

    final days = duration.inDays;
    if (days > 0) {
      return Intl.plural(days, one: '$days day', other: '$days days');
    }

    final hours = duration.inHours;
    if (hours > 0) {
      return Intl.plural(hours, one: '$hours hour', other: '$hours hours');
    }

    final minutes = duration.inMinutes;
    if (minutes > 0) {
      return Intl.plural(minutes,
          one: '$minutes min', other: '$minutes mins');
    }

    return 'now';
  }
}
