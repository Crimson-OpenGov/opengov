import 'package:collection/collection.dart';
import 'package:postgres/postgres.dart';

extension PostgresExtension on PostgreSQLExecutionContext {
  Map<String, dynamic> _mergeMaps(
          {Map<String, dynamic>? where, Map<String, dynamic>? values}) =>
      {
        if (where != null)
          ...where.map((key, value) => MapEntry('${key}Where', value)),
        if (values != null)
          ...values.map((key, value) => MapEntry('${key}Value', value)),
      };

  String _listMap(Map<String, dynamic> map, String suffix) =>
      map.keys.map((e) => '"$e" = @$e$suffix').join(', ');

  Future<List<Map<String, dynamic>>> select(String table,
      {Map<String, dynamic>? where, String? orderBy}) async {
    assert(table.toLowerCase() == table);

    var query = [
      'SELECT * FROM "$table"',
      if (where != null) ...['WHERE', _listMap(where, 'Where')],
      if (orderBy != null) 'ORDER BY $orderBy',
    ];

    return (await mappedResultsQuery(query.join(' '),
            substitutionValues: _mergeMaps(where: where)))
        .map((e) => e[table.toLowerCase()])
        .whereNotNull()
        .toList(growable: false);
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    assert(table.toLowerCase() == table);

    final insertQuery = [
      'INSERT INTO "$table"',
      '(${values.keys.map((e) => '"$e"').join(', ')})',
      'VALUES (${values.keys.map((e) => '@${e}Value').join(', ')})',
      'RETURNING id',
    ];
    return ((await query(insertQuery.join(' '),
                substitutionValues: _mergeMaps(values: values)))
            .lastOrNull
            ?.firstOrNull as int?) ??
        0;
  }

  Future<int> update(String table, Map<String, dynamic> values,
      {required Map<String, dynamic> where}) async {
    assert(table.toLowerCase() == table);

    final updateQuery = [
      'UPDATE "$table" SET',
      _listMap(values, 'Value'),
      'WHERE',
      _listMap(where, 'Where'),
    ];
    return (await query(updateQuery.join(' '),
            substitutionValues: _mergeMaps(where: where, values: values)))
        .affectedRowCount;
  }

  Future<int> delete(String table,
      {required Map<String, dynamic> where}) async {
    assert(table.toLowerCase() == table);

    final deleteQuery = [
      'DELETE FROM "$table" WHERE',
      _listMap(where, 'Where'),
    ];
    return (await query(deleteQuery.join(' '),
            substitutionValues: _mergeMaps(where: where)))
        .affectedRowCount;
  }
}

extension PostgresResultExtension on PostgreSQLResult {
  Iterable<T> mapRows<T>(T Function(Map<String, dynamic> e) toElement) =>
      map((e) => toElement(e.toColumnMap()));
}
