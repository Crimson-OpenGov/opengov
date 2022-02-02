import 'dart:convert';

import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/generic_response.dart';
import 'package:opengov_common/models/token.dart';
import 'package:opengov_common/models/user.dart';
import 'package:opengov_server/database.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

export 'database.dart';

Response genericResponse({required bool success}) =>
    Response.ok(json.encode(GenericResponse(success: success)));

extension RequestExtension on Request {
  Future<T> readAsObject<T>(FromJson<T> fromJson) async =>
      fromJson(json.decode(await readAsString()));

  Future<User?> decodeAuth(PostgreSQLConnection connection,
      {bool requireAdmin = false}) async {
    final authHeader = headers['Authorization'];

    if (authHeader != null) {
      final token = Token(value: authHeader.split(' ')[1]);
      // For new tokens, tokenValue will be the whole thing, but for old tokens,
      // we want to strip out the plaintext username.
      final tokenValue = token.value.substring(token.value.indexOf(':'));
      final response =
          await connection.select('user', where: {'token': tokenValue});

      if (response.isEmpty) {
        return null;
      }

      final user = User.fromJson(response.first);
      if (!requireAdmin || user.isAdmin) {
        return user;
      }
    }
  }
}
