import 'dart:convert';

import 'package:crypto/crypto.dart';

class Token {
  final String username;

  /// The secret that verifies the user.
  ///
  /// Computed on the server as sha256([username] + secretKey).
  final String hashValue;

  const Token({required this.username, required this.hashValue});

  factory Token.fromString(String token) {
    final parts = token.split(':');
    return Token(username: parts[0], hashValue: parts[1]);
  }

  factory Token.generate(String username, String secretKey) => Token(
      username: username,
      hashValue: sha256.convert(ascii.encode(username + secretKey)).toString());

  @override
  String toString() => '$username:$hashValue';

  @override
  bool operator ==(Object other) =>
      other is Token && other.hashValue == hashValue;

  @override
  int get hashCode => hashValue.hashCode;
}
