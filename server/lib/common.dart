import 'dart:convert';
import 'dart:io';

import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/generic_response.dart';
import 'package:opengov_common/models/token.dart';
import 'package:opengov_common/models/user.dart';
import 'package:shelf/shelf.dart';
import 'package:sqflite_common/sqlite_api.dart';

final secretKey = Platform.environment['SECRET_KEY']!;

/// Whether moderation is enforced.
///
/// If true, comments won't be visible until they are approved by a moderator.
/// If false, comments will be visible immediately and can be deleted later.
final enforceModeration =
    Platform.environment['ENFORCE_MODERATION']!.toLowerCase() == 'true';

Response genericResponse({required bool success}) =>
    Response.ok(json.encode(GenericResponse(success: success)));

extension RequestExtension on Request {
  Future<T> readAsObject<T>(FromJson<T> fromJson) async =>
      fromJson(json.decode(await readAsString()));

  Future<User?> decodeAuth(Database database,
      {bool requireAdmin = false}) async {
    final authHeader = headers['Authorization'];

    if (authHeader != null) {
      final token = Token(value: authHeader.split(' ')[1]);
      var value = token.value;

      if (value.contains(':')) {
        // Old-style token in the format username:value.
        value = value.split(':')[1];
      }

      final response = await database
          .query('User', where: 'token = ?', whereArgs: [token.value]);

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
