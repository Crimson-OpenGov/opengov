import 'dart:convert';

import 'package:opengov_server/common.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqflite_common/sqlite_api.dart';

part 'user_service.g.dart';

class UserService {
  final Database _database;

  const UserService(this._database);

  @Route.get('/me')
  Future<Response> getMe(Request request) async {
    final user = await request.decodeAuth(_database);

    if (user == null) {
      return Response.forbidden(null);
    }

    return Response.ok(json.encode(user));
  }

  Router get router => _$UserServiceRouter(this);
}
