// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_polls.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListPollsResponse _$ListPollsResponseFromJson(Map<String, dynamic> json) =>
    ListPollsResponse(
      polls: (json['polls'] as List<dynamic>)
          .map((e) => Poll.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListPollsResponseToJson(ListPollsResponse instance) =>
    <String, dynamic>{
      'polls': instance.polls,
    };
