typedef Json = Map<String, dynamic>;

typedef FromJson<T> = T Function(Json json);

// Needed because json_serializable doesn't support constructor tear-offs.
DateTime dateTimeFromJson(int value) =>
    DateTime.fromMillisecondsSinceEpoch(value);

int dateTimeToJson(DateTime value) => value.millisecondsSinceEpoch;
