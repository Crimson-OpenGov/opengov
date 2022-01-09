import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'update_comment.g.dart';

enum UpdateCommentAction { delete, approve }

@JsonSerializable()
class UpdateCommentRequest {
  final int commentId;
  final UpdateCommentAction action;

  const UpdateCommentRequest({required this.commentId, required this.action});

  factory UpdateCommentRequest.fromJson(Json json) =>
      _$UpdateCommentRequestFromJson(json);

  Json toJson() => _$UpdateCommentRequestToJson(this);
}
