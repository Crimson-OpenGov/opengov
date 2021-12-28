import 'dart:convert';

import 'package:http/http.dart';
import 'package:opengov_app/common.dart';
import 'package:opengov_common/actions/add_comment.dart';
import 'package:opengov_common/actions/list_polls.dart';
import 'package:opengov_common/actions/login.dart';
import 'package:opengov_common/actions/poll_details.dart';
import 'package:opengov_common/actions/vote.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/generic_response.dart';
import 'package:opengov_common/models/poll.dart';
import 'package:opengov_common/models/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  static final _client = Client();

  static Uri _uri(String path) =>
      Uri(scheme: 'http', host: '192.168.2.198', port: 8017, path: 'api/$path');

  static Future<Map<String, String>> get _headers async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');

    return {
      if (token != null) 'Authorization': 'Basic ${Token.fromString(token)}',
    };
  }

  static Future<T?> _get<T>(String path, FromJson<T> fromJson) async {
    final response = await _client.get(_uri(path), headers: await _headers);

    if (response.statusCode == 403) {
      throw AuthenticationException();
    }

    final responseObject = json.decode(response.body);
    return responseObject == null ? null : fromJson(responseObject);
  }

  static Future<T?> _post<T>(
      String path, Json body, FromJson<T> fromJson) async {
    final response = await _client.post(_uri(path),
        body: json.encode(body), headers: await _headers);

    if (response.statusCode == 403) {
      throw AuthenticationException();
    }

    final responseObject = json.decode(response.body);
    return responseObject == null ? null : fromJson(responseObject);
  }

  static Future<ListPollsResponse?> listPolls() =>
      _get('poll/list', ListPollsResponse.fromJson);

  static Future<PollDetailsResponse?> getPollDetails(Poll poll) =>
      _get('poll/details/${poll.id}', PollDetailsResponse.fromJson);

  static Future<GenericResponse?> addComment(AddCommentRequest request) =>
      _post('poll/add-comment', request.toJson(), GenericResponse.fromJson);

  static Future<GenericResponse?> vote(VoteRequest request) =>
      _post('poll/vote', request.toJson(), GenericResponse.fromJson);

  static Future<GenericResponse?> login(LoginRequest request) =>
      _post('auth/login', request.toJson(), GenericResponse.fromJson);

  static Future<VerificationResponse?> verify(VerificationRequest request) =>
      _post('auth/verify', request.toJson(), VerificationResponse.fromJson);
}
