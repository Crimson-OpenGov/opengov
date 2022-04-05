import 'package:json_annotation/json_annotation.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/reply.dart';

part 'reply_report.g.dart';

@JsonSerializable()
class ReplyReport {
  final List<Reply> replies;

  const ReplyReport({required this.replies});

  factory ReplyReport.fromJson(Json json) => _$ReplyReportFromJson(json);

  Json toJson() => _$ReplyReportToJson(this);
}
