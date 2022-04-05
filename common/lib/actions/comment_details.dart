import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/models/reply.dart';

part 'comment_details.g.dart';

@JsonSerializable()
class CommentDetailsResponse {
  final Comment comment;
  final List<Reply> replies;

  CommentDetailsResponse({required this.comment, required this.replies});

  factory CommentDetailsResponse.fromJson(Json json) =>
      _$CommentDetailsResponseFromJson(json);

  Json toJson() => _$CommentDetailsResponseToJson(this);
}
