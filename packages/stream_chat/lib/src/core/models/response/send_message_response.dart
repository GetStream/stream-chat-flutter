import 'package:freezed_annotation/freezed_annotation.dart';

import '../message.dart';

part 'send_message_response.freezed.dart';

/// The result of sending a message.
///
/// See also:
///
///  * [StreamChatClient.sendMessage] and [Channel.sendMessage], which return
///    it.
@freezed
class SendMessageResponse with _$SendMessageResponse {
  /// Creates a new [SendMessageResponse].
  const SendMessageResponse({
    required this.duration,
    required this.message,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The sent message.
  @override
  final Message message;
}
