import 'package:collection/collection.dart';
import 'package:postgres/postgres.dart';

extension PostgresExtension on PostgreSQLExecutionContext {
  String _value(dynamic value) {
    if (value is String) {
      return "'$value'";
    } else {
      return '$value';
    }
  }

  String _where(Map<String, dynamic> where) =>
      ' WHERE ${where.keys.map((e) => '$e = @$e').join(', ')}';

  Future<List<Map<String, dynamic>>> select(String table,
      {Map<String, dynamic>? where, String? orderBy}) async {
    var query = 'SELECT * FROM "${table.toLowerCase()}"';

    if (where != null) {
      query += _where(where);
    }

    if (orderBy != null) {
      query += ' ORDER BY $orderBy';
    }

    return (await mappedResultsQuery(query, substitutionValues: where))
        .map((e) => e[table.toLowerCase()])
        .whereNotNull()
        .toList(growable: false);
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final insertQuery = 'INSERT INTO '
        '"${table.toLowerCase()}" '
        '(${values.keys.map((e) => '"$e"').join(', ')}) '
        'VALUES (${values.values.map((value) => _value(value)).join(', ')}) '
        'RETURNING id';
    return ((await query(insertQuery)).lastOrNull?.firstOrNull as int?) ?? 0;
  }

  Future<int> update(String table, Map<String, dynamic> values,
      {required Map<String, dynamic> where}) async {
    final updateQuery = 'UPDATE "${table.toLowerCase()}" SET '
        '${values.entries.map((e) => '"${e.key}" = '
            '${_value(e.value)}').join(', ')}'
        '${_where(where)}';
    return (await query(updateQuery, substitutionValues: where))
        .affectedRowCount;
  }

  Future<int> delete(String table,
      {required Map<String, dynamic> where}) async {
    final deleteQuery = 'DELETE FROM $table${_where(where)}';
    return (await query(deleteQuery, substitutionValues: where))
        .affectedRowCount;
  }
}
