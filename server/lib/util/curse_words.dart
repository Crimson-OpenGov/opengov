import 'dart:io';

class CurseWords {
  static final _notWordCharacter = RegExp(r'\W+');
  static late Set<String> _curseWords;

  static Future<void> setup() async {
    _curseWords = (await File('curse_words.txt').readAsLines()).toSet();
  }

  static bool isBadString(String str) => str
      .split(' ')
      .map((word) => word.replaceAll(_notWordCharacter, ''))
      .any(_curseWords.contains);
}
