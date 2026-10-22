import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'stream_chat_theme.dart';

part 'message_preview_theme.g.theme.dart';

/// Overrides the default style of [StreamMessagePreviewText] and
/// [StreamDraftMessagePreviewText] descendants.
///
/// See also:
///
///  * [StreamMessagePreviewThemeData], which is used to configure this theme.
class StreamMessagePreviewTheme extends InheritedTheme {
  /// Creates a [StreamMessagePreviewTheme].
  const StreamMessagePreviewTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamMessagePreviewThemeData data;

  /// The [StreamMessagePreviewThemeData] for the given context.
  ///
  /// Values from the nearest [StreamMessagePreviewTheme] ancestor take
  /// precedence over [StreamChatThemeData.messagePreviewTheme].
  static StreamMessagePreviewThemeData of(BuildContext context) {
    final localTheme = context.dependOnInheritedWidgetOfExactType<StreamMessagePreviewTheme>();
    return StreamChatTheme.of(context).messagePreviewTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamMessagePreviewTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamMessagePreviewTheme oldWidget) => data != oldWidget.data;
}

/// {@template streamMessagePreviewThemeData}
/// Theme data for the parts of a message preview that are styled apart from
/// the surrounding text.
///
/// A message preview takes its base text style from where it is shown, such
/// as a channel list item's subtitle or a quoted reply. These styles apply on
/// top of that base. When a property is null the preview falls back to
/// defaults derived from the ambient [StreamColorScheme].
///
/// See also:
///
///  * [StreamMessagePreviewTheme], which overrides the theme for a subtree.
///  * [StreamChatThemeData.messagePreviewTheme], which sets the theme
///    app-wide.
///  * [StreamQuotedMessageThemeData.previewStyle], which styles the preview
///    inside a quoted reply.
/// {@endtemplate}
@themeGen
@immutable
class StreamMessagePreviewThemeData with _$StreamMessagePreviewThemeData {
  /// {@macro streamMessagePreviewThemeData}
  const StreamMessagePreviewThemeData({
    this.deletedTextStyle,
    this.draftLabelStyle,
  });

  /// The text style for the deleted-message label and its icon.
  final TextStyle? deletedTextStyle;

  /// The text style for the "Draft:" label shown before a draft preview.
  final TextStyle? draftLabelStyle;

  /// Linearly interpolates between two [StreamMessagePreviewThemeData]
  /// objects.
  static StreamMessagePreviewThemeData? lerp(
    StreamMessagePreviewThemeData? a,
    StreamMessagePreviewThemeData? b,
    double t,
  ) => _$StreamMessagePreviewThemeData.lerp(a, b, t);
}
