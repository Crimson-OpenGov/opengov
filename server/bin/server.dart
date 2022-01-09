import 'dart:io';

import 'package:opengov_server/services/auth_service.dart';
import 'package:opengov_server/services/poll_service.dart';
import 'package:opengov_server/services/user_service.dart';
import 'package:opengov_server/util/curse_words.dart';
import 'package:opengov_server/util/firebase.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main(List<String> args) async {
  sqfliteFfiInit();
  final database = await databaseFactoryFfi.openDatabase(
    '${Directory.current.path}/db.sqlite3',
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, _) async {
        await db.execute('CREATE TABLE Poll (id INTEGER PRIMARY KEY, '
            'topic TEXT NOT NULL, description TEXT, end INTEGER NOT NULL)');
        await db.execute('CREATE TABLE Comment (id INTEGER PRIMARY KEY, '
            'poll_id INTEGER NOT NULL, user_id INTEGER, comment TEXT NOT NULL, '
            'is_approved BOOLEAN NOT NULL DEFAULT FALSE)');
        await db.execute('CREATE TABLE PendingLogin (id INTEGER PRIMARY KEY, '
            'username STRING NOT NULL, code STRING NOT NULL)');
        await db.execute('CREATE TABLE User (id INTEGER PRIMARY KEY, '
            'username STRING NOT NULL, '
            'is_admin BOOLEAN NOT NULL DEFAULT FALSE)');
        await db.execute(
            'CREATE TABLE Vote (id INTEGER PRIMARY KEY, user_id INTEGER, '
            'comment_id INTEGER NOT NULL, score INTEGER NOT NULL, '
            'reason TEXT DEFAULT NULL)');
      },
    ),
  );

  await CurseWords.setup();
  await Firebase.setup();

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware)
      .addHandler(Router()
        ..mount('/api/auth', AuthService(database).router)
        ..mount('/api/poll', PollService(database).router)
        ..mount('/api/user', UserService(database).router));

  var host = '127.0.0.1';

  assert(() {
    host = '192.168.2.198';
    return true;
  }());

  final server = await serve(handler, host, 8017);

  print('Serving at http://${server.address.host}:${server.port}');

  print(await Firebase.sendNotification());
}

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'Authorization',
};
final Middleware _corsMiddleware = createMiddleware(
    requestHandler: (request) => request.method == 'OPTIONS'
        ? Response.ok(null, headers: _corsHeaders)
        : null,
    responseHandler: (response) =>
        response.change(headers: {...response.headers, ..._corsHeaders}));
