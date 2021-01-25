import 'dart:convert';

import 'package:moor/moor.dart';

///
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
