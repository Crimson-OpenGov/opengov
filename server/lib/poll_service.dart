import 'dart:convert';

import 'package:opengov_common/actions/add_comment.dart';
import 'package:opengov_common/actions/list_polls.dart';
import 'package:opengov_common/actions/poll_details.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/models/generic_response.dart';
import 'package:opengov_common/models/poll.dart';
import 'package:opengov_server/common.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqflite_common/sqlite_api.dart';

part 'poll_service.g.dart';

class PollService {
  final Database _database;

  const PollService(this._database);

  @Route.get('/list')
  Future<Response> listPolls(Request request) async {
    if (await request.decodeAuth(_database) == null) {
      return Response.forbidden(null);
    }

    final pollsResponse = (await _database.query('Poll'))
        .map(Poll.fromJson)
        .toList(growable: false);

    return Response.ok(json.encode(ListPollsResponse(polls: pollsResponse)));
  }

  @Route.get('/details/<pollId>')
  Future<Response> getPollDetails(Request request) async {
    if (await request.decodeAuth(_database) == null) {
      return Response.forbidden(null);
    }

    final pollId = int.parse(request.params['pollId']!);

    final commentsResponse = (await _database
            .query('Comment', where: 'poll_id = ?', whereArgs: [pollId]))
        .map(Comment.fromJson)
        .toList(growable: false);

    return Response.ok(
        json.encode(PollDetailsResponse(comments: commentsResponse)));
  }

  @Route.post('/add-comment')
  Future<Response> addComment(Request request) async {
    final user = await request.decodeAuth(_database);

    if (user == null) {
      return Response.forbidden(null);
    }

    final addCommentRequest =
        await request.readAsObject(AddCommentRequest.fromJson);

    final dbResponse = await _database.insert('Comment', {
      'poll_id': addCommentRequest.pollId,
      'user_id': user.id,
      'comment': addCommentRequest.comment,
    });

    return Response.ok(json.encode(GenericResponse(success: dbResponse != 0)));
  }

  Router get router => _$PollServiceRouter(this);
}
