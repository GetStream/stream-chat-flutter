import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// {@template streamThreadListTileTheme}
/// Overrides the default style of [StreamThreadListTile] descendants.
///
/// See also:
///
///  * [StreamPollOptionVotesDialogThemeData], which is used to configure this
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
  /// [StreamChatThemeData.pollOptionVotesDialogTheme] is used.
  static StreamThreadListTileThemeData of(BuildContext context) {
    final threadListTileTheme =
        context.dependOnInheritedWidgetOfExactType<StreamThreadListTileTheme>();
    return threadListTileTheme?.data ??
        StreamChatTheme.of(context).threadListTileTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      StreamThreadListTileTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamThreadListTileTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@template streamThreadListTileThemeData}
/// A style that overrides the default appearance of
/// [StreamPollOptionVotesDialog] widgets when used with
/// [StreamPollCommentsDialogTheme] or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.pollOptionVotesDialogTheme].
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
    this.threadUnreadMessageCountStyle,
    this.threadUnreadMessageCountBackgroundColor,
  });

  /// The padding around the [StreamThreadListTile] widget.
  final EdgeInsetsGeometry? padding;

  /// The background color of the [StreamThreadListTile] widget.
  final Color? backgroundColor;

  /// The style of the channel name in the [StreamThreadListTile] widget.
  final TextStyle? threadChannelNameStyle;

  /// The style of the message the thread is replying to in the
  /// [StreamThreadListTile] widget.
  final TextStyle? threadReplyToMessageStyle;

  /// The style of the latest reply author username in the
  /// [StreamThreadListTile] widget.
  final TextStyle? threadLatestReplyUsernameStyle;

  /// The style of the latest reply message in the [StreamThreadListTile].
  /// widget.
  final TextStyle? threadLatestReplyMessageStyle;

  /// The style of the latest reply timestamp in the [StreamThreadListTile].
  final TextStyle? threadLatestReplyTimestampStyle;

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
    TextStyle? threadUnreadMessageCountStyle,
    Color? threadUnreadMessageCountBackgroundColor,
  }) =>
      StreamThreadListTileThemeData(
        padding: padding ?? this.padding,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        threadChannelNameStyle:
            threadChannelNameStyle ?? this.threadChannelNameStyle,
        threadReplyToMessageStyle:
            threadReplyToMessageStyle ?? this.threadReplyToMessageStyle,
        threadLatestReplyUsernameStyle: threadLatestReplyUsernameStyle ??
            this.threadLatestReplyUsernameStyle,
        threadLatestReplyMessageStyle:
            threadLatestReplyMessageStyle ?? this.threadLatestReplyMessageStyle,
        threadLatestReplyTimestampStyle: threadLatestReplyTimestampStyle ??
            this.threadLatestReplyTimestampStyle,
        threadUnreadMessageCountStyle:
            threadUnreadMessageCountStyle ?? this.threadUnreadMessageCountStyle,
        threadUnreadMessageCountBackgroundColor:
            threadUnreadMessageCountBackgroundColor ??
                this.threadUnreadMessageCountBackgroundColor,
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
      threadUnreadMessageCountStyle: other.threadUnreadMessageCountStyle,
      threadUnreadMessageCountBackgroundColor:
          other.threadUnreadMessageCountBackgroundColor,
    );
  }

  /// Linearly interpolate between two [StreamThreadListTileThemeData].
  StreamThreadListTileThemeData lerp(
    StreamThreadListTileThemeData? a,
    StreamThreadListTileThemeData? b,
    double t,
  ) =>
      StreamThreadListTileThemeData(
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
          other.threadLatestReplyUsernameStyle ==
              threadLatestReplyUsernameStyle &&
          other.threadLatestReplyMessageStyle ==
              threadLatestReplyMessageStyle &&
          other.threadLatestReplyTimestampStyle ==
              threadLatestReplyTimestampStyle &&
          other.threadUnreadMessageCountStyle ==
              threadUnreadMessageCountStyle &&
          other.threadUnreadMessageCountBackgroundColor ==
              threadUnreadMessageCountBackgroundColor;

  @override
  int get hashCode =>
      padding.hashCode ^
      backgroundColor.hashCode ^
      threadChannelNameStyle.hashCode ^
      threadReplyToMessageStyle.hashCode ^
      threadLatestReplyUsernameStyle.hashCode ^
      threadLatestReplyMessageStyle.hashCode ^
      threadLatestReplyTimestampStyle.hashCode ^
      threadUnreadMessageCountStyle.hashCode ^
      threadUnreadMessageCountBackgroundColor.hashCode;
}
