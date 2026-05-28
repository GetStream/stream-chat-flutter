import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/date_formatter.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'thread_list_tile_theme.g.theme.dart';

/// {@template streamThreadListTileTheme}
/// Overrides the default style of [StreamThreadListTile] descendants.
///
/// See also:
///
///  * [StreamPollOptionVotesSheetThemeData], which is used to configure this
///    theme.
/// {@endtemplate}
class StreamThreadListTileTheme extends InheritedTheme {
  /// Creates a [StreamThreadListTileTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamThreadListTileTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamThreadListTileThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamThreadListTileTheme] widget, then
  /// [StreamChatThemeData.pollOptionVotesSheetTheme] is used.
  static StreamThreadListTileThemeData of(BuildContext context) {
    final threadListTileTheme = context.dependOnInheritedWidgetOfExactType<StreamThreadListTileTheme>();
    return threadListTileTheme?.data ?? StreamChatTheme.of(context).threadListTileTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamThreadListTileTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamThreadListTileTheme oldWidget) => data != oldWidget.data;
}

/// {@template streamThreadListTileThemeData}
/// Theme data for customizing [StreamThreadListTile] widgets.
///
/// When a property is null the widget falls back to computed defaults derived
/// from the ambient [StreamTextTheme] and [StreamColorScheme]. See
/// [StreamThreadListTile] for the built-in default values.
///
/// See also:
///
///  * [StreamThreadListTileTheme], the inherited theme widget.
///  * [StreamChatThemeData.threadListTileTheme], global theme entry-point.
/// {@endtemplate}
@themeGen
@immutable
class StreamThreadListTileThemeData with _$StreamThreadListTileThemeData {
  /// {@macro streamThreadListTileThemeData}
  const StreamThreadListTileThemeData({
    this.padding,
    this.backgroundColor,
    this.threadChannelNameStyle,
    this.threadReplyToMessageStyle,
    this.threadLatestReplyUsernameStyle,
    this.threadLatestReplyMessageStyle,
    this.threadLatestReplyTimestampStyle,
    this.threadLatestReplyTimestampFormatter,
    this.threadReplyCountStyle,
    this.threadUnreadMessageCountStyle,
    this.threadUnreadMessageCountBackgroundColor,
  });

  /// The padding around the [StreamThreadListTile] widget.
  final EdgeInsetsGeometry? padding;

  /// The background color of the [StreamThreadListTile] widget.
  final Color? backgroundColor;

  /// The style of the channel name in the [StreamThreadListTile] widget.
  ///
  /// Falls back to [StreamTextTheme.captionEmphasis] with
  /// [StreamColorScheme.textTertiary].
  final TextStyle? threadChannelNameStyle;

  /// The style of the root message preview in the [StreamThreadListTile]
  /// widget.
  ///
  /// Falls back to [StreamTextTheme.bodyDefault].
  final TextStyle? threadReplyToMessageStyle;

  /// The style of the latest reply author username in the
  /// [StreamThreadListTile] widget.
  final TextStyle? threadLatestReplyUsernameStyle;

  /// The style of the latest reply message in the [StreamThreadListTile].
  final TextStyle? threadLatestReplyMessageStyle;

  /// The style of the latest reply timestamp in the [StreamThreadListTile].
  ///
  /// Falls back to [StreamTextTheme.captionDefault] with
  /// [StreamColorScheme.textTertiary].
  final TextStyle? threadLatestReplyTimestampStyle;

  /// Formatter for the latest reply timestamp.
  ///
  /// If null, uses [formatRecentDateTime].
  ///
  /// Example:
  /// ```dart
  /// StreamThreadListTileThemeData(
  ///   threadLatestReplyTimestampStyle: TextStyle(...),
  ///   threadLatestReplyTimestampFormatter: (context, date) {
  ///     return Jiffy.parseFromDateTime(date).fromNow(); // "2 hours ago"
  ///   },
  /// )
  /// ```
  final DateFormatter? threadLatestReplyTimestampFormatter;

  /// The style of the reply count label in the thread footer.
  ///
  /// Falls back to [StreamTextTheme.captionEmphasis] with
  /// [StreamColorScheme.textLink].
  final TextStyle? threadReplyCountStyle;

  /// The style of the unread message count in the [StreamThreadListTile].
  final TextStyle? threadUnreadMessageCountStyle;

  /// The background color of the unread message count in the
  /// [StreamThreadListTile].
  final Color? threadUnreadMessageCountBackgroundColor;

  /// Linearly interpolate between two [StreamThreadListTileThemeData].
  static StreamThreadListTileThemeData? lerp(
    StreamThreadListTileThemeData? a,
    StreamThreadListTileThemeData? b,
    double t,
  ) => _$StreamThreadListTileThemeData.lerp(a, b, t);
}
