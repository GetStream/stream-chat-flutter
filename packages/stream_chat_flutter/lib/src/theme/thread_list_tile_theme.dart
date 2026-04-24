import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/date_formatter.dart';

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
class StreamThreadListTileThemeData with Diagnosticable {
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

  /// A copy of [StreamThreadListTileThemeData] with specified attributes
  /// overridden.
  StreamThreadListTileThemeData copyWith({
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    TextStyle? threadChannelNameStyle,
    TextStyle? threadReplyToMessageStyle,
    TextStyle? threadLatestReplyUsernameStyle,
    TextStyle? threadLatestReplyMessageStyle,
    TextStyle? threadLatestReplyTimestampStyle,
    DateFormatter? threadLatestReplyTimestampFormatter,
    TextStyle? threadReplyCountStyle,
    TextStyle? threadUnreadMessageCountStyle,
    Color? threadUnreadMessageCountBackgroundColor,
  }) => StreamThreadListTileThemeData(
    padding: padding ?? this.padding,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    threadChannelNameStyle: threadChannelNameStyle ?? this.threadChannelNameStyle,
    threadReplyToMessageStyle: threadReplyToMessageStyle ?? this.threadReplyToMessageStyle,
    threadLatestReplyUsernameStyle: threadLatestReplyUsernameStyle ?? this.threadLatestReplyUsernameStyle,
    threadLatestReplyMessageStyle: threadLatestReplyMessageStyle ?? this.threadLatestReplyMessageStyle,
    threadLatestReplyTimestampStyle: threadLatestReplyTimestampStyle ?? this.threadLatestReplyTimestampStyle,
    threadLatestReplyTimestampFormatter:
        threadLatestReplyTimestampFormatter ?? this.threadLatestReplyTimestampFormatter,
    threadReplyCountStyle: threadReplyCountStyle ?? this.threadReplyCountStyle,
    threadUnreadMessageCountStyle: threadUnreadMessageCountStyle ?? this.threadUnreadMessageCountStyle,
    threadUnreadMessageCountBackgroundColor:
        threadUnreadMessageCountBackgroundColor ?? this.threadUnreadMessageCountBackgroundColor,
  );

  /// Merges this [StreamThreadListTileThemeData] with the [other].
  StreamThreadListTileThemeData merge(
    StreamThreadListTileThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      padding: other.padding,
      backgroundColor: other.backgroundColor,
      threadChannelNameStyle: other.threadChannelNameStyle,
      threadReplyToMessageStyle: other.threadReplyToMessageStyle,
      threadLatestReplyUsernameStyle: other.threadLatestReplyUsernameStyle,
      threadLatestReplyMessageStyle: other.threadLatestReplyMessageStyle,
      threadLatestReplyTimestampStyle: other.threadLatestReplyTimestampStyle,
      threadLatestReplyTimestampFormatter: other.threadLatestReplyTimestampFormatter,
      threadReplyCountStyle: other.threadReplyCountStyle,
      threadUnreadMessageCountStyle: other.threadUnreadMessageCountStyle,
      threadUnreadMessageCountBackgroundColor: other.threadUnreadMessageCountBackgroundColor,
    );
  }

  /// Linearly interpolate between two [StreamThreadListTileThemeData].
  StreamThreadListTileThemeData lerp(
    StreamThreadListTileThemeData? a,
    StreamThreadListTileThemeData? b,
    double t,
  ) => StreamThreadListTileThemeData(
    padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t),
    backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
    threadChannelNameStyle: TextStyle.lerp(
      a?.threadChannelNameStyle,
      b?.threadChannelNameStyle,
      t,
    ),
    threadReplyToMessageStyle: TextStyle.lerp(
      a?.threadReplyToMessageStyle,
      b?.threadReplyToMessageStyle,
      t,
    ),
    threadLatestReplyUsernameStyle: TextStyle.lerp(
      a?.threadLatestReplyUsernameStyle,
      b?.threadLatestReplyUsernameStyle,
      t,
    ),
    threadLatestReplyMessageStyle: TextStyle.lerp(
      a?.threadLatestReplyMessageStyle,
      b?.threadLatestReplyMessageStyle,
      t,
    ),
    threadLatestReplyTimestampStyle: TextStyle.lerp(
      a?.threadLatestReplyTimestampStyle,
      b?.threadLatestReplyTimestampStyle,
      t,
    ),
    threadLatestReplyTimestampFormatter: t < 0.5
        ? a?.threadLatestReplyTimestampFormatter
        : b?.threadLatestReplyTimestampFormatter,
    threadReplyCountStyle: TextStyle.lerp(
      a?.threadReplyCountStyle,
      b?.threadReplyCountStyle,
      t,
    ),
    threadUnreadMessageCountStyle: TextStyle.lerp(
      a?.threadUnreadMessageCountStyle,
      b?.threadUnreadMessageCountStyle,
      t,
    ),
    threadUnreadMessageCountBackgroundColor: Color.lerp(
      a?.threadUnreadMessageCountBackgroundColor,
      b?.threadUnreadMessageCountBackgroundColor,
      t,
    ),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamThreadListTileThemeData &&
          other.padding == padding &&
          other.backgroundColor == backgroundColor &&
          other.threadChannelNameStyle == threadChannelNameStyle &&
          other.threadReplyToMessageStyle == threadReplyToMessageStyle &&
          other.threadLatestReplyUsernameStyle == threadLatestReplyUsernameStyle &&
          other.threadLatestReplyMessageStyle == threadLatestReplyMessageStyle &&
          other.threadLatestReplyTimestampStyle == threadLatestReplyTimestampStyle &&
          other.threadLatestReplyTimestampFormatter == threadLatestReplyTimestampFormatter &&
          other.threadReplyCountStyle == threadReplyCountStyle &&
          other.threadUnreadMessageCountStyle == threadUnreadMessageCountStyle &&
          other.threadUnreadMessageCountBackgroundColor == threadUnreadMessageCountBackgroundColor;

  @override
  int get hashCode =>
      padding.hashCode ^
      backgroundColor.hashCode ^
      threadChannelNameStyle.hashCode ^
      threadReplyToMessageStyle.hashCode ^
      threadLatestReplyUsernameStyle.hashCode ^
      threadLatestReplyMessageStyle.hashCode ^
      threadLatestReplyTimestampStyle.hashCode ^
      threadLatestReplyTimestampFormatter.hashCode ^
      threadReplyCountStyle.hashCode ^
      threadUnreadMessageCountStyle.hashCode ^
      threadUnreadMessageCountBackgroundColor.hashCode;
}
