import 'dart:convert';

import 'package:opengov_common/common.dart';
import 'package:shelf/shelf.dart';

extension X on Request {
  Future<T> readAsObject<T>(T Function(Json json) fromJson) async =>
      fromJson(json.decode(await readAsString()));
}
