import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'stream_chat_theme.dart';

part 'message_preview_text_theme.g.theme.dart';

/// Overrides the default style of [StreamMessagePreviewText] and
/// [StreamDraftMessagePreviewText] descendants.
///
/// See also:
///
///  * [StreamMessagePreviewTextThemeData], which is used to configure this
///    theme.
class StreamMessagePreviewTextTheme extends InheritedTheme {
  /// Creates a [StreamMessagePreviewTextTheme].
  const StreamMessagePreviewTextTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamMessagePreviewTextThemeData data;

  /// The [StreamMessagePreviewTextThemeData] for the given context.
  ///
  /// Values from the nearest [StreamMessagePreviewTextTheme] ancestor take
  /// precedence over [StreamChatThemeData.messagePreviewTextTheme].
  static StreamMessagePreviewTextThemeData of(BuildContext context) {
    final localTheme = context.dependOnInheritedWidgetOfExactType<StreamMessagePreviewTextTheme>();
    return StreamChatTheme.of(context).messagePreviewTextTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamMessagePreviewTextTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamMessagePreviewTextTheme oldWidget) => data != oldWidget.data;
}

/// {@template streamMessagePreviewTextThemeData}
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
///  * [StreamMessagePreviewTextTheme], which overrides the theme for a subtree.
///  * [StreamChatThemeData.messagePreviewTextTheme], which sets the theme
///    app-wide.
///  * [StreamQuotedMessageThemeData.previewStyle], which styles the preview
///    inside a quoted reply.
/// {@endtemplate}
@themeGen
@immutable
class StreamMessagePreviewTextThemeData with _$StreamMessagePreviewTextThemeData {
  /// {@macro streamMessagePreviewTextThemeData}
  const StreamMessagePreviewTextThemeData({
    this.deletedTextStyle,
    this.draftLabelStyle,
    this.senderTextStyle,
  });

  /// The text style for the deleted-message label and its icon.
  final TextStyle? deletedTextStyle;

  /// The text style for the "Draft:" label that starts a
  /// [StreamDraftMessagePreviewText].
  final TextStyle? draftLabelStyle;

  /// The text style for the sender name, such as "You:" or "Ann:", that
  /// starts a preview in a channel list.
  final TextStyle? senderTextStyle;

  /// Linearly interpolates between two [StreamMessagePreviewTextThemeData]
  /// objects.
  static StreamMessagePreviewTextThemeData? lerp(
    StreamMessagePreviewTextThemeData? a,
    StreamMessagePreviewTextThemeData? b,
    double t,
  ) => _$StreamMessagePreviewTextThemeData.lerp(a, b, t);
}
