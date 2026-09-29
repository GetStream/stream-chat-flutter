import '../core/models/predefined_filter.dart';
import 'channel/channel.dart';

/// The result of a `queryChannelsWithResult` call on [StreamChatClient].
///
/// Carries the live [Channel] instances matching the query alongside the
/// [PredefinedFilter] the query named, as resolved for it.
class QueryChannelsResult {
  /// Creates a new [QueryChannelsResult].
  const QueryChannelsResult({
    required this.channels,
    this.predefinedFilter,
  });

  /// The live [Channel] instances matching the query.
  final List<Channel> channels;

  /// The predefined filter the query named, as resolved for it, or null when
  /// the query named none.
  final PredefinedFilter? predefinedFilter;
}
