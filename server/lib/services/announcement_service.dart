import 'dart:convert';

import 'package:opengov_common/actions/list_announcements.dart';
import 'package:opengov_server/common.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'announcement_service.g.dart';

class AnnouncementService {
  final PostgreSQLConnection _connection;

  const AnnouncementService(this._connection);

  static const listAnnouncementsQuery =
      'select a.*, p.emoji as poll_emoji from announcement a '
      'join poll p on p.id = a.poll_id';

  @Route.get('/list')
  Future<Response> listAnnouncement(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }

    final announcementResponse =
        (await _connection.query(listAnnouncementsQuery))
            .map((row) => ListedAnnouncement.fromJson(row.toColumnMap()))
            .toList(growable: false);

    return Response.ok(json.encode(
        ListAnnouncementsResponse(announcements: announcementResponse)));
  }

  Router get router => _$AnnouncementServiceRouter(this);
}
