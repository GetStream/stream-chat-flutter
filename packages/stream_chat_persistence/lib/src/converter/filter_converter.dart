import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';

/// A [TypeConverter] that serializes a [Filter] to and from its JSON [String]
/// representation.
///
/// Used by the `channel_query_metadata` table to persist the server-resolved
/// filter spec associated with a predefined-filter query, so that offline
/// reads can reconstruct the full resolved spec.
class FilterConverter extends TypeConverter<Filter, String> {
  /// Creates a new instance.
  const FilterConverter();

  @override
  Filter fromSql(String fromDb) {
    final value = jsonDecode(fromDb) as Map<String, dynamic>;
    return Filter.raw(value: value);
  }

  @override
  String toSql(Filter value) => jsonEncode(value.toJson());
}
