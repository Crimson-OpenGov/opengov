import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/comment.dart';

part 'report.g.dart';

@JsonSerializable()
class Report {
  final List<Comment> comments;

  const Report({required this.comments});

  factory Report.fromJson(Json json) => _$ReportFromJson(json);

  Json toJson() => _$ReportToJson(this);
}
