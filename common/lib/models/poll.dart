import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'poll.g.dart';

@JsonSerializable()
class Poll {
  final String topic;
  final String description;

  const Poll({required this.topic, required this.description});

  factory Poll.fromJson(Json json) => _$PollFromJson(json);

  Json toJson() => _$PollToJson(this);
}
