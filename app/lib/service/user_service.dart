import 'package:flutter/material.dart';
import 'package:opengov_app/common.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_common/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GetUserResult { loading, loggedIn, notLoggedIn, expired }

class UserService {
  static User? _user;

  static User get user => _user!;

  static Future<GetUserResult> getUser(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey('username') &&
        sharedPreferences.containsKey('token')) {
      try {
        _user = await HttpService.getMe();
        if (_user != null) {
          return GetUserResult.loggedIn;
        }
      } on AuthenticationException {
        sharedPreferences.clear();

        showMessageDialog(context,
            body: 'Your session has expired. Please log in again.');

        return GetUserResult.expired;
      }
    }

    return GetUserResult.notLoggedIn;
  }
}
