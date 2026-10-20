import 'package:freezed_annotation/freezed_annotation.dart';

import '../message.dart';

part 'send_action_response.freezed.dart';

/// The result of running an action on a message, such as a Giphy command's
/// send, shuffle or cancel.
///
/// See also:
///
///  * [StreamChatClient.sendAction] and [Channel.sendAction], which return it.
@freezed
class SendActionResponse with _$SendActionResponse {
  /// Creates a new [SendActionResponse].
  const SendActionResponse({
    required this.duration,
    this.message,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The message as the action left it, or null when the action removed it.
  @override
  final Message? message;
}
