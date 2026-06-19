// coverage:ignore-file
import 'package:drift/drift.dart';
import 'package:stream_chat_persistence/src/converter/converter.dart';

/// Represents a [ChannelQueriesMetadata] table in `DriftChatDatabase`.
///
/// Holds side-information about a channel query keyed by its [queryHash].
/// Stores the server-resolved filter and sort spec used by predefined-filter
/// queries so that offline reads can reconstruct the full resolved spec.
@DataClassName('ChannelQueryMetadataEntity')
class ChannelQueriesMetadata extends Table {
  /// The query hash this metadata is associated with. Matches the hashes
  /// produced by `ChannelQueryDao` for predefined-filter queries.
  TextColumn get queryHash => text()();

  /// The server-resolved filter spec to surface on offline reads.
  TextColumn get filter => text().map(const FilterConverter())();

  /// The server-resolved sort spec to apply on offline reads.
  TextColumn get sort => text().map(const ChannelStateSortOrderConverter())();

  @override
  Set<Column> get primaryKey => {queryHash};
}
