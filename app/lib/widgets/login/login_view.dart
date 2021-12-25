import 'package:flutter/material.dart';
import 'package:opengov_app/widgets/login/verification_view.dart';

class LoginView extends StatelessWidget {
  const LoginView();

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
                  const Text(
                    'OpenGov',
                    style: TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A platform for direct democracy.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixText: '@college.harvard.edu',
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const VerificationView()));
                    },
                    child: const Text('Log In'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
