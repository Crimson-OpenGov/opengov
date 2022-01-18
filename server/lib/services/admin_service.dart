import 'dart:convert';

import 'package:opengov_common/actions/poll_details.dart';
import 'package:opengov_common/actions/update_comment.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/models/poll.dart';
import 'package:opengov_server/common.dart';
import 'package:opengov_server/util/firebase.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqflite_common/sqlite_api.dart';

part 'admin_service.g.dart';

class AdminService {
  final Database _database;

  const AdminService(this._database);

  @Route.post('/create-poll')
  Future<Response> createPoll(Request request) async {
    final user = await request.decodeAuth(_database);

    if (user?.isNotAdmin ?? true) {
      return Response.forbidden(null);
    }

    final poll = await request.readAsObject(Poll.fromJson);
    final json = poll.toJson()..remove('id');
    final dbResponse = await _database.insert('Poll', json);
    final success = dbResponse > 0;

    if (success) {
      Firebase.sendNotification(title: 'New Poll', body: poll.topic).ignore();
    }

    return genericResponse(success: success);
  }

  @Route.get('/poll-details/<pollId>')
  Future<Response> getPollDetails(Request request) async {
    final user = await request.decodeAuth(_database);

    if (user?.isNotAdmin ?? true) {
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

  @Route.post('/update-comment')
  Future<Response> updateComment(Request request) async {
    final user = await request.decodeAuth(_database);

    if (user?.isNotAdmin ?? true) {
      return Response.forbidden(null);
    }

    final updateCommentRequest =
        await request.readAsObject(UpdateCommentRequest.fromJson);

    int dbResponse;

    if (updateCommentRequest.action == UpdateCommentAction.delete) {
      dbResponse = await _database.delete('Comment',
          where: 'id = ?', whereArgs: [updateCommentRequest.commentId]);
    } else {
      dbResponse = await _database.update('Comment', {'is_approved': 1},
          where: 'id = ?', whereArgs: [updateCommentRequest.commentId]);
    }

    return genericResponse(success: dbResponse != 0);
  }

  Router get router => _$AdminServiceRouter(this);
}
