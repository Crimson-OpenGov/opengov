import 'dart:convert';
import 'dart:math';

import 'package:opengov_common/actions/login.dart';
import 'package:opengov_common/models/generic_response.dart';
import 'package:opengov_server/common.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqflite_common/sqlite_api.dart';

part 'auth_service.g.dart';

class AuthService {
  static final _random = Random.secure();

  final Database _database;

  const AuthService(this._database);

  @Route.post('/login')
  Future<Response> login(Request request) async {
    final loginRequest = await request.readAsObject(LoginRequest.fromJson);

    // Delete any current pending logins.
    await _database.delete('PendingLogin',
        where: 'username = ?', whereArgs: [loginRequest.username]);

    final success = await _database.insert('PendingLogin',
        {'username': loginRequest.username, 'code': _generateCode()});

    return Response.ok(json.encode(GenericResponse(success: success > 0)));
  }

  String _generateCode() => List.generate(4, (_) => _random.nextInt(10)).join();

  Router get router => _$AuthServiceRouter(this);
}
