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
  final String comment;
  final int agreeCount;
  final int disagreeCount;
  final int passCount;

  const ReportComment({
    required this.comment,
    required this.agreeCount,
    required this.disagreeCount,
    required this.passCount,
  });

  factory ReportComment.fromJson(Json json) => _$ReportCommentFromJson(json);

  Json toJson() => _$ReportCommentToJson(this);
}
