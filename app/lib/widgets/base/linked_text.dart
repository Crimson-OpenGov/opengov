import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class _TextFragment {
  final String text;
  final bool isUrl;

  const _TextFragment(this.text, {this.isUrl = false});

  @override
  String toString() => '[(isUrl: $isUrl) $text]';
}

class LinkedText extends StatelessWidget {
  // From http://urlregex.com/
  static final _linkRegex = RegExp(r'http[s]?://'
      r'(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+');

  final List<_TextFragment> fragments;
  final double? fontSize;

  const LinkedText._(this.fragments, this.fontSize);

  factory LinkedText(String text, {double? fontSize}) {
    final fragments = <_TextFragment>[];
    final matches = _linkRegex.allMatches(text);
    var i = 0;

    for (final match in matches) {
      if (match.start > i) {
        fragments.add(_TextFragment(text.substring(i, match.start)));
      }

      fragments.add(
          _TextFragment(text.substring(match.start, match.end), isUrl: true));
      i = match.end;
    }

    if (i < text.length) {
      fragments.add(_TextFragment(text.substring(i)));
    }

    return LinkedText._(fragments, fontSize);
  }

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          children: [
            for (final fragment in fragments)
              TextSpan(
                text: fragment.text,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontSize: fontSize,
                    color: fragment.isUrl ? Colors.blue : null),
                recognizer: fragment.isUrl
                    ? (TapGestureRecognizer()
                      ..onTap = () {
                        launch(fragment.text);
                      })
                    : null,
              ),
          ],
        ),
      );
}
