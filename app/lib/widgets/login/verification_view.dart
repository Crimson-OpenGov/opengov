import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/polls/polls_list.dart';
import 'package:opengov_common/actions/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationView extends StatefulWidget {
  final String username;

  const VerificationView({required this.username});

  @override
  _VerificationViewState createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  final _textController = TextEditingController();

  Future<void> _onButtonPressed() async {
    final username = widget.username;
    final response = await HttpService.verify(
        VerificationRequest(username: username, code: _textController.text));
    final token = response?.token;

    if (token != null) {
      final sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('username', username);
      sharedPreferences.setString('token', token);

      unawaited(Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const PollsList()),
        (_) => false,
      ));

      FirebaseMessaging.instance
        ..requestPermission()
        ..subscribeToTopic('general');
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'An error occurred during verification. Please ensure that you '
              'entered the correct code.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Enter the code sent to your email address.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    autofocus: true,
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _onButtonPressed,
                    child: const Text('Verify'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
