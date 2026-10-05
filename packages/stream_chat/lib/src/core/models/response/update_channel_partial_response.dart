import 'package:freezed_annotation/freezed_annotation.dart';

import '../channel_model.dart';
import '../member.dart';

part 'update_channel_partial_response.freezed.dart';

/// A channel after some of its fields were set or unset.
@freezed
class UpdateChannelPartialResponse with _$UpdateChannelPartialResponse {
  /// Creates a new [UpdateChannelPartialResponse].
  const UpdateChannelPartialResponse({
    required this.duration,
    this.channel,
    this.members = const [],
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The updated channel.
  @override
  final ChannelModel? channel;

  /// A page of the channel's members after the update.
  @override
  final List<Member> members;
}
