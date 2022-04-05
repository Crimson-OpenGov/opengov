import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'update_reply.g.dart';

enum UpdateReplyAction { delete, approve }

@JsonSerializable()
class UpdateReplyRequest {
  final int replyId;
  final UpdateReplyAction action;

  const UpdateReplyRequest({required this.replyId, required this.action});

  factory UpdateReplyRequest.fromJson(Json json) =>
      _$UpdateReplyRequestFromJson(json);

  Json toJson() => _$UpdateReplyRequestToJson(this);
}
