import 'dart:convert';
import 'dart:math';

import 'package:opengov_common/actions/login.dart';
import 'package:opengov_common/models/token.dart';
import 'package:opengov_server/common.dart';
import 'package:opengov_server/util/email_service.dart';
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
    final username = loginRequest.username;

    // Delete any current pending logins.
    await _database
        .delete('PendingLogin', where: 'username = ?', whereArgs: [username]);

    final code = _generateCode();
    final success = await _database
        .insert('PendingLogin', {'username': username, 'code': code});
    final emailSuccess = await EmailService.sendVerificationEmail(username, code);

    return genericResponse(success: success > 0 && emailSuccess);
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

    final existingUser = await _database
        .query('User', where: 'username = ?', whereArgs: [username]);

    if (existingUser.isEmpty) {
      final userId = await _database.insert('User', {'username': username});

      if (userId <= 0) {
        return Response.internalServerError();
      }
    }

    final token = Token.generate(username, secretKey);
    return Response.ok(
        json.encode(VerificationResponse(token: token.toString())));
  }

  String _generateCode() => List.generate(4, (_) => _random.nextInt(10)).join();

  Router get router => _$AuthServiceRouter(this);
}
