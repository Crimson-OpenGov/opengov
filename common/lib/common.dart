typedef Json = Map<String, dynamic>;

typedef FromJson<T> = T Function(Json json);

// The bool functions are needed for backwards compatibility. They were needed
// when the database was SQLite, and they're still needed in order to support
// old versions of the app.

bool boolFromJson(/* int|bool */ value) => value is bool ? value : value == 1;

int boolToJson(/* bool|int */ value) => value is int ? value : (value ? 1 : 0);

// Needed because json_serializable doesn't support constructor tear-offs.
DateTime dateTimeFromJson(int value) =>
    DateTime.fromMillisecondsSinceEpoch(value);

int dateTimeToJson(DateTime value) => value.millisecondsSinceEpoch;

final badUsernameCharacters = RegExp(r'[+.]');
