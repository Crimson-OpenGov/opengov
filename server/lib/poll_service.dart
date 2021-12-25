import 'dart:convert';

import 'package:opengov_common/actions/list_polls.dart';
import 'package:opengov_common/actions/poll_details.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/models/poll.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqflite_common/sqlite_api.dart';

part 'poll_service.g.dart';

class PollService {
  final Database _database;

  const PollService(this._database);

  @Route.get('/list')
  Future<Response> listPolls(Request request) async {
    final pollsResponse = (await _database.query('Poll'))
        .map(Poll.fromJson)
        .toList(growable: false);

    return Response.ok(json.encode(ListPollsResponse(polls: pollsResponse)));
  }

  @Route.get('/details/<pollId>')
  Future<Response> getPollDetails(Request request) async {
    final pollId = int.parse(request.params['pollId']!);
    print((await _database
        .query('Comment', where: 'poll_id = ?', whereArgs: [pollId])));
    final commentsResponse = (await _database
            .query('Comment', where: 'poll_id = ?', whereArgs: [pollId]))
        .map(Comment.fromJson)
        .toList(growable: false);

    return Response.ok(
        json.encode(PollDetailsResponse(comments: commentsResponse)));
  }

  Router get router => _$PollServiceRouter(this);
}
