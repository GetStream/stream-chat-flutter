import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/converter/converter.dart';

/// A [TypeConverter] that serializes [VotingVisibility] to a [String] column.
class ReactionGroupsConverter extends MapConverter<ReactionGroup> {
  @override
  Map<String, ReactionGroup> fromSql(String fromDb) {
    final json = jsonDecode(fromDb) as Map<String, dynamic>;
    return json.map(
      (key, e) {
        final group = ReactionGroup.fromJson(e as Map<String, Object?>);
        return MapEntry(key, group);
      },
    );
  }

  @override
  String toSql(Map<String, ReactionGroup> value) {
    return jsonEncode(
      value.map(
        (k, e) => MapEntry(k, e.toJson()),
      ),
    );
  }
}
