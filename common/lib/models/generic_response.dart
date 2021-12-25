import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'generic_response.g.dart';

@JsonSerializable()
class GenericResponse {
  final bool success;

  const GenericResponse({required this.success});

  factory GenericResponse.fromJson(Json json) =>
      _$GenericResponseFromJson(json);

  Json toJson() => _$GenericResponseToJson(this);
}
