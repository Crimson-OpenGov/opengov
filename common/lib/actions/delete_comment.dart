import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'delete_comment.g.dart';

@JsonSerializable()
class DeleteCommentRequest {
  final int commentId;

  const DeleteCommentRequest({required this.commentId});

  factory DeleteCommentRequest.fromJson(Json json) =>
      _$DeleteCommentRequestFromJson(json);

  Json toJson() => _$DeleteCommentRequestToJson(this);
}
