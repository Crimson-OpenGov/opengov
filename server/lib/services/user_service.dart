import 'dart:convert';

import 'package:opengov_server/common.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'user_service.g.dart';

class UserService {
  final PostgreSQLConnection _connection;

  const UserService(this._connection);

  @Route.get('/me')
  Future<Response> getMe(Request request) async {
    final user = await request.decodeAuth(_connection);

    if (user == null) {
      return Response.forbidden(null);
    }

    return Response.ok(json.encode(user));
  }

  Router get router => _$UserServiceRouter(this);
}
