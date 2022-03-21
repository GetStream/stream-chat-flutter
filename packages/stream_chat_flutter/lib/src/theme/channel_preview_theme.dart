import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/theme/avatar_theme.dart';

/// {@macro channel_preview_theme}
@Deprecated("Use 'StreamChannelPreviewTheme' instead")
typedef ChannelPreviewTheme = StreamChannelPreviewTheme;

/// {@template channel_preview_theme}
/// Overrides the default style of [ChannelPreview] descendants.
///
/// See also:
///
///  * [StreamChannelPreviewThemeData], which is used to configure this theme.
/// {@endtemplate}
class StreamChannelPreviewTheme extends InheritedTheme {
  /// Creates a [StreamChannelPreviewTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamChannelPreviewTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final StreamChannelPreviewThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamChannelPreviewTheme] widget, then
  /// [StreamChatThemeData.channelPreviewTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = ChannelPreviewTheme.of(context);
  /// ```
  static StreamChannelPreviewThemeData of(BuildContext context) {
    final channelPreviewTheme =
        context.dependOnInheritedWidgetOfExactType<StreamChannelPreviewTheme>();
    return channelPreviewTheme?.data ??
        StreamChatTheme.of(context).channelPreviewTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      StreamChannelPreviewTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamChannelPreviewTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@macro channel_preview_theme_data}
@Deprecated("Use 'StreamChannelPreviewThemeData' instead")
typedef ChannelPreviewThemeData = StreamChannelPreviewThemeData;

/// {@template channel_preview_theme_data}
/// A style that overrides the default appearance of [ChannelPreview]s when used
/// with [StreamChannelPreviewTheme] or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.channelPreviewTheme].
///
/// See also:
///
/// * [StreamChannelPreviewTheme], the theme which is configured with this class.
/// * [StreamChatThemeData.channelPreviewTheme], which can be used to override
/// the default style for [ChannelHeader]s below the overall [StreamChatTheme].
/// {@endtemplate}
class StreamChannelPreviewThemeData with Diagnosticable {
  /// Creates a [StreamChannelPreviewThemeData].
  const StreamChannelPreviewThemeData({
    this.titleStyle,
    this.subtitleStyle,
    this.lastMessageAtStyle,
    this.avatarTheme,
    this.unreadCounterColor,
    this.indicatorIconSize,
  });

  /// Theme for title
  final TextStyle? titleStyle;

  /// Theme for subtitle
  final TextStyle? subtitleStyle;

  /// Theme of last message at
  final TextStyle? lastMessageAtStyle;

  /// Avatar theme
  final StreamAvatarThemeData? avatarTheme;

  /// Unread counter color
  final Color? unreadCounterColor;

  /// Indicator icon size
  final double? indicatorIconSize;

  /// Copy with theme
  StreamChannelPreviewThemeData copyWith({
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? lastMessageAtStyle,
    StreamAvatarThemeData? avatarTheme,
    Color? unreadCounterColor,
    double? indicatorIconSize,
  }) =>
      StreamChannelPreviewThemeData(
        titleStyle: titleStyle ?? this.titleStyle,
        subtitleStyle: subtitleStyle ?? this.subtitleStyle,
        lastMessageAtStyle: lastMessageAtStyle ?? this.lastMessageAtStyle,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        unreadCounterColor: unreadCounterColor ?? this.unreadCounterColor,
        indicatorIconSize: indicatorIconSize ?? this.indicatorIconSize,
      );

  /// Linearly interpolate one [StreamChannelPreviewThemeData] to another.
  StreamChannelPreviewThemeData lerp(
    StreamChannelPreviewThemeData a,
    StreamChannelPreviewThemeData b,
    double t,
  ) =>
      StreamChannelPreviewThemeData(
        avatarTheme: const StreamAvatarThemeData()
            .lerp(a.avatarTheme!, b.avatarTheme!, t),
        indicatorIconSize: a.indicatorIconSize,
        lastMessageAtStyle:
            TextStyle.lerp(a.lastMessageAtStyle, b.lastMessageAtStyle, t),
        subtitleStyle: TextStyle.lerp(a.subtitleStyle, b.subtitleStyle, t),
        titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
        unreadCounterColor:
            Color.lerp(a.unreadCounterColor, b.unreadCounterColor, t),
      );

  /// Merge with theme
  StreamChannelPreviewThemeData merge(StreamChannelPreviewThemeData? other) {
    if (other == null) return this;
    return copyWith(
      titleStyle: titleStyle?.merge(other.titleStyle) ?? other.titleStyle,
      subtitleStyle:
          subtitleStyle?.merge(other.subtitleStyle) ?? other.subtitleStyle,
      lastMessageAtStyle: lastMessageAtStyle?.merge(other.lastMessageAtStyle) ??
          other.lastMessageAtStyle,
      avatarTheme: avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
      unreadCounterColor: other.unreadCounterColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamChannelPreviewThemeData &&
          runtimeType == other.runtimeType &&
          titleStyle == other.titleStyle &&
          subtitleStyle == other.subtitleStyle &&
          lastMessageAtStyle == other.lastMessageAtStyle &&
          avatarTheme == other.avatarTheme &&
          unreadCounterColor == other.unreadCounterColor &&
          indicatorIconSize == other.indicatorIconSize;

  @override
  int get hashCode =>
      titleStyle.hashCode ^
      subtitleStyle.hashCode ^
      lastMessageAtStyle.hashCode ^
      avatarTheme.hashCode ^
      unreadCounterColor.hashCode ^
      indicatorIconSize.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('titleStyle', titleStyle))
      ..add(DiagnosticsProperty('subtitleStyle', subtitleStyle))
      ..add(DiagnosticsProperty('lastMessageAtStyle', lastMessageAtStyle))
      ..add(DiagnosticsProperty('avatarTheme', avatarTheme))
      ..add(ColorProperty('unreadCounterColor', unreadCounterColor));
  }
}
