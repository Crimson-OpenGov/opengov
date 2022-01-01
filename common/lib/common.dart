typedef Json = Map<String, dynamic>;

typedef FromJson<T> = T Function(Json json);

bool boolFromJson(int value) => value == 1;

int boolToJson(bool value) => value ? 1 : 0;

// Needed because json_serializable doesn't support constructor tear-offs.
DateTime fromMillisecondsSinceEpoch(int value) =>
    DateTime.fromMillisecondsSinceEpoch(value);

int dateTimeToJson(DateTime value) => value.millisecondsSinceEpoch;
