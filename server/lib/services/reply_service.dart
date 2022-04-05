import 'dart:convert';

import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/models/reply.dart';
import 'package:opengov_server/common.dart';
import 'package:opengov_server/environment.dart';
import 'package:opengov_server/util/curse_words.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:opengov_common/models/reply_report.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:opengov_common/models/vote_reply.dart';
import 'package:opengov_common/actions/comment_details.dart';
import 'package:opengov_common/actions/add_reply.dart';
import 'package:opengov_common/actions/vote_reply.dart';
import 'package:opengov_common/models/vote_reply.dart';

part 'reply_service.g.dart';

class ReplyService {

  final PostgreSQLConnection _connection;

  const ReplyService(this._connection);

  @Route.get('/<commentId>')
  Future<Response> getCommentReplies(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }
    
    final commentId = int.parse(request.params['commentId']!);

    final comment = Comment.fromJson(
      (await _connection.select('comment', where: {'id': commentId})).single);

    // Fetch all of the IDs of replies the user has voted on.
    final votedReplyIds =
        (await _connection.select('votereply', where: {'user_id': user.id}))
            .map(VoteReply.fromJson)
            .map((vote) => vote.replyId)
            .toSet();

    // Fetch all replies
    final repliesResponse = (await _connection.select(
        'reply', where: {'comment_id': commentId}
    )).map(Reply.fromJson).where((reply) => user.isAdmin || reply.isApproved);

    // For all replies the user has voted on, fetch the report details.
    final replies = await Future.wait(repliesResponse.map((reply) async =>
        votedReplyIds.contains(reply.id)
            ? await _addStats(reply)
            : reply));

    return Response.ok(json.encode(CommentDetailsResponse(comment:comment, replies:replies)));
  }

  @Route.post('/add-reply')
  Future<Response> addReply(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }

    final addReplyRequest =
        await request.readAsObject(AddReplyRequest.fromJson);

    if (CurseWords.isBadString(addReplyRequest.reply)) {
      return Response.ok(json.encode(const AddReplyResponse(
          reason: AddReplyResponseReason.curseWords)));
    }

    final commentResponse = (await _connection
        .select('comment', where: {'id': addReplyRequest.commentId}))
        .map(Comment.fromJson);

    if (commentResponse.isEmpty) {
      return Response.ok(json.encode(
          const AddReplyResponse(reason: AddReplyResponseReason.error)));
    }

    final comment = commentResponse.first;
    
    final dbResponse = await _connection.insert('reply', {
      'comment_id': comment.id,
      'user_id': user.id,
      'reply': addReplyRequest.reply,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      if (!enforceModeration) 'is_approved': true,
    });

    if (dbResponse == 0) {
      return Response.ok(json.encode(
          const AddReplyResponse(reason: AddReplyResponseReason.error)));
    }

    return Response.ok(json.encode(AddReplyResponse(
        reason: enforceModeration
            ? AddReplyResponseReason.needsApproval
            : AddReplyResponseReason.approved)));
  }

  @Route.post('/vote-reply')
  Future<Response> voteReply(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }

    final voteReplyRequest = await request.readAsObject(VoteReplyRequest.fromJson);

    await _connection.delete('votereply',
        where: {'user_id': user.id, 'reply_id': voteReplyRequest.replyId});

    final dbResponse = await _connection.insert('votereply', {
      'user_id': user.id,
      'reply_id': voteReplyRequest.replyId,
      'score': voteReplyRequest.score,
      if (voteReplyRequest.reason != null) 'reason': voteReplyRequest.reason,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    return genericResponse(success: dbResponse != 0);
  }

  @Route.get('/reply/<replyId>')
  Future<Response> getReplyDetails(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }

    final replyId = int.parse(request.params['replyId']!);
    final replyResponse = Reply.fromJson(
        (await _connection.select('reply', where: {'id': replyId})).single);
    final reply = await _addStats(replyResponse);

    return Response.ok(json.encode(reply));
  }

  @Route.get('/report/<commentId>')
  Future<Response> getReplyReport(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }

    final commentId = int.parse(request.params['commentId']!);

    final repliesResponse =
        (await _connection.select('reply', where: {'comment_id': commentId}))
            .map(Reply.fromJson)
            .where((reply) => user.isAdmin || reply.isApproved);

    final replies = await Future.wait(repliesResponse.map(_addStats));

    return Response.ok(json.encode(ReplyReport(replies: replies)));
  }
  
  Future<Reply> _addStats(Reply reply) async {    
    final votesResponse =
    (await _connection.select('votereply', where: {'reply_id': reply.id}))
    .map(VoteReply.fromJson);
    
    return reply.copyWith(
      stats: ReplyStats(
        agreeCount: votesResponse.where((vote) => vote.score == 1).length,
        disagreeCount: votesResponse.where((vote) => vote.score == -1).length,
        passCount: votesResponse.where((vote) => vote.score == 0).length,
      ),
    );
  }
  
  Router get router => _$ReplyServiceRouter(this);
}
