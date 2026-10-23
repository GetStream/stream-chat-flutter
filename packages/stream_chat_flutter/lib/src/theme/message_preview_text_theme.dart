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
/// Theme data for parts of a message preview styled apart from the rest.
///
/// A set style keeps the default for anything it leaves out. To style the
/// whole preview, consider the subtitle style where it is shown, such as
/// [StreamChannelListItemThemeData.subtitleStyle] or
/// [StreamQuotedMessageThemeData.subtitleTextStyle].
///
/// See also:
///
///  * [StreamMessagePreviewTextTheme], which overrides the theme for a subtree.
///  * [StreamChatThemeData.messagePreviewTextTheme], which sets the theme
///    app-wide.
///  * [StreamQuotedMessageThemeData.messagePreviewTextTheme],
///    [StreamChannelListItemThemeData.messagePreviewTextTheme] and
///    [StreamThreadListTileThemeData.messagePreviewTextTheme], which style the
///    preview in each component.
/// {@endtemplate}
@themeGen
@immutable
class StreamMessagePreviewTextThemeData with _$StreamMessagePreviewTextThemeData {
  /// {@macro streamMessagePreviewTextThemeData}
  const StreamMessagePreviewTextThemeData({
    this.draftPrefixStyle,
    this.senderPrefixStyle,
    this.deletedContentStyle,
  });

  /// The text style for the "Draft:" prefix that starts a
  /// [StreamDraftMessagePreviewText].
  ///
  /// Defaults to bold in the primary accent color.
  final TextStyle? draftPrefixStyle;

  /// The text style for the sender prefix, such as "You:" or "Ann:", that
  /// starts a preview in a channel or thread list.
  ///
  /// Defaults to bold.
  final TextStyle? senderPrefixStyle;

  /// The text style for the "Message deleted" text and its icon.
  ///
  /// If null, matches the rest of the preview, except in the channel list,
  /// thread list and message search, which use a muted color.
  final TextStyle? deletedContentStyle;

  /// Linearly interpolates between two [StreamMessagePreviewTextThemeData]
  /// objects.
  static StreamMessagePreviewTextThemeData? lerp(
    StreamMessagePreviewTextThemeData? a,
    StreamMessagePreviewTextThemeData? b,
    double t,
  ) => _$StreamMessagePreviewTextThemeData.lerp(a, b, t);
}
