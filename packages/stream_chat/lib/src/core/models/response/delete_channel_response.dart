import 'package:freezed_annotation/freezed_annotation.dart';

import '../channel_model.dart';

part 'delete_channel_response.freezed.dart';

/// A channel after it was deleted.
@freezed
class DeleteChannelResponse with _$DeleteChannelResponse {
  /// Creates a new [DeleteChannelResponse].
  const DeleteChannelResponse({
    required this.duration,
    this.channel,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The deleted channel.
  @override
  final ChannelModel? channel;
}
