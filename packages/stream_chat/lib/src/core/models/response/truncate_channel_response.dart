import 'package:freezed_annotation/freezed_annotation.dart';

import '../channel_model.dart';
import '../message.dart';

part 'truncate_channel_response.freezed.dart';

/// The result of truncating a channel.
///
/// See also:
///
///  * [StreamChatClient.truncateChannel] and [Channel.truncate], which return
///    it.
@freezed
class TruncateChannelResponse with _$TruncateChannelResponse {
  /// Creates a new [TruncateChannelResponse].
  const TruncateChannelResponse({
    required this.duration,
    this.channel,
    this.message,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The truncated channel.
  @override
  final ChannelModel? channel;

  /// The system message sent with the truncation, if one was given.
  @override
  final Message? message;
}
