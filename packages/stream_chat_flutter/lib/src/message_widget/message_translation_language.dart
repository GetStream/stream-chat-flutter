import 'package:flutter/widgets.dart';

import 'components/stream_message_content.dart';

/// The language a message is shown translated into, for the widgets that
/// display parts of it.
///
/// [StreamMessageContent] provides it, deciding once for the whole message
/// whether it is shown translated. The poll attachment and its sheets read it
/// to show the poll's translations, so a custom poll attachment can do the
/// same:
///
/// ```dart
/// final language = MessageTranslationLanguage.of(context);
/// Text(poll.translatedName(language) ?? poll.name);
/// ```
class MessageTranslationLanguage extends InheritedWidget {
  /// Creates a scope showing its message translated into [language].
  const MessageTranslationLanguage({
    super.key,
    required this.language,
    required super.child,
  });

  /// The language to show translations in, or `null` when the message is
  /// shown as written.
  ///
  /// Set whenever translation is on, even when the message has no
  /// translation itself, so content it does not carry, such as the comments
  /// of a poll, is still shown in the reader's language.
  final String? language;

  /// The [language] of the closest enclosing scope, or `null` when there is
  /// none.
  ///
  /// Subscribes [context] to changes. Sheets are pushed outside the message,
  /// so consider reading the language from the context that opens a sheet
  /// and providing it to the sheet in a scope of its own.
  static String? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MessageTranslationLanguage>()?.language;
  }

  @override
  bool updateShouldNotify(MessageTranslationLanguage oldWidget) => language != oldWidget.language;
}
