import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../message_widget/stream_message_translation_configuration.dart';
import '../message_widget/stream_message_translation_store.dart';
import '../stream_chat.dart';
import '../stream_chat_configuration.dart';

/// The language to display the poll of [message] in, or `null` to display its
/// original text.
///
/// Follows the same rules as the message's own text: translations are shown
/// in the current user's language unless they are turned off SDK-wide
/// ([StreamMessageTranslationConfiguration.enabled]) or the user switched
/// this message back to its original text through its translation
/// annotation.
///
/// Returns `null` when [context] is not below a [StreamChat]. Poll sheets are
/// pushed on the nearest navigator, which an app may have placed above its
/// [StreamChat]: resolve the language from the context that opens a sheet,
/// not from the sheet's own context.
String? pollTranslationLanguageOf(BuildContext context, Message message) {
  final translationConfig = StreamChatConfiguration.maybeOf(context)?.messageTranslation;
  if (translationConfig == null || !translationConfig.enabled) return null;

  final translationStore = StreamMessageTranslations.maybeOf(context, messageId: message.id);
  if (translationStore?.isShowingOriginalText(message.id) ?? false) return null;

  return StreamChat.maybeOf(context)?.currentUser?.language;
}
