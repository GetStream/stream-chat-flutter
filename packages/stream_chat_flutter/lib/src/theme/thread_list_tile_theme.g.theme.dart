// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'thread_list_tile_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamThreadListTileThemeData {
  bool get canMerge => true;

  static StreamThreadListTileThemeData? lerp(
    StreamThreadListTileThemeData? a,
    StreamThreadListTileThemeData? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null) {
      return t == 1.0 ? b : null;
    }

    if (b == null) {
      return t == 0.0 ? a : null;
    }

    return StreamThreadListTileThemeData(
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      threadChannelNameStyle: TextStyle.lerp(
        a.threadChannelNameStyle,
        b.threadChannelNameStyle,
        t,
      ),
      threadReplyToMessageStyle: TextStyle.lerp(
        a.threadReplyToMessageStyle,
        b.threadReplyToMessageStyle,
        t,
      ),
      threadLatestReplyUsernameStyle: TextStyle.lerp(
        a.threadLatestReplyUsernameStyle,
        b.threadLatestReplyUsernameStyle,
        t,
      ),
      threadLatestReplyMessageStyle: TextStyle.lerp(
        a.threadLatestReplyMessageStyle,
        b.threadLatestReplyMessageStyle,
        t,
      ),
      threadLatestReplyTimestampStyle: TextStyle.lerp(
        a.threadLatestReplyTimestampStyle,
        b.threadLatestReplyTimestampStyle,
        t,
      ),
      threadLatestReplyTimestampFormatter: t < 0.5
          ? a.threadLatestReplyTimestampFormatter
          : b.threadLatestReplyTimestampFormatter,
      threadReplyCountStyle: TextStyle.lerp(
        a.threadReplyCountStyle,
        b.threadReplyCountStyle,
        t,
      ),
      threadUnreadMessageCountStyle: TextStyle.lerp(
        a.threadUnreadMessageCountStyle,
        b.threadUnreadMessageCountStyle,
        t,
      ),
      threadUnreadMessageCountBackgroundColor: Color.lerp(
        a.threadUnreadMessageCountBackgroundColor,
        b.threadUnreadMessageCountBackgroundColor,
        t,
      ),
    );
  }

  StreamThreadListTileThemeData copyWith({
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    TextStyle? threadChannelNameStyle,
    TextStyle? threadReplyToMessageStyle,
    TextStyle? threadLatestReplyUsernameStyle,
    TextStyle? threadLatestReplyMessageStyle,
    TextStyle? threadLatestReplyTimestampStyle,
    String Function(BuildContext, DateTime)?
    threadLatestReplyTimestampFormatter,
    TextStyle? threadReplyCountStyle,
    TextStyle? threadUnreadMessageCountStyle,
    Color? threadUnreadMessageCountBackgroundColor,
  }) {
    final _this = (this as StreamThreadListTileThemeData);

    return StreamThreadListTileThemeData(
      padding: padding ?? _this.padding,
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      threadChannelNameStyle:
          threadChannelNameStyle ?? _this.threadChannelNameStyle,
      threadReplyToMessageStyle:
          threadReplyToMessageStyle ?? _this.threadReplyToMessageStyle,
      threadLatestReplyUsernameStyle:
          threadLatestReplyUsernameStyle ??
          _this.threadLatestReplyUsernameStyle,
      threadLatestReplyMessageStyle:
          threadLatestReplyMessageStyle ?? _this.threadLatestReplyMessageStyle,
      threadLatestReplyTimestampStyle:
          threadLatestReplyTimestampStyle ??
          _this.threadLatestReplyTimestampStyle,
      threadLatestReplyTimestampFormatter:
          threadLatestReplyTimestampFormatter ??
          _this.threadLatestReplyTimestampFormatter,
      threadReplyCountStyle:
          threadReplyCountStyle ?? _this.threadReplyCountStyle,
      threadUnreadMessageCountStyle:
          threadUnreadMessageCountStyle ?? _this.threadUnreadMessageCountStyle,
      threadUnreadMessageCountBackgroundColor:
          threadUnreadMessageCountBackgroundColor ??
          _this.threadUnreadMessageCountBackgroundColor,
    );
  }

  StreamThreadListTileThemeData merge(StreamThreadListTileThemeData? other) {
    final _this = (this as StreamThreadListTileThemeData);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      padding: other.padding,
      backgroundColor: other.backgroundColor,
      threadChannelNameStyle:
          _this.threadChannelNameStyle?.merge(other.threadChannelNameStyle) ??
          other.threadChannelNameStyle,
      threadReplyToMessageStyle:
          _this.threadReplyToMessageStyle?.merge(
            other.threadReplyToMessageStyle,
          ) ??
          other.threadReplyToMessageStyle,
      threadLatestReplyUsernameStyle:
          _this.threadLatestReplyUsernameStyle?.merge(
            other.threadLatestReplyUsernameStyle,
          ) ??
          other.threadLatestReplyUsernameStyle,
      threadLatestReplyMessageStyle:
          _this.threadLatestReplyMessageStyle?.merge(
            other.threadLatestReplyMessageStyle,
          ) ??
          other.threadLatestReplyMessageStyle,
      threadLatestReplyTimestampStyle:
          _this.threadLatestReplyTimestampStyle?.merge(
            other.threadLatestReplyTimestampStyle,
          ) ??
          other.threadLatestReplyTimestampStyle,
      threadLatestReplyTimestampFormatter:
          other.threadLatestReplyTimestampFormatter,
      threadReplyCountStyle:
          _this.threadReplyCountStyle?.merge(other.threadReplyCountStyle) ??
          other.threadReplyCountStyle,
      threadUnreadMessageCountStyle:
          _this.threadUnreadMessageCountStyle?.merge(
            other.threadUnreadMessageCountStyle,
          ) ??
          other.threadUnreadMessageCountStyle,
      threadUnreadMessageCountBackgroundColor:
          other.threadUnreadMessageCountBackgroundColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as StreamThreadListTileThemeData);
    final _other = (other as StreamThreadListTileThemeData);

    return _other.padding == _this.padding &&
        _other.backgroundColor == _this.backgroundColor &&
        _other.threadChannelNameStyle == _this.threadChannelNameStyle &&
        _other.threadReplyToMessageStyle == _this.threadReplyToMessageStyle &&
        _other.threadLatestReplyUsernameStyle ==
            _this.threadLatestReplyUsernameStyle &&
        _other.threadLatestReplyMessageStyle ==
            _this.threadLatestReplyMessageStyle &&
        _other.threadLatestReplyTimestampStyle ==
            _this.threadLatestReplyTimestampStyle &&
        _other.threadLatestReplyTimestampFormatter ==
            _this.threadLatestReplyTimestampFormatter &&
        _other.threadReplyCountStyle == _this.threadReplyCountStyle &&
        _other.threadUnreadMessageCountStyle ==
            _this.threadUnreadMessageCountStyle &&
        _other.threadUnreadMessageCountBackgroundColor ==
            _this.threadUnreadMessageCountBackgroundColor;
  }

  @override
  int get hashCode {
    final _this = (this as StreamThreadListTileThemeData);

    return Object.hash(
      runtimeType,
      _this.padding,
      _this.backgroundColor,
      _this.threadChannelNameStyle,
      _this.threadReplyToMessageStyle,
      _this.threadLatestReplyUsernameStyle,
      _this.threadLatestReplyMessageStyle,
      _this.threadLatestReplyTimestampStyle,
      _this.threadLatestReplyTimestampFormatter,
      _this.threadReplyCountStyle,
      _this.threadUnreadMessageCountStyle,
      _this.threadUnreadMessageCountBackgroundColor,
    );
  }
}
