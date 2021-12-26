import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/login/verification_view.dart';
import 'package:opengov_common/actions/login.dart';

class LoginView extends StatefulWidget {
  const LoginView();

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _textController = TextEditingController();

  Future<void> _onButtonPressed() async {
    final username = _textController.text;
    final response = await HttpService.login(LoginRequest(username: username));

    if (response?.success ?? false) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => VerificationView(username: username)));
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
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      suffixText: '@college.harvard.edu',
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _onButtonPressed,
                    child: const Text('Log In'),
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
