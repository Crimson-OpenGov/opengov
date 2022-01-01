import 'dart:io';

import 'package:opengov_server/auth_service.dart';
import 'package:opengov_server/util/curse_words.dart';
import 'package:opengov_server/util/firebase.dart';
import 'package:opengov_server/poll_service.dart';
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
            'topic TEXT NOT NULL, description TEXT NOT NULL, '
            'end INTEGER NOT NULL)');
        await db.execute('CREATE TABLE Comment (id INTEGER PRIMARY KEY, '
            'poll_id INTEGER NOT NULL, user_id INTEGER, '
            'comment TEXT NOT NULL)');
        await db.execute('CREATE TABLE PendingLogin (id INTEGER PRIMARY KEY, '
            'username STRING NOT NULL, code STRING NOT NULL)');
        await db.execute('CREATE TABLE User (id INTEGER PRIMARY KEY, '
            'username STRING NOT NULL, '
            'is_admin BOOLEAN NOT NULL DEFAULT FALSE)');
        await db.execute(
            'CREATE TABLE Vote (id INTEGER PRIMARY KEY, user_id INTEGER, '
            'comment_id INTEGER NOT NULL, score INTEGER NOT NULL)');
      },
    ),
  );

  await CurseWords.setup();
  await Firebase.setup();

  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(Router()
        ..mount('/api/poll', PollService(database).router)
        ..mount('/api/auth', AuthService(database).router));

  final server = await serve(handler, '192.168.2.198', 8017);

  print('Serving at http://${server.address.host}:${server.port}');

  print(await Firebase.sendNotification());
}
