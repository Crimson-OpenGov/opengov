import 'package:opengov_server/environment.dart';
import 'package:opengov_server/services/admin_service.dart';
import 'package:opengov_server/services/announcement_service.dart';
import 'package:opengov_server/services/auth_service.dart';
import 'package:opengov_server/services/feed_service.dart';
import 'package:opengov_server/services/poll_service.dart';
import 'package:opengov_server/services/user_service.dart';
import 'package:opengov_server/util/curse_words.dart';
import 'package:opengov_server/util/firebase.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  final connection = PostgreSQLConnection("localhost", 5432, "opengov",
      username: dbUsername, password: dbPassword);
  await connection.open();

  await CurseWords.setup();
  await Firebase.setup();

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware)
      .addHandler(Router()
        ..mount('/api/admin', AdminService(connection).router)
        ..mount('/api/announcement', AnnouncementService(connection).router)
        ..mount('/api/auth', AuthService(connection).router)
        ..mount('/api/feed', FeedService(connection).router)
        ..mount('/api/poll', PollService(connection).router)
        ..mount('/api/user', UserService(connection).router));

  var host = '127.0.0.1';

  assert(() {
    host = '192.168.2.198';
    return true;
  }());

  final server = await serve(handler, host, 8017);

  print('Serving at http://${server.address.host}:${server.port}');
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
