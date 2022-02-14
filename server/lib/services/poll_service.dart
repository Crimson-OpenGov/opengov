import 'dart:convert';

import 'package:opengov_common/actions/add_comment.dart';
import 'package:opengov_common/actions/list_polls.dart';
import 'package:opengov_common/actions/poll_details.dart';
import 'package:opengov_common/actions/vote.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/models/poll.dart';
import 'package:opengov_common/models/report.dart';
import 'package:opengov_common/models/vote.dart';
import 'package:opengov_server/common.dart';
import 'package:opengov_server/environment.dart';
import 'package:opengov_server/util/curse_words.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'poll_service.g.dart';

class PollService {
  final PostgreSQLConnection _connection;

  const PollService(this._connection);

  static const _pollCommentsQuery = 'select *, '
      '(100 * pow(.8, div(@today - c.timestamp, 86400000)) + '
      '(select count(*) as vote_count from vote v where v.comment_id = c.id)) '
      'as score from comment c where c.poll_id = @poll_id order by score desc';

  @Route.get('/list')
  Future<Response> listPolls(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }

    final pollsResponse = (await _connection.select('poll'))
        .map(Poll.fromJson)
        .where((poll) =>
            user.token != 'appleTest' ||
            !poll.topic.toLowerCase().contains('covid'))
        .toList(growable: false);

    return Response.ok(json.encode(ListPollsResponse(polls: pollsResponse)));
  }

  @Route.get('/details/<pollId>')
  Future<Response> getPollDetails(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }

    final pollId = int.parse(request.params['pollId']!);

    // Fetch all of the IDs of comments that the user voted on.
    final votedCommentIds =
        (await _connection.select('vote', where: {'user_id': user.id}))
            .map(Vote.fromJson)
            .map((vote) => vote.commentId)
            .toSet();

    // Fetch all comments.
    final commentsResponse = (await _connection.query(
      _pollCommentsQuery,
      substitutionValues: {
        'today': DateTime.now().millisecondsSinceEpoch,
        'poll_id': pollId
      },
    ))
        .mapRows(Comment.fromJson)
        .where((comment) => user.isAdmin || comment.isApproved);

    // For all comments the user has voted on, fetch the report details.
    final comments = await Future.wait(commentsResponse.map((comment) async =>
        votedCommentIds.contains(comment.id)
            ? await _addStats(comment)
            : comment));

    return Response.ok(json.encode(PollDetailsResponse(comments: comments)));
  }

  @Route.get('/comment/<commentId>')
  Future<Response> getCommentDetails(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }

    final commentId = int.parse(request.params['commentId']!);
    final commentResponse = Comment.fromJson(
        (await _connection.select('comment', where: {'id': commentId})).single);
    final comment = await _addStats(commentResponse);

    return Response.ok(json.encode(comment));
  }

  @Route.get('/report/<pollId>')
  Future<Response> getReport(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }

    final pollId = int.parse(request.params['pollId']!);

    final commentsResponse =
        (await _connection.select('comment', where: {'poll_id': pollId}))
            .map(Comment.fromJson)
            .where((comment) => user.isAdmin || comment.isApproved);

    final comments = await Future.wait(commentsResponse.map(_addStats));

    return Response.ok(json.encode(Report(comments: comments)));
  }

  @Route.post('/add-comment')
  Future<Response> addComment(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }

    final addCommentRequest =
        await request.readAsObject(AddCommentRequest.fromJson);

    if (CurseWords.isBadString(addCommentRequest.comment)) {
      return Response.ok(json.encode(const AddCommentResponse(
          reason: AddCommentResponseReason.curseWords)));
    }

    final pollsResponse = (await _connection
            .select('poll', where: {'id': addCommentRequest.pollId}))
        .map(Poll.fromJson);

    if (pollsResponse.isEmpty) {
      return Response.ok(json.encode(
          const AddCommentResponse(reason: AddCommentResponseReason.error)));
    }

    final poll = pollsResponse.first;

    if (!poll.isActive) {
      return Response.ok(json.encode(
          const AddCommentResponse(reason: AddCommentResponseReason.error)));
    }

    final dbResponse = await _connection.insert('comment', {
      'poll_id': poll.id,
      'user_id': user.id,
      'comment': addCommentRequest.comment,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      if (!enforceModeration) 'is_approved': true,
    });

    if (dbResponse == 0) {
      return Response.ok(json.encode(
          const AddCommentResponse(reason: AddCommentResponseReason.error)));
    }

    return Response.ok(json.encode(AddCommentResponse(
        reason: enforceModeration
            ? AddCommentResponseReason.needsApproval
            : AddCommentResponseReason.approved)));
  }

  @Route.post('/vote')
  Future<Response> vote(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }

    final voteRequest = await request.readAsObject(VoteRequest.fromJson);

    final dbResponse = await _connection.insert('vote', {
      'user_id': user.id,
      'comment_id': voteRequest.commentId,
      'score': voteRequest.score,
      if (voteRequest.reason != null) 'reason': voteRequest.reason,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    return genericResponse(success: dbResponse != 0);
  }

  Future<Comment> _addStats(Comment comment) async {
    final votesResponse =
        (await _connection.select('vote', where: {'comment_id': comment.id}))
            .map(Vote.fromJson);

    return comment.copyWith(
      stats: CommentStats(
        agreeCount: votesResponse.where((vote) => vote.score == 1).length,
        disagreeCount: votesResponse.where((vote) => vote.score == -1).length,
        passCount: votesResponse.where((vote) => vote.score == 0).length,
      ),
    );
  }

  Router get router => _$PollServiceRouter(this);
}
