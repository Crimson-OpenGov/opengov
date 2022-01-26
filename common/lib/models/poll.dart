import 'package:duration/duration.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'poll.g.dart';

@JsonSerializable()
class Poll {
  static const noId = -1;

  final int id;
  final String topic;
  final String? description;

  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime end;

  final String emoji;

  @JsonKey(name: 'is_permanent')
  final bool isPermanent;

  const Poll({
    required this.id,
    required this.topic,
    required this.description,
    required this.end,
    required this.emoji,
    this.isPermanent = false,
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

  Poll copyWith({int? id}) => Poll(
      id: id ?? this.id,
      topic: topic,
      description: description,
      end: end,
      emoji: emoji,
      isPermanent: isPermanent);

  @override
  bool operator ==(Object other) =>
      other is Poll &&
      other.id == id &&
      other.topic == topic &&
      other.description == description &&
      other.end == end &&
      other.emoji == emoji &&
      other.isPermanent == isPermanent;

  @override
  int get hashCode =>
      Object.hash(id, topic, description, end, emoji, isPermanent);
}
