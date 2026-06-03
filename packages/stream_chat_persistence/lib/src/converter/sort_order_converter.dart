import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';

/// A [TypeConverter] that serializes a [SortOrder] of [ChannelState] to and
/// from its JSON [String] representation.
///
/// Used by the `channel_query_metadata` table to persist the server-resolved
/// sort spec associated with a predefined-filter query, so that offline reads
/// can apply the same ordering.
class ChannelStateSortOrderConverter
    extends TypeConverter<SortOrder<ChannelState>, String> {
  /// Creates a new instance.
  const ChannelStateSortOrderConverter();

  @override
  SortOrder<ChannelState> fromSql(String fromDb) {
    final list = jsonDecode(fromDb) as List<dynamic>;
    return list
        .cast<Map<String, dynamic>>()
        .map(SortOption<ChannelState>.fromJson)
        .toList(growable: false);
  }

  @override
  String toSql(SortOrder<ChannelState> value) {
    return jsonEncode(value.map((o) => o.toJson()).toList());
  }
}
