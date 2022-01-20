typedef Json = Map<String, dynamic>;

typedef FromJson<T> = T Function(Json json);

bool boolFromJson(int value) => value == 1;

int boolToJson(bool value) => value ? 1 : 0;

// Needed because json_serializable doesn't support constructor tear-offs.
DateTime dateTimeFromJson(int value) =>
    DateTime.fromMillisecondsSinceEpoch(value);

int dateTimeToJson(DateTime value) => value.millisecondsSinceEpoch;

// Needed because sqflite returns the code as an int even though we want to
// treat it as a String.
String codeFromJson(int value) => value.toString();

int codeToJson(String value) => int.parse(value);
