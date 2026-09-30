import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../stream_chat.dart';
import '../stream_chat_configuration.dart';
import 'stream_message_translation_configuration.dart';
import 'stream_message_translation_store.dart';

/// The language to display [message]'s translatable content in, or `null` to
/// display its original text.
///
/// Translations are shown in the current user's language unless they are turned off SDK-wide
/// ([StreamMessageTranslationConfiguration.enabled]) or the user switched
/// this message back to its original text through its translation
/// annotation.
///
/// Returns `null` when [context] is not below a [StreamChat]. Sheets are
/// pushed on the nearest navigator, which an app may have placed above its
/// [StreamChat]: resolve the language from the context that opens a sheet,
/// not from the sheet's own context.
String? messageTranslationLanguageOf(BuildContext context, Message message) {
  final translationConfig = StreamChatConfiguration.maybeOf(context)?.messageTranslation;
  if (translationConfig == null || !translationConfig.enabled) return null;

  final translationStore = StreamMessageTranslations.maybeOf(context, messageId: message.id);
  if (translationStore?.isShowingOriginalText(message.id) ?? false) return null;

  return StreamChat.maybeOf(context)?.currentUser?.language;
}
