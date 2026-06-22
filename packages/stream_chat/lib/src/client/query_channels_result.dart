import 'package:stream_chat/src/client/channel.dart';
import 'package:stream_chat/src/core/models/predefined_filter.dart';

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
