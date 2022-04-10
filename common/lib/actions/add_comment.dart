import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'add_comment.g.dart';

@JsonSerializable()
class AddCommentRequest {
  final int pollId;
  final String comment;
  final int? parentId; //null if top-level comment
  
  const AddCommentRequest({required this.pollId, required this.comment, required this.parentId});

  factory AddCommentRequest.fromJson(Json json) =>
      _$AddCommentRequestFromJson(json);

  Json toJson() => _$AddCommentRequestToJson(this);
}

enum AddCommentResponseReason { curseWords, error, needsApproval, approved }

@JsonSerializable()
class AddCommentResponse {
  final AddCommentResponseReason reason;

  const AddCommentResponse({required this.reason});

  factory AddCommentResponse.fromJson(Json json) =>
      _$AddCommentResponseFromJson(json);

  Json toJson() => _$AddCommentResponseToJson(this);
}
