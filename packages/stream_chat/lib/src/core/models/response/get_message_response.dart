import 'package:freezed_annotation/freezed_annotation.dart';

import '../channel_model.dart';
import '../message.dart';

part 'get_message_response.freezed.dart';

/// The result of fetching a single message.
///
/// See also:
///
///  * [StreamChatClient.getMessage], which returns it.
@freezed
class GetMessageResponse with _$GetMessageResponse {
  /// Creates a new [GetMessageResponse].
  const GetMessageResponse({
    required this.duration,
    required this.message,
    required this.channel,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The message that was fetched.
  @override
  final Message message;

  /// The channel the message belongs to.
  @override
  final ChannelModel channel;
}
