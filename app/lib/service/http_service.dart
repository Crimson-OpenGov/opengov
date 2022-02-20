import 'dart:convert';

import 'package:http/http.dart';
import 'package:opengov_app/common.dart';
import 'package:opengov_common/actions/add_comment.dart';
import 'package:opengov_common/actions/create_update.dart';
import 'package:opengov_common/actions/delete_poll.dart';
import 'package:opengov_common/actions/feed.dart';
import 'package:opengov_common/actions/list_announcements.dart';
import 'package:opengov_common/actions/list_polls.dart';
import 'package:opengov_common/actions/login.dart';
import 'package:opengov_common/actions/announcement_details.dart';
import 'package:opengov_common/actions/poll_details.dart';
import 'package:opengov_common/actions/update_comment.dart';
import 'package:opengov_common/actions/vote.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_common/models/announcement.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/models/generic_response.dart';
import 'package:opengov_common/models/poll.dart';
import 'package:opengov_common/models/report.dart';
import 'package:opengov_common/models/token.dart';
import 'package:opengov_common/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  static final _client = Client();

  static Uri _uri(String path) {
    var scheme = 'https';
    var host = 'app.crimsonopengov.us';
    int? port;

    assert(() {
      scheme = 'http';
      host = '192.168.2.198';
      port = 8017;
      return true;
    }());

    return Uri(scheme: scheme, host: host, port: port, path: 'api/$path');
  }

  static Future<Map<String, String>> get _headers async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');

    return {
      if (token != null) 'Authorization': 'Basic ${Token(value: token)}',
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

  static Future<PollDetailsResponse?> getPollDetails(int pollId) =>
      _get('poll/details/$pollId', PollDetailsResponse.fromJson);

  static Future<Comment?> getCommentDetails(CommentBase comment) =>
      _get('poll/comment/${comment.id}', Comment.fromJson);

  static Future<Report?> getReport(Poll poll) =>
      _get('poll/report/${poll.id}', Report.fromJson);

  static Future<AddCommentResponse?> addComment(AddCommentRequest request) =>
      _post('poll/add-comment', request.toJson(), AddCommentResponse.fromJson);

  static Future<GenericResponse?> vote(VoteRequest request) =>
      _post('poll/vote', request.toJson(), GenericResponse.fromJson);

  static Future<CreateOrUpdateResponse?> createOrUpdatePoll(Poll poll) =>
      _post('admin/create-or-update-poll', poll.toJson(),
          CreateOrUpdateResponse.fromJson);

  static Future<GenericResponse?> deletePoll(DeletePollRequest request) =>
      _post('admin/delete-poll', request.toJson(), GenericResponse.fromJson);

  static Future<GenericResponse?> updateComment(UpdateCommentRequest request) =>
      _post('admin/update-comment', request.toJson(), GenericResponse.fromJson);

  static Future<GenericResponse?> login(LoginRequest request) =>
      _post('auth/login', request.toJson(), GenericResponse.fromJson);

  static Future<VerificationResponse?> verify(VerificationRequest request) =>
      _post('auth/verify', request.toJson(), VerificationResponse.fromJson);

  static Future<ListAnnouncementsResponse?> listAnnouncements() =>
      _get('announcement/list', ListAnnouncementsResponse.fromJson);

  static Future<AnnouncementDetailsResponse?> getAnnouncementDetails(
          int announcementId) =>
      _get('announcement/details/$announcementId',
          AnnouncementDetailsResponse.fromJson);

  static Future<CreateOrUpdateResponse?> createOrUpdateAnnouncement(
          Announcement announcement) =>
      _post('admin/create-or-update-announcement', announcement.toJson(),
          CreateOrUpdateResponse.fromJson);

  static Future<FeedResponse?> getRandomFeed() =>
      _get('feed/random', FeedResponse.fromJson);

  static Future<User?> getMe() => _get('user/me', User.fromJson);
}
