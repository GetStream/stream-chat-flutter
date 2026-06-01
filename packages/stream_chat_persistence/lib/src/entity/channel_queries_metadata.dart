// coverage:ignore-file
import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/converter/converter.dart';

/// Represents a [ChannelQueriesMetadata] table in `DriftChatDatabase`.
///
/// Holds side-information about a channel query keyed by its [queryHash].
/// Currently stores the server-resolved sort spec used by predefined-filter
/// queries so that offline reads can apply the same ordering.
@DataClassName('ChannelQueryMetadataEntity')
class ChannelQueriesMetadata extends Table {
  /// The query hash this metadata is associated with. Matches the hashes
  /// produced by `ChannelQueryDao` for predefined-filter queries.
  TextColumn get queryHash => text()();

  /// The server-resolved sort spec to apply on offline reads. Null when the
  /// query has no associated sort.
  TextColumn get sortSpec =>
      text().nullable().map(const NullableChannelStateSortOrderConverter())();

  @override
  Set<Column> get primaryKey => {queryHash};
}
