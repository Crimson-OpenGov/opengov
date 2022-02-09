import 'dart:convert';

import 'package:opengov_common/actions/list_announcements.dart';
import 'package:opengov_common/models/announcement.dart';
import 'package:opengov_common/models/poll.dart';
import 'package:opengov_server/common.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'announcement_service.g.dart';

class AnnouncementService {
  final PostgreSQLConnection _connection;

  const AnnouncementService(this._connection);

  @Route.get('/list')
  Future<Response> listAnnouncement(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }

    final announcementResponse = (await _connection.select('announcement'))
        .map(Announcement.fromJson)
        .toList(growable: false);

    final announcementToPoll = <int, Poll>{};
    for (final announcement in announcementResponse) {
      if (announcement.pollId != null) {
        final poll = Poll.fromJson((await _connection
                .select('poll', where: {'id': announcement.pollId}))
            .single);
        announcementToPoll[announcement.id] = poll;
      }
    }

    return Response.ok(json.encode(ListAnnouncementsResponse(
        announcements: announcementResponse,
        announcementToPoll: announcementToPoll)));
  }

  Router get router => _$AnnouncementServiceRouter(this);
}
