import 'package:freezed_annotation/freezed_annotation.dart';

part 'hide_channel_response.freezed.dart';

/// The outcome of hiding a channel for the current user.
@freezed
class HideChannelResponse with _$HideChannelResponse {
  /// Creates a new [HideChannelResponse].
  const HideChannelResponse({
    required this.duration,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;
}
