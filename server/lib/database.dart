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
      'WHERE ${where.keys.map((e) => '$e = @$e').join(', ')}';

  Future<List<Map<String, dynamic>>> select(String table,
      {Map<String, dynamic>? where, String? orderBy}) async {
    assert(table.toLowerCase() == table);

    var query = [
      'SELECT * FROM "$table"',
      if (where != null) _where(where),
      if (orderBy != null) 'ORDER BY $orderBy',
    ];

    return (await mappedResultsQuery(query.join(' '),
            substitutionValues: where))
        .map((e) => e[table.toLowerCase()])
        .whereNotNull()
        .toList(growable: false);
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    assert(table.toLowerCase() == table);

    final insertQuery = [
      'INSERT INTO "$table"',
      '(${values.keys.map((e) => '"$e"').join(', ')})',
      'VALUES (${values.values.map((value) => _value(value)).join(', ')})',
      'RETURNING id',
    ];
    return ((await query(insertQuery.join(' '))).lastOrNull?.firstOrNull
            as int?) ??
        0;
  }

  Future<int> update(String table, Map<String, dynamic> values,
      {required Map<String, dynamic> where}) async {
    assert(table.toLowerCase() == table);

    final updateQuery = [
      'UPDATE "$table" SET',
      values.entries.map((e) => '"${e.key}" = ${_value(e.value)}').join(', '),
      _where(where),
    ];
    return (await query(updateQuery.join(' '), substitutionValues: where))
        .affectedRowCount;
  }

  Future<int> delete(String table,
      {required Map<String, dynamic> where}) async {
    assert(table.toLowerCase() == table);

    final deleteQuery = ['DELETE FROM "$table"', _where(where)];
    return (await query(deleteQuery.join(' '), substitutionValues: where))
        .affectedRowCount;
  }
}
