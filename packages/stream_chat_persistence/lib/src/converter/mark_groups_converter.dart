import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';

/// Stores [Message.markGroups] as json in a [String] column.
class MarkGroupsConverter extends TypeConverter<Map<String, MarkGroup>, String> {
  @override
  Map<String, MarkGroup> fromSql(String fromDb) {
    final json = jsonDecode(fromDb) as Map<String, dynamic>;
    return json.map(
      (type, group) {
        final markGroup = MarkGroup.fromJson(group as Map<String, Object?>);
        return MapEntry(type, markGroup);
      },
    );
  }

  @override
  String toSql(Map<String, MarkGroup> value) {
    final json = value.map((type, group) => MapEntry(type, group.toJson()));
    return jsonEncode(json);
  }
}
