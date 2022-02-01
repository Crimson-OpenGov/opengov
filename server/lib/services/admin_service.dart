import 'dart:convert';

import 'package:opengov_common/actions/create_update_poll.dart';
import 'package:opengov_common/actions/delete_poll.dart';
import 'package:opengov_common/actions/update_comment.dart';
import 'package:opengov_common/models/poll.dart';
import 'package:opengov_server/common.dart';
import 'package:opengov_server/util/firebase.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'admin_service.g.dart';

class AdminService {
  final PostgreSQLConnection _connection;

  const AdminService(this._connection);

  @Route.post('/create-or-update-poll')
  Future<Response> createOrUpdatePoll(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user?.isNotAdmin ?? true) {
      return Response.forbidden(null);
    }

    final poll = await request.readAsObject(Poll.fromJson);
    int? pollId;

    if (poll.id == Poll.noId) {
      final json = poll.toJson()..remove('id');
      final dbResponse = await _connection.insert('Poll', json);

      if (dbResponse > 0) {
        pollId = dbResponse;
        Firebase.sendNotification(title: 'New Poll', body: poll.topic).ignore();
      }
    } else {
      final dbResponse = await _connection
          .update('Poll', poll.toJson(), where: {'id': poll.id});

      if (dbResponse > 0) {
        pollId = poll.id;
      }
    }

    return Response.ok(json.encode(CreateOrUpdatePollResponse(pollId: pollId)));
  }

  @Route.post('/delete-poll')
  Future<Response> deletePoll(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user?.isNotAdmin ?? true) {
      return Response.forbidden(null);
    }

    final deletePollRequest =
        await request.readAsObject(DeletePollRequest.fromJson);

    final dbResponse = await _connection
        .delete('Poll', where: {'id': deletePollRequest.pollId});

    return genericResponse(success: dbResponse != 0);
  }

  @Route.post('/update-comment')
  Future<Response> updateComment(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user?.isNotAdmin ?? true) {
      return Response.forbidden(null);
    }

    final updateCommentRequest =
        await request.readAsObject(UpdateCommentRequest.fromJson);

    int dbResponse;

    if (updateCommentRequest.action == UpdateCommentAction.delete) {
      dbResponse = await _connection
          .delete('Comment', where: {'id': updateCommentRequest.commentId});
    } else {
      dbResponse = await _connection.update('Comment', {'is_approved': 1},
          where: {'id': updateCommentRequest.commentId});
    }

    return genericResponse(success: dbResponse != 0);
  }

  Router get router => _$AdminServiceRouter(this);
}
