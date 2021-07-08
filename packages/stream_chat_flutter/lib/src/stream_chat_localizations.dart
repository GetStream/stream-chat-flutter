import 'package:flutter/widgets.dart';

// TODO : Fix localization instructions
// ADDING A NEW STRING
//
// If you (someone contributing to the Stream Chat Flutter) want to add a new
// string to the StreamChatLocalizations object (e.g. because you've added a new
// widget and it has a tooltip), follow these steps:
//
// 1. Add the new getter to StreamChatLocalizations below.
//
// 2. Implement a default value in DefaultMaterialLocalizations below.
//
// 3. Add a test to test/material/localizations_test.dart that verifies that
//    this new value is implemented.
//
// 4. Update the flutter_localizations package. To add a new string to the
//    flutter_localizations package, you must first add it to the English
//    translations (lib/src/l10n/en.json), including a description.
//
//    Then you need to add new entries for the string to all of the other
//    language locale files by running:
//    ```
//    dart dev/tools/localization/bin/gen_missing_localizations.dart
//    ```
//    Which will copy the english strings into the other locales as placeholders
//    until they can be translated.
//
//    Finally you need to re-generate lib/src/l10n/localizations.dart by running:
//    ```
//    dart dev/tools/localization/bin/gen_localizations.dart --overwrite
//    ```
//
//    There is a README file with further information in the lib/src/l10n/
//    directory.
//
// 5. If you are a Google employee, you should then also follow the instructions
//    at go/flutter-l10n. If you're not, don't worry about it.
//
// UPDATING AN EXISTING STRING
//
// If you (someone contributing to the Flutter framework) want to modify an
// existing string in the MaterialLocalizations objects, follow these steps:
//
// 1. Modify the default value of the relevant getter(s) in
//    DefaultMaterialLocalizations below.
//
// 2. Update the flutter_localizations package. Modify the out-of-date English
//    strings in lib/src/l10n/material_en.arb.
//
//    You also need to re-generate lib/src/l10n/localizations.dart by running:
//    ```
//    dart dev/tools/localization/bin/gen_localizations.dart --overwrite
//    ```
//
//    This script may result in your updated getters being created in newer
//    locales and set to the old value of the strings. This is to be expected.
//    Leave them as they were generated, and they will be picked up for
//    translation.
//
//    There is a README file with further information in the lib/src/l10n/
//    directory.
//
// 3. If you are a Google employee, you should then also follow the instructions
//    at go/flutter-l10n. If you're not, don't worry about it.

/// Defines the localized resource values used by the StreamChatFlutter widgets.
///
/// See also:
///
///  * [GlobalStreamChatLocalizations], which provides material localizations
///    for many languages.
abstract class StreamChatLocalizations {
  /// The `StreamChatLocalizations` from the closest [Localizations] instance
  /// that encloses the given context.
  ///
  /// If no [StreamChatLocalizations] are available in the given `context`, this
  /// method returns null.
  ///
  /// This method is just a convenient shorthand for:
  /// `Localizations.of<StreamChatLocalizations>(context, StreamChatLocalizations)`.
  ///
  /// References to the localized resources defined by this class are typically
  /// written in terms of this method. For example:
  ///
  /// ```dart
  /// tooltip: StreamChatLocalizations.of(context).backButtonTooltip,
  /// ```
  static StreamChatLocalizations? of(BuildContext context) =>
      Localizations.of<StreamChatLocalizations>(
        context,
        StreamChatLocalizations,
      );

  String get launchUrlError;
}
