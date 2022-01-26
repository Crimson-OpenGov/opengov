import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'delete_poll.g.dart';

@JsonSerializable()
class DeletePollRequest {
  final int pollId;

  const DeletePollRequest({required this.pollId});

  factory DeletePollRequest.fromJson(Json json) =>
      _$DeletePollRequestFromJson(json);

  Json toJson() => _$DeletePollRequestToJson(this);
}
