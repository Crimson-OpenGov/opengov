import 'dart:convert';

import 'package:crypto/crypto.dart';

class Token {
  /// The value that verifies the user.
  ///
  /// Computed on the server as sha256(username + secretKey).
  final String value;

  const Token({required this.value});

  factory Token.generate(String username, String secretKey) => Token(
      value: sha256.convert(ascii.encode(username + secretKey)).toString());

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) =>
      other is Token && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
