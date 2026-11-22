import 'package:freezed_annotation/freezed_annotation.dart';

import '../channel_state.dart';

part 'channel_state_response.freezed.dart';

/// The state of one channel, as a channel query returns it.
///
/// See also:
///
///  * [StreamChatClient.queryChannel], [StreamChatClient.watchChannel],
///    [Channel.query], [Channel.watch] and [Channel.create], which return it.
@freezed
class ChannelStateResponse with _$ChannelStateResponse {
  /// Creates a new [ChannelStateResponse].
  const ChannelStateResponse({
    required this.duration,
    required this.channelState,
  });

  /// How long the request took to handle, such as `4.21ms`.
  ///
  /// A state read from the offline storage reports `0ms`.
  @override
  final String duration;

  /// The channel and the messages, members and reads the query loaded.
  @override
  final ChannelState channelState;
}
