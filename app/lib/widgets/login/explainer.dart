import 'package:flutter/material.dart';
import 'package:opengov_app/widgets/login/login_view.dart';

class _ExplainerPage {
  final String? title;
  final Widget middle;
  final String? body;
  final ImageProvider? background;

  const _ExplainerPage({
    this.title,
    required this.middle,
    this.body,
    this.background,
  });
}

class Explainer extends StatelessWidget {
  const Explainer();

  static final _pages = [
    _ExplainerPage(
      middle: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xFFA51C30).withAlpha(230),
        ),
        padding: const EdgeInsets.all(16),
        child: const Text(
          'Welcome to\nCrimson OpenGov!',
          style: TextStyle(color: Colors.white, fontSize: 32),
          textAlign: TextAlign.center,
        ),
      ),
      background: const AssetImage('assets/images/building.png'),
    ),
    _ExplainerPage(
      title: 'What you do',
      middle: Image.asset('assets/images/people.png'),
      body: "1. PROPOSE ideas or general comments for everyone to consider.\n\n"
          "2. VOTE on other people's ideas to agree, disagree or no "
          "comment.\n\n"
          '3. IMAGINE new ways to improve Harvard’s community that will be '
          'incorporated into the decisions of campus leaders.',
    ),
    const _ExplainerPage(
      title: 'What Crimson OpenGov does',
      middle: Icon(Icons.check_circle, size: 128, color: Colors.green),
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
    const _ExplainerPage(
      title: "What Crimson OpenGov doesn't do",
      middle: Icon(Icons.cancel, size: 128, color: Colors.red),
      body:
          "Crimson OpenGov is anonymous. We don't collect names or PII. While "
          "we collect your Harvard email to ensure that poll respondents are "
          "Harvard students, we will never use this to identify the authors of "
          "specific comments or votes.",
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PageView(
          children: [
            for (var i = 0; i < _pages.length; i++)
              Container(
                decoration: _pages[i].background != null
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: _pages[i].background!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : null,
                child: SafeArea(
                  minimum: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      if (_pages[i].title != null) ...[
                        Text(
                          _pages[i].title!,
                          style: const TextStyle(fontSize: 28),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                      ],
                      _pages[i].middle,
                      if (_pages[i].body != null) ...[
                        const SizedBox(height: 24),
                        Text(
                          _pages[i].body!,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const Spacer(),
                      if (i < _pages.length - 1)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Swipe to continue',
                              style: TextStyle(
                                fontSize: 18,
                                color: _pages[i].background != null
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 30,
                              color: _pages[i].background != null
                                  ? Colors.white
                                  : null,
                            ),
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
                  ),
                ),
              )
          ],
        ),
      );
}
