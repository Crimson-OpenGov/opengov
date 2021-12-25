import 'dart:convert';

import 'package:http/http.dart';
import 'package:opengov_common/actions/list_polls.dart';
import 'package:opengov_common/actions/poll_details.dart';
import 'package:opengov_common/models/poll.dart';

class HttpService {
  static final _client = Client();

  static Uri _uri(String path) => Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8017,
      path: 'api/$path');

  static Future<String> _get(String path) async {
    return (await _client.get(_uri(path))).body;
  }

  static Future<String> _post(String path, String body) async {
    return (await _client.post(_uri(path), body: body)).body;
  }

  static Future<ListPollsResponse?> listPolls() async {
    final responseObject = json.decode(await _get('poll/list'));
    return responseObject == null
        ? null
        : ListPollsResponse.fromJson(responseObject);
  }

  static Future<PollDetailsResponse?> getPollDetails(Poll poll) async {
    final responseObject =
        json.decode(await _get('poll/details/${poll.id}'));
    return responseObject == null
        ? null
        : PollDetailsResponse.fromJson(responseObject);
  }
}
