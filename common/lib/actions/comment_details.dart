import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/comment.dart';

part 'comment_details.g.dart';

@JsonSerializable()
class CommentDetailsResponse {
  final Comment parent;
  final List<Comment> messages;

  CommentDetailsResponse({required this.parent, required this.messages});

  factory CommentDetailsResponse.fromJson(Json json) =>
      _$CommentDetailsResponseFromJson(json);

  Json toJson() => _$CommentDetailsResponseToJson(this);
}
