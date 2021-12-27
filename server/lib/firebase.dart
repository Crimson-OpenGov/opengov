import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart';
import 'package:opengov_common/common.dart';

class Firebase {
  static final _authUrl = Uri(
      scheme: 'https',
      host: 'www.googleapis.com',
      pathSegments: ['oauth2', 'v4', 'token']);
  static const _scope = "https://www.googleapis.com/auth/cloud-platform";

  static final _client = Client();
  static late Json _json;

  static Future<void> setup() async {
    _json = json.decode(await File('sa.json').readAsString());
  }

  static String _jwt() {
    return JWT(
      {'scope': _scope},
      audience: Audience.one(_authUrl.toString()),
      issuer: _json['client_email'],
    ).sign(
      RSAPrivateKey(_json['private_key']),
      algorithm: JWTAlgorithm.RS256,
      expiresIn: const Duration(hours: 1),
    );
  }

  static Future<String> _fetchToken() async {
    final jwt = _jwt();

    final response = await _client.post(_authUrl, headers: {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/x-www-form-urlencoded',
    }, body: {
      'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      'assertion': jwt,
    });

    return json.decode(response.body)['access_token']!;
  }

  static Future<bool> sendNotification() async {
    final token = await _fetchToken();

    final response = await _client.post(
      Uri(scheme: 'https', host: 'fcm.googleapis.com', pathSegments: [
        'v1',
        'projects',
        _json['project_id']!,
        'messages:send',
      ]),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'message': {
          'topic': 'general',
          'data': {},
          'notification': {
            'title': 'FCM Message',
            'body': 'This is an FCM notification message!',
          }
        }
      }),
    );

    return response.statusCode == 200;
  }
}
