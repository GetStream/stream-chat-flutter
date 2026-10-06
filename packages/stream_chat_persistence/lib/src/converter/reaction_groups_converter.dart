import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'converter.dart';

/// A [TypeConverter] that stores a message's [ReactionGroup]s as a JSON [String] column.
class ReactionGroupsConverter extends MapConverter<ReactionGroup> {
  @override
  Map<String, ReactionGroup> fromSql(String fromDb) {
    final json = jsonDecode(fromDb) as Map<String, dynamic>;
    return json.map(
      (key, e) {
        final group = ReactionGroup.fromData(e as Map<String, Object?>);
        return MapEntry(key, group);
      },
    );
  }

  @override
  String toSql(Map<String, ReactionGroup> value) {
    return jsonEncode(
      value.map(
        (k, e) => MapEntry(k, e.toData()),
      ),
    );
  }
}
