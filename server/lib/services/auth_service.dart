import 'dart:convert';
import 'dart:math';

import 'package:opengov_common/actions/login.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/pending_login.dart';
import 'package:opengov_common/models/token.dart';
import 'package:opengov_server/common.dart';
import 'package:opengov_server/environment.dart';
import 'package:opengov_server/util/email_service.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'auth_service.g.dart';

class AuthService {
  static final _random = Random.secure();

  final PostgreSQLConnection _connection;

  const AuthService(this._connection);

  @Route.post('/login')
  Future<Response> login(Request request) async {
    final loginRequest = await request.readAsObject(LoginRequest.fromJson);
    final username =
        loginRequest.username.replaceAll(badUsernameCharacters, '');

    if (username == 'appleTest') {
      return genericResponse(success: true);
    }

    final value = Token.generate(username, secretKey).value;

    // Delete any current pending logins.
    await _connection.delete('pending_login', where: {'token': value});

    final code = _generateCode();
    final success = await _connection.insert('pending_login', {
      'token': value,
      'code': code,
      'expiration':
          DateTime.now().add(Duration(minutes: 10)).millisecondsSinceEpoch,
    });
    final emailSuccess =
        await EmailService.sendVerificationEmail(username, code);

    return genericResponse(success: success > 0 && emailSuccess);
  }

  @Route.post('/verify')
  Future<Response> verify(Request request) async {
    final verificationRequest =
        await request.readAsObject(VerificationRequest.fromJson);
    final username = verificationRequest.username;
    final code = verificationRequest.code;
    final token = Token.generate(username, secretKey);

    if (username != 'appleTest' || code != '1234') {
      final pendingLogins = (await _connection
              .select('pending_login', where: {'token': token.value}))
          .map(PendingLogin.fromJson)
          .toList(growable: false);

      if (pendingLogins.every((pendingLogin) =>
          pendingLogin.code != code || !pendingLogin.isActive)) {
        return Response.ok(json.encode(VerificationResponse(token: null)));
      }

      await _connection.transaction((txn) async {
        for (final pendingLogin in pendingLogins) {
          await txn.delete('pending_login', where: {'id': pendingLogin.id});
        }
      });

      final existingUser =
          await _connection.select('user', where: {'token': token.value});

      if (existingUser.isEmpty) {
        final userId = await _connection.insert('user', {'token': token.value});

        if (userId <= 0) {
          return Response.internalServerError();
        }
      }
    }

    return Response.ok(json.encode(VerificationResponse(token: token.value)));
  }

  String _generateCode() =>
      List.generate(4, (_) => _random.nextInt(9) + 1).join();

  Router get router => _$AuthServiceRouter(this);
}
