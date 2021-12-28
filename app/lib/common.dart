import 'package:flutter/material.dart';

Future<T?> showMessageDialog<T>(BuildContext context,
        {String title = 'Error', required String body}) =>
    showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close')),
        ],
      ),
    );

class AuthenticationException implements Exception {}
