import 'dart:convert';

import 'package:opengov_common/actions/add_comment.dart';
import 'package:opengov_common/actions/list_polls.dart';
import 'package:opengov_common/actions/poll_details.dart';
import 'package:opengov_common/actions/vote.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/models/poll.dart';
import 'package:opengov_common/models/vote.dart';
import 'package:opengov_server/common.dart';
import 'package:opengov_server/util/curse_words.dart';
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
    final user = await request.decodeAuth(_database);

    if (user == null) {
      return Response.forbidden(null);
    }

    final pollId = int.parse(request.params['pollId']!);

    // Fetch all of the comments that the user voted on.
    final votedCommentIds = (await _database
            .query('Vote', where: 'user_id = ?', whereArgs: [user.id]))
        .map(Vote.fromJson)
        .map((vote) => vote.commentId)
        .toSet();

    // Fetch all comments that the user hasn't voted on yet.
    final commentsResponse = (await _database
            .query('Comment', where: 'poll_id = ?', whereArgs: [pollId]))
        .map(Comment.fromJson)
        .where((comment) => !votedCommentIds.contains(comment.id))
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

    if (CurseWords.isBadString(addCommentRequest.comment)) {
      return genericResponse(success: false);
    }

    final pollsResponse = (await _database.query('Poll',
            where: 'id = ?', whereArgs: [addCommentRequest.pollId]))
        .map(Poll.fromJson);

    if (pollsResponse.isEmpty) {
      return genericResponse(success: false);
    }

    final poll = pollsResponse.first;

    if (!poll.isActive) {
      return genericResponse(success: false);
    }

    final dbResponse = await _database.insert('Comment', {
      'poll_id': poll.id,
      'user_id': user.id,
      'comment': addCommentRequest.comment,
    });

    return genericResponse(success: dbResponse != 0);
  }

  @Route.post('/vote')
  Future<Response> vote(Request request) async {
    final user = await request.decodeAuth(_database);

    if (user == null) {
      return Response.forbidden(null);
    }

    final voteRequest = await request.readAsObject(VoteRequest.fromJson);

    final dbResponse = await _database.insert('Vote', {
      'user_id': user.id,
      'comment_id': voteRequest.commentId,
      'score': voteRequest.score
    });

    return genericResponse(success: dbResponse != 0);
  }

  Router get router => _$PollServiceRouter(this);
}
