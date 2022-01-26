import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'create_update_poll.g.dart';

@JsonSerializable()
class CreateOrUpdatePollResponse {
  /// The poll ID if the request was successful; null if the operation failed.
  final int? pollId;

  const CreateOrUpdatePollResponse({required this.pollId});

  factory CreateOrUpdatePollResponse.fromJson(Json json) =>
      _$CreateOrUpdatePollResponseFromJson(json);

  Json toJson() => _$CreateOrUpdatePollResponseToJson(this);
}
