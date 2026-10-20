import 'package:freezed_annotation/freezed_annotation.dart';

import '../message.dart';

part 'translate_message_response.freezed.dart';

/// The result of translating a message.
///
/// See also:
///
///  * [StreamChatClient.translateMessage] and [Channel.translateMessage], which
///    return it.
@freezed
class TranslateMessageResponse with _$TranslateMessageResponse {
  /// Creates a new [TranslateMessageResponse].
  const TranslateMessageResponse({
    required this.duration,
    required this.message,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The message, with the translation added to its [Message.i18n].
  @override
  final Message message;
}
