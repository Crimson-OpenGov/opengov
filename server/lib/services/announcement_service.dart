import 'dart:convert';

import 'package:opengov_common/actions/announcement_details.dart';
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

  static const _listAnnouncementsQuery =
      'select a.*, p.emoji as poll_emoji from announcement a '
      'left join poll p on p.id = a.poll_id order by a.id desc';

  @Route.get('/list')
  Future<Response> listAnnouncement(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }

    final announcementResponse =
        (await _connection.query(_listAnnouncementsQuery))
            .mapRows(ListedAnnouncement.fromJson)
            .toList(growable: false);

    return Response.ok(json.encode(
        ListAnnouncementsResponse(announcements: announcementResponse)));
  }

  @Route.get('/details/<announcementId>')
  Future<Response> getAnnouncementDetails(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }

    final announcementId = int.parse(request.params['announcementId']!);

    final announcementResponse = Announcement.fromJson((await _connection
            .select('announcement', where: {'id': announcementId}))
        .single);
    Poll? poll;

    if (announcementResponse.pollId != null) {
      poll = Poll.fromJson((await _connection
              .select('poll', where: {'id': announcementResponse.pollId}))
          .single);
    }

    return Response.ok(json.encode(AnnouncementDetailsResponse(
        announcement: announcementResponse, poll: poll)));
  }

  Router get router => _$AnnouncementServiceRouter(this);
}
