import 'package:flutter/widgets.dart';

import 'components/stream_message_content.dart';

/// The language a message is displayed translated into, for the widgets that
/// display parts of it.
///
/// Provided by [StreamMessageContent], which decides once whether a message is
/// shown translated. Content that the message does not carry itself, such as
/// the comments a poll sheet pages in, reads it to be shown in the same
/// language as the rest of the message.
class MessageTranslationLanguage extends InheritedWidget {
  /// Creates a scope displaying its message in [language].
  const MessageTranslationLanguage({
    super.key,
    required this.language,
    required super.child,
  });

  /// The language the message is displayed in, or `null` when it is displayed
  /// as written.
  final String? language;

  /// The language the message enclosing [context] is displayed in, or `null`
  /// when it is displayed as written or [context] is not below a
  /// [StreamMessageContent].
  ///
  /// Meant for the moment a sheet is opened, so [context] does not come to
  /// depend on the scope. Sheets are pushed on the nearest navigator, outside
  /// of the message: read the language from the context that opens a sheet,
  /// not from the sheet's own context. The value read is not updated while
  /// the sheet is open.
  static String? of(BuildContext context) {
    return context.getInheritedWidgetOfExactType<MessageTranslationLanguage>()?.language;
  }

  @override
  bool updateShouldNotify(MessageTranslationLanguage oldWidget) => language != oldWidget.language;
}
