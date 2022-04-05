// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyReport _$ReplyReportFromJson(Map<String, dynamic> json) => ReplyReport(
      replies: (json['replies'] as List<dynamic>)
          .map((e) => Reply.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReplyReportToJson(ReplyReport instance) =>
    <String, dynamic>{
      'replies': instance.replies,
    };
