import 'dart:convert';

import 'package:http/http.dart';
import 'package:opengov_server/environment.dart';

class EmailService {
  static final _uri = Uri(
    scheme: 'https',
    host: 'api.sendinblue.com',
    pathSegments: ['v3', 'smtp', 'email'],
  );
  static final _client = Client();

  static Future<bool> sendVerificationEmail(
      String username, String code) async {
    final response = await _client.post(
      _uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Api-Key': sendInBlueApiKey,
      },
      body: json.encode({
        'to': [
          {'name': username, 'email': '$username@college.harvard.edu'},
        ],
        'templateId': 1,
        'params': {'code': code},
      }),
    );
    return response.statusCode == 201;
  }
}
