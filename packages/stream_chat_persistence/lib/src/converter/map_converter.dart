import 'dart:convert';

import 'package:moor/moor.dart';

/// Maps a [Map] of type [String], [T] into a [String] understood
/// by the sqlite backend.
class MapConverter<T> extends TypeConverter<Map<String, T>, String> {
  @override
  Map<String, T> mapToDart(fromDb) {
    if (fromDb == null) {
      return null;
    }
    return Map<String, T>.from(jsonDecode(fromDb) ?? {});
  }

  @override
  String mapToSql(value) {
    if (value == null) {
      return null;
    }
    return jsonEncode(value);
  }
}
