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

  /// The message as it was sent, with its creation date set and, unless the
  /// send skipped them, previews for the links in its text.
  @override
  final Message message;
}
