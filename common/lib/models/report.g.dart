// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      comments: (json['comments'] as List<dynamic>)
          .map((e) => ReportComment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'comments': instance.comments,
    };

ReportComment _$ReportCommentFromJson(Map<String, dynamic> json) =>
    ReportComment(
      commentId: json['comment_id'] as int,
      comment: json['comment'] as String,
      agreeCount: json['agreeCount'] as int,
      disagreeCount: json['disagreeCount'] as int,
      passCount: json['passCount'] as int,
      isApproved: boolFromJson(json['is_approved'] as int),
    );

Map<String, dynamic> _$ReportCommentToJson(ReportComment instance) =>
    <String, dynamic>{
      'comment_id': instance.commentId,
      'comment': instance.comment,
      'agreeCount': instance.agreeCount,
      'disagreeCount': instance.disagreeCount,
      'passCount': instance.passCount,
      'is_approved': boolToJson(instance.isApproved),
    };
