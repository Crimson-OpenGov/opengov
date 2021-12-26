import 'dart:convert';
import 'dart:math';

import 'package:opengov_common/actions/login.dart';
import 'package:opengov_common/models/generic_response.dart';
import 'package:opengov_common/models/user.dart';
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

  @Route.post('/verify')
  Future<Response> verify(Request request) async {
    final verificationRequest =
        await request.readAsObject(VerificationRequest.fromJson);
    final username = verificationRequest.username;

    final numRowsDeleted = await _database.delete('PendingLogin',
        where: 'username = ? AND code = ?',
        whereArgs: [username, verificationRequest.code]);

    if (numRowsDeleted == 0) {
      return Response.ok(json.encode(VerificationResponse(token: null)));
    }

    User user;

    final existingUser = await _database.query('User',
        where: 'username = ?', whereArgs: [username]);

    if (existingUser.isNotEmpty) {
      user = User.fromJson(existingUser.first);
    } else {
      final userId = await _database
          .insert('User', {'username': username});
      user = User(id: userId, username: username);
    }

    return Response.ok(json.encode(VerificationResponse(token: user.username)));
  }

  String _generateCode() => List.generate(4, (_) => _random.nextInt(10)).join();

  Router get router => _$AuthServiceRouter(this);
}
