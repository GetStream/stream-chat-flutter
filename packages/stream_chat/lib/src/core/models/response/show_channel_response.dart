import 'package:freezed_annotation/freezed_annotation.dart';

part 'show_channel_response.freezed.dart';

/// The result of showing a channel the current user hid, returned by
/// [StreamChatClient.showChannel] and [Channel.show].
@freezed
class ShowChannelResponse with _$ShowChannelResponse {
  /// Creates a new [ShowChannelResponse].
  const ShowChannelResponse({
    required this.duration,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;
}
