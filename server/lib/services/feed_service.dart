import 'dart:convert';

import 'package:opengov_common/actions/feed.dart';
import 'package:opengov_server/common.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'feed_service.g.dart';

class FeedService {
  final PostgreSQLConnection _connection;

  const FeedService(this._connection);

  static const _randomFeedQuery =
      'select c.id, p.id as poll_id, c.comment, p.topic as poll_topic, '
      'p.emoji as poll_emoji '
      'from comment c tablesample SYSTEM_ROWS(10) '
      'join poll p on c.poll_id = p.id '
      'where p.end > @now and (select count(1) from vote v '
      'where v.user_id = @user_id and v.comment_id = c.id) = 0';

  @Route.get('/random')
  Future<Response> getRandomFeed(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }

    final commentsResponse = (await _connection.query(
      _randomFeedQuery,
      substitutionValues: {
        'user_id': user.id,
        'now': DateTime.now().millisecondsSinceEpoch,
      },
    ))
        .mapRows(FeedComment.fromJson)
        .toList(growable: false);

    return Response.ok(json.encode(FeedResponse(comments: commentsResponse)));
  }

  Router get router => _$FeedServiceRouter(this);
}
