import 'dart:convert';

import 'package:drift/drift.dart';

/// Maps a [List] of type [T] into a [String] understood
/// by the sqlite backend.
class ListConverter<T> extends TypeConverter<List<T>, String> {
  @override
  List<T>? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    return List<T>.from(jsonDecode(fromDb) ?? []);
  }

  @override
  String? mapToSql(List<T>? value) {
    if (value == null) {
      return null;
    }
    return jsonEncode(value);
  }
}
