import 'dart:convert';

import 'package:drift/drift.dart';

/// Maps a [Map] of type [String], [T] into a [String] understood
/// by the sqlite backend.
class MapConverter<T> extends TypeConverter<Map<String, T>, String> {
  @override
  Map<String, T> fromSql(String fromDb) {
    return Map<String, T>.from(jsonDecode(fromDb) ?? {});
  }

  @override
  String toSql(Map<String, T> value) {
    return jsonEncode(value);
  }
}
