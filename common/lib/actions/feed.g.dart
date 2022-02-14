// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedComment _$FeedCommentFromJson(Map<String, dynamic> json) => FeedComment(
      id: json['id'] as int,
      pollId: json['poll_id'] as int,
      comment: json['comment'] as String,
      stats: json['stats'] == null
          ? null
          : CommentStats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FeedCommentToJson(FeedComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'poll_id': instance.pollId,
      'comment': instance.comment,
      'stats': instance.stats,
    };

FeedResponse _$FeedResponseFromJson(Map<String, dynamic> json) => FeedResponse(
      comments: (json['comments'] as List<dynamic>)
          .map((e) => FeedComment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeedResponseToJson(FeedResponse instance) =>
    <String, dynamic>{
      'comments': instance.comments,
    };
