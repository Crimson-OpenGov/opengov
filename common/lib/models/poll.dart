import 'package:duration/duration.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'poll.g.dart';

@JsonSerializable()
class Poll {
  final int id;
  final String topic;
  final String? description;

  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime end;

  const Poll({
    required this.id,
    required this.topic,
    required this.description,
    required this.end,
  });

  factory Poll.fromJson(Json json) => _$PollFromJson(json);

  Json toJson() => _$PollToJson(this);

  bool get isActive => end.isAfter(DateTime.now());

  String get endFormatted => prettyDuration(
        end.difference(DateTime.now()),
        tersity: DurationTersity.minute,
        spacer: '',
        conjunction: ', and ',
        abbreviated: true,
      );
}
