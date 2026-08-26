import '../core/models/predefined_filter.dart';
import 'channel.dart';

/// The result of a `queryChannelsWithResult` call on [StreamChatClient].
///
/// Carries the live [Channel] instances matching the query alongside the
/// server-resolved [PredefinedFilter] spec (when one is associated with the
/// query).
class QueryChannelsResult {
  /// Creates a new [QueryChannelsResult].
  const QueryChannelsResult({
    required this.channels,
    this.predefinedFilter,
  });

  /// The live [Channel] instances matching the query.
  final List<Channel> channels;

  /// The server-resolved predefined-filter spec, or null when the query did
  /// not use a `predefinedFilter`.
  final PredefinedFilter? predefinedFilter;
}
