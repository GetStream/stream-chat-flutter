import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'stream_chat_theme.dart';

part 'message_preview_text_theme.g.theme.dart';

/// A theme that overrides the style of [StreamMessagePreviewText] and
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
  /// The nearest [StreamMessagePreviewTextTheme] ancestor's data, or
  /// [StreamChatThemeData.messagePreviewTextTheme] when there is none.
  static StreamMessagePreviewTextThemeData of(BuildContext context) {
    final localTheme = context.dependOnInheritedWidgetOfExactType<StreamMessagePreviewTextTheme>();
    return localTheme?.data ?? StreamChatTheme.of(context).messagePreviewTextTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamMessagePreviewTextTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamMessagePreviewTextTheme oldWidget) => data != oldWidget.data;
}

/// {@template streamMessagePreviewTextThemeData}
/// Theme data for parts of a message preview styled apart from the rest.
///
/// To style the whole preview, use the subtitle style where it is shown, such
/// as [StreamChannelListItemThemeData.subtitleStyle] or
/// [StreamQuotedMessageThemeData.subtitleTextStyle].
///
/// See also:
///
///  * [StreamMessagePreviewTextTheme], which overrides the theme for a subtree.
///  * [StreamChatThemeData.messagePreviewTextTheme], which sets the theme
///    app-wide.
///  * [StreamQuotedMessageThemeData.messagePreviewTextTheme], which styles
///    the preview inside a quoted reply.
/// {@endtemplate}
@themeGen
@immutable
class StreamMessagePreviewTextThemeData with _$StreamMessagePreviewTextThemeData {
  /// {@macro streamMessagePreviewTextThemeData}
  const StreamMessagePreviewTextThemeData({
    this.draftPrefixStyle,
    this.senderPrefixStyle,
    this.deletedMessageStyle,
  });

  /// The text style for the "Draft:" prefix that starts a
  /// [StreamDraftMessagePreviewText].
  ///
  /// If null, defaults to bold in the primary accent color.
  final TextStyle? draftPrefixStyle;

  /// The text style for the sender prefix, such as "You:" or "Ann:", that
  /// starts a preview in a channel or thread list.
  ///
  /// If null, defaults to bold.
  final TextStyle? senderPrefixStyle;

  /// The text style for the "Message deleted" text and its icon.
  ///
  /// If null, matches the rest of the preview.
  final TextStyle? deletedMessageStyle;

  /// Linearly interpolates between two [StreamMessagePreviewTextThemeData]
  /// objects.
  static StreamMessagePreviewTextThemeData? lerp(
    StreamMessagePreviewTextThemeData? a,
    StreamMessagePreviewTextThemeData? b,
    double t,
  ) => _$StreamMessagePreviewTextThemeData.lerp(a, b, t);
}
