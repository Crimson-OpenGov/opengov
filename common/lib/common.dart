typedef Json = Map<String, dynamic>;

typedef FromJson<T> = T Function(Json json);

bool boolFromJson(int value) => value == 1;
