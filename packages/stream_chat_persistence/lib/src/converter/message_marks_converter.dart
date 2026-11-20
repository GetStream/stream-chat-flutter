import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';

/// A [TypeConverter] that serializes [Message.markGroups] to a [String]
/// column.
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

/// A [TypeConverter] that serializes [Message.ownMarks] to a [String] column.
class OwnMarksConverter extends TypeConverter<List<OwnMark>, String> {
  @override
  List<OwnMark> fromSql(String fromDb) {
    final json = jsonDecode(fromDb) as List<dynamic>;
    return [
      for (final mark in json) OwnMark.fromJson(mark as Map<String, Object?>),
    ];
  }

  @override
  String toSql(List<OwnMark> value) {
    return jsonEncode([for (final mark in value) mark.toJson()]);
  }
}
