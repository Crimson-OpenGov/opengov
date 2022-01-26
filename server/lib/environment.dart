import 'dart:io';

final secretKey = Platform.environment['SECRET_KEY']!;

/// Whether moderation is enforced.
///
/// If true, comments won't be visible until they are approved by a moderator.
/// If false, comments will be visible immediately and can be deleted later.
final enforceModeration =
    Platform.environment['ENFORCE_MODERATION']!.toLowerCase() == 'true';

final sendInBlueApiKey = Platform.environment['SEND_IN_BLUE_API_KEY']!;

final dbUsername = Platform.environment['DB_USERNAME'];

final dbPassword = Platform.environment['DB_PASSWORD'];
