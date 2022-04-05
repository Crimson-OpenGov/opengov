import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'add_reply.g.dart';

@JsonSerializable()
class AddReplyRequest {
  final int commentId;
  final String reply;

  const AddReplyRequest({required this.commentId, required this.reply});

  factory AddReplyRequest.fromJson(Json json) =>
      _$AddReplyRequestFromJson(json);

  Json toJson() => _$AddReplyRequestToJson(this);
}

enum AddReplyResponseReason { curseWords, error, needsApproval, approved }

@JsonSerializable()
class AddReplyResponse {
  final AddReplyResponseReason reason;

  const AddReplyResponse({required this.reason});

  factory AddReplyResponse.fromJson(Json json) =>
      _$AddReplyResponseFromJson(json);

  Json toJson() => _$AddReplyResponseToJson(this);
}
