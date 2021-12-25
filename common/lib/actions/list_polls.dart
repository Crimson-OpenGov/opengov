import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/poll.dart';

part 'list_polls.g.dart';

@JsonSerializable()
class ListPollsResponse {
  final List<Poll> polls;

  const ListPollsResponse({required this.polls});

  factory ListPollsResponse.fromJson(Json json) =>
      _$ListPollsResponseFromJson(json);

  Json toJson() => _$ListPollsResponseToJson(this);
}
