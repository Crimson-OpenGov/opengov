import 'dart:convert';

import 'package:opengov_common/actions/create_update.dart';
import 'package:opengov_common/actions/delete_poll.dart';
import 'package:opengov_common/actions/update_comment.dart';
import 'package:opengov_common/actions/update_reply.dart';
import 'package:opengov_common/models/announcement.dart';
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
      final dbResponse = await _connection.insert('poll', json);

      if (dbResponse > 0) {
        pollId = dbResponse;
        Firebase.sendNotification(
          title: 'New Poll',
          body: poll.topic,
          data: {'pollId': pollId},
        ).ignore();
      }
    } else {
      final dbResponse = await _connection
          .update('poll', poll.toJson(), where: {'id': poll.id});

      if (dbResponse > 0) {
        pollId = poll.id;
      }
    }

    return Response.ok(json.encode(CreateOrUpdateResponse(id: pollId)));
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
        .delete('poll', where: {'id': deletePollRequest.pollId});

    return genericResponse(success: dbResponse != 0);
  }

  /*@Route.post('/delete-comment')
  Future<Response> deleteComment(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user?.isNotAdmin ?? true) {
      return Response.forbidden(null);
    }

    final deleteCommentRequest =
        await request.readAsObject(DeleteCommentRequest.fromJson);

    final dbResponse = await _connection
        .delete('comment', where: {'id': deleteCommentRequest.commentId});

    return genericResponse(success: dbResponse != 0);
  }*/


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
          .delete('comment', where: {'id': updateCommentRequest.commentId});
    } else {
      dbResponse = await _connection.update('comment', {'is_approved': 1},
          where: {'id': updateCommentRequest.commentId});
    }

    return genericResponse(success: dbResponse != 0);
  }

  @Route.post('/update-reply')
  Future<Response> updateReply(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user?.isNotAdmin ?? true) {
      return Response.forbidden(null);
    }

    final updateReplyRequest =
        await request.readAsObject(UpdateReplyRequest.fromJson);

    int dbResponse;

    if (updateReplyRequest.action == UpdateReplyAction.delete) {
      dbResponse = await _connection
          .delete('reply', where: {'id': updateReplyRequest.replyId});
    } else {
      dbResponse = await _connection.update('reply', {'is_approved': 1},
          where: {'id': updateReplyRequest.replyId});
    }

    return genericResponse(success: dbResponse != 0);
  }


  @Route.post('/create-or-update-announcement')
  Future<Response> createOrUpdateAnnouncement(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user?.isNotAdmin ?? true) {
      return Response.forbidden(null);
    }

    final announcement = await request.readAsObject(Announcement.fromJson);
    int? announcementId;

    if (announcement.id == Announcement.noId) {
      final json = announcement.toJson()..remove('id');
      final dbResponse = await _connection.insert('announcement', json);

      if (dbResponse > 0) {
        announcementId = dbResponse;
        Firebase.sendNotification(
          title: 'New Announcement',
          body: announcement.title,
          data: {'announcementId': announcementId},
        ).ignore();
      }
    } else {
      final dbResponse = await _connection.update(
          'announcement', announcement.toJson(),
          where: {'id': announcement.id});

      if (dbResponse > 0) {
        announcementId = announcement.id;
      }
    }

    return Response.ok(json.encode(CreateOrUpdateResponse(id: announcementId)));
  }

  Router get router => _$AdminServiceRouter(this);
}
