import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'create_update.g.dart';

@JsonSerializable()
class CreateOrUpdateResponse {
  /// The entity ID if the request was successful; null if the operation failed.
  final int? id;

  const CreateOrUpdateResponse({required this.id});

  factory CreateOrUpdateResponse.fromJson(Json json) =>
      _$CreateOrUpdateResponseFromJson(json);

  Json toJson() => _$CreateOrUpdateResponseToJson(this);
}
