import 'package:flutter/material.dart';
import 'package:opengov_app/widgets/login/login_view.dart';

class _ExplainerPage {
  final IconData icon;
  final String title;
  final String body;

  const _ExplainerPage(
      {required this.icon, required this.title, required this.body});
}

class Explainer extends StatelessWidget {
  const Explainer();

  static const _pages = [
    _ExplainerPage(
      icon: Icons.person,
      title: 'What you do',
      body: "1. PROPOSE ideas or general comments for everyone to consider.\n\n"
          "2. VOTE on other people's ideas to agree, disagree or no "
          "comment.\n\n"
          '3. IMAGINE new ways to improve Harvard’s community that will be '
          'incorporated into the decisions of campus leaders.',
    ),
    _ExplainerPage(
      icon: Icons.check_circle,
      title: 'What Crimson OpenGov does',
      body: 'Crimson OpenGov identifies the most supported perspectives. It '
          'also figures out points of division and points of common ground, '
          'helping us understand the overall picture on campus.\n\n'
          'The results will influence the decision-making of administrators '
          'who want to get new ideas from students and the Constitutional '
          "Convention that's writing a constitution for our new student "
          'government.\n\n'
          'Crimson OpenGov was created by the Executive Cabinet of Michael '
          'Cheng and Emmett de Kanter, your student body President/VP, to '
          'increase the influence of students in our university community.',
    ),
    _ExplainerPage(
      icon: Icons.cancel,
      title: "What Crimson OpenGov doesn't do",
      body:
          "Crimson OpenGov is anonymous. We don't collect names or PII. While "
          "we collect your Harvard email to ensure that poll respondents are "
          "Harvard students, we will never use this to identify the authors of "
          "specific comments or votes.",
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Welcome to Crimson OpenGov!')),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16),
          child: PageView(
            children: [
              for (var i = 0; i < _pages.length; i++)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      _pages[i].title,
                      style: const TextStyle(fontSize: 28),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Icon(_pages[i].icon, size: 128),
                    const SizedBox(height: 16),
                    Text(
                      _pages[i].body,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    if (i < _pages.length - 1)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Swipe to continue',
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(Icons.chevron_right, size: 24),
                        ],
                      )
                    else
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginView()),
                            (_) => false,
                          );
                        },
                        child: const Text('Tap to continue'),
                      ),
                  ],
                )
            ],
          ),
        ),
      );
}
