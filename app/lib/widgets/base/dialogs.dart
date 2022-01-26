import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog(BuildContext context,
    {required String body}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm'),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text(
            'No',
            style: TextStyle(color: Colors.green),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text(
            'Yes',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );

  return result ?? false;
}
