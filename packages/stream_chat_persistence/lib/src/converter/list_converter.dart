import 'dart:convert';

import 'package:drift/drift.dart';

/// Maps a [List] of type [T] into a [String] understood
/// by the sqlite backend.
class ListConverter<T> extends TypeConverter<List<T>, String> {
  @override
  List<T> fromSql(String fromDb) {
    return List<T>.from(jsonDecode(fromDb) ?? []);
  }

  @override
  String toSql(List<T> value) {
    return jsonEncode(value);
  }
}
