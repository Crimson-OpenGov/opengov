import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/generic_response.dart';
import 'package:opengov_common/models/token.dart';
import 'package:opengov_common/models/user.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

Response genericResponse({required bool success}) =>
    Response.ok(json.encode(GenericResponse(success: success)));

extension PostgresExtension on PostgreSQLExecutionContext {
  String _value(dynamic value) {
    if (value is String) {
      return "'$value'";
    } else {
      return '$value';
    }
  }

  String _where(String where, List<dynamic> whereArgs) {
    var i = 0;
    return ' WHERE '
        '${where.replaceAllMapped('?', (match) => _value(whereArgs[i++]))}';
  }

  Future<List<Map<String, dynamic>>> select(String table,
      {String? where, List<dynamic>? whereArgs, String? orderBy}) async {
    var query = 'SELECT * FROM "${table.toLowerCase()}"';

    if (where != null && whereArgs != null) {
      query += _where(where, whereArgs);
    }

    if (orderBy != null) {
      query += ' ORDER BY $orderBy';
    }

    return (await mappedResultsQuery(query))
        .map((e) => e[table.toLowerCase()])
        .whereNotNull()
        .toList(growable: false);
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final insertQuery = 'INSERT INTO '
        '"${table.toLowerCase()}" ${values.keys.map((e) => '"$e"')} '
        'VALUES ${values.values.map((value) => _value(value))}';
    return (await query(insertQuery)).affectedRowCount;
  }

  Future<int> update(String table, Map<String, dynamic> values,
      {required String where, required List<dynamic> whereArgs}) async {
    final updateQuery = 'UPDATE "${table.toLowerCase()}" SET '
        '${values.entries.map((e) => '"${e.key}" = '
            '${_value(e.value)}').join(', ')}'
        '${_where(where, whereArgs)}';
    return (await query(updateQuery)).affectedRowCount;
  }

  Future<int> delete(String table,
      {required String where, required List<dynamic> whereArgs}) async {
    final deleteQuery = 'DELETE FROM $table${_where(where, whereArgs)}';
    return (await query(deleteQuery)).affectedRowCount;
  }
}

extension RequestExtension on Request {
  Future<T> readAsObject<T>(FromJson<T> fromJson) async =>
      fromJson(json.decode(await readAsString()));

  Future<User?> decodeAuth(PostgreSQLConnection connection,
      {bool requireAdmin = false}) async {
    final authHeader = headers['Authorization'];

    if (authHeader != null) {
      final token = Token(value: authHeader.split(' ')[1]);
      var value = token.value;

      if (value.contains(':')) {
        // Old-style token in the format username:value.
        value = value.split(':')[1];
      }

      final response = await connection
          .select('User', where: 'token = ?', whereArgs: [token.value]);

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
