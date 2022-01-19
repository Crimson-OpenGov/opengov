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

  @override
  void initState() {
    super.initState();

    _textController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _onButtonPressed() async {
    final username = _textController.text.split('@')[0];
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
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.onBackground,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Crimson OpenGov',
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
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      suffixText: '@college.harvard.edu',
                      hintText: 'Username',
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _textController.text.isNotEmpty
                        ? _onButtonPressed
                        : null,
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
