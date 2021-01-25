import 'dart:convert';

import 'package:moor/moor.dart';

///
class ListConverter<T> extends TypeConverter<List<T>, String> {
  @override
  List<T> mapToDart(fromDb) {
    if (fromDb == null) {
      return null;
    }
    return List<T>.from(jsonDecode(fromDb) ?? []);
  }

  @override
  String mapToSql(value) {
    if (value == null) {
      return null;
    }
    return jsonEncode(value);
  }
}
