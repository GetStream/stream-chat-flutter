import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';

/// Maps a [List] of [ChannelSort] into a [String] understood by the sqlite
/// backend.
///
/// Used by the `channel_query_metadata` table to persist the sort the server
/// resolved for a predefined-filter query, so an offline read can apply the
/// same ordering.
class ChannelSortConverter extends TypeConverter<List<ChannelSort>, String> {
  /// Creates a new instance.
  const ChannelSortConverter();

  @override
  List<ChannelSort> fromSql(String fromDb) {
    final json = jsonDecode(fromDb) as List<dynamic>;
    return json.map((e) => ChannelSort.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  String toSql(List<ChannelSort> value) {
    return jsonEncode(value.map((e) => e.toJson()).toList());
  }
}
