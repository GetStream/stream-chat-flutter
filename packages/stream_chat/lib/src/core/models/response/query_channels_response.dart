import 'package:freezed_annotation/freezed_annotation.dart';

import '../channel_state.dart';
import '../predefined_filter.dart';

part 'query_channels_response.freezed.dart';

/// One page of the channels matching a channel query.
@freezed
class QueryChannelsResponse with _$QueryChannelsResponse {
  /// Creates a new [QueryChannelsResponse].
  const QueryChannelsResponse({
    required this.duration,
    required this.channels,
    this.predefinedFilter,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The state of each channel on this page.
  @override
  final List<ChannelState> channels;

  /// The predefined filter the query named, as resolved for it, or null when
  /// the query named none.
  @override
  final PredefinedFilter? predefinedFilter;
}
