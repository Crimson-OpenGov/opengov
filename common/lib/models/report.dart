import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';

part 'report.g.dart';

@JsonSerializable()
class Report {
  final List<ReportComment> comments;

  const Report({required this.comments});

  factory Report.fromJson(Json json) => _$ReportFromJson(json);

  Json toJson() => _$ReportToJson(this);
}

@JsonSerializable()
class ReportComment {
  @JsonKey(name: 'comment_id')
  final int commentId;

  final String comment;
  final int agreeCount;
  final int disagreeCount;
  final int passCount;

  @JsonKey(name: 'is_approved', fromJson: boolFromJson, toJson: boolToJson)
  final bool isApproved;

  const ReportComment({
    required this.commentId,
    required this.comment,
    required this.agreeCount,
    required this.disagreeCount,
    required this.passCount,
    required this.isApproved,
  });

  factory ReportComment.fromJson(Json json) => _$ReportCommentFromJson(json);

  Json toJson() => _$ReportCommentToJson(this);
}
