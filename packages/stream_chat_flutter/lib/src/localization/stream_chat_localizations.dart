import 'package:flutter/widgets.dart';

import 'package:stream_chat_flutter/src/localization/translations.dart'
    show Translations;

/// Defines the localized resource values used by the StreamChatFlutter widgets.
///
/// See also:
///
///  * [GlobalStreamChatLocalizations], which provides material localizations
///    for many languages.
abstract class StreamChatLocalizations implements Translations {
  /// The `StreamChatLocalizations` from the closest [Localizations] instance
  /// that encloses the given context.
  ///
  /// If no [StreamChatLocalizations] are available in the given `context`, this
  /// method returns null.
  ///
  /// This method is just a convenient shorthand for:
  /// `Localizations.of<StreamChatLocalizations>(
  ///     context,
  ///     StreamChatLocalizations
  /// )`.
  ///
  /// References to the localized resources defined by this class are typically
  /// written in terms of this method. For example:
  ///
  /// ```dart
  /// tooltip: StreamChatLocalizations.of(context).streamChatLabel,
  /// ```
  static StreamChatLocalizations? of(BuildContext context) =>
      Localizations.of<StreamChatLocalizations>(
        context,
        StreamChatLocalizations,
      );
}
