import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/theme/avatar_theme.dart';

/// Overrides the default style of [ChannelPreview] descendants.
///
/// See also:
///
///  * [ChannelPreviewThemeData], which is used to configure this theme.
class ChannelPreviewTheme extends InheritedTheme {
  /// Creates a [ChannelPreviewTheme].
  ///
  /// The [data] parameter must not be null.
  const ChannelPreviewTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final ChannelPreviewThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [ChannelPreviewTheme] widget, then
  /// [StreamChatThemeData.channelPreviewTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = ChannelPreviewTheme.of(context);
  /// ```
  static ChannelPreviewThemeData of(BuildContext context) {
    final channelPreviewTheme =
        context.dependOnInheritedWidgetOfExactType<ChannelPreviewTheme>();
    return channelPreviewTheme?.data ??
        StreamChatTheme.of(context).channelPreviewTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      ChannelPreviewTheme(data: data, child: child);

  @override
  bool updateShouldNotify(ChannelPreviewTheme oldWidget) =>
      data != oldWidget.data;
}

/// A style that overrides the default appearance of [ChannelPreview]s when used
/// with [ChannelPreviewTheme] or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.channelPreviewTheme].
///
/// See also:
///
/// * [ChannelPreviewTheme], the theme which is configured with this class.
/// * [StreamChatThemeData.channelPreviewTheme], which can be used to override
/// the default style for [ChannelHeader]s below the overall [StreamChatTheme].
class ChannelPreviewThemeData with Diagnosticable {
  /// Creates a [ChannelPreviewThemeData].
  const ChannelPreviewThemeData({
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
  final AvatarThemeData? avatarTheme;

  /// Unread counter color
  final Color? unreadCounterColor;

  /// Indicator icon size
  final double? indicatorIconSize;

  /// Copy with theme
  ChannelPreviewThemeData copyWith({
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? lastMessageAtStyle,
    AvatarThemeData? avatarTheme,
    Color? unreadCounterColor,
    double? indicatorIconSize,
  }) =>
      ChannelPreviewThemeData(
        titleStyle: titleStyle ?? this.titleStyle,
        subtitleStyle: subtitleStyle ?? this.subtitleStyle,
        lastMessageAtStyle: lastMessageAtStyle ?? this.lastMessageAtStyle,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        unreadCounterColor: unreadCounterColor ?? this.unreadCounterColor,
        indicatorIconSize: indicatorIconSize ?? this.indicatorIconSize,
      );

  /// Linearly interpolate one [ChannelPreviewThemeData] to another.
  ChannelPreviewThemeData lerp(
    ChannelPreviewThemeData a,
    ChannelPreviewThemeData b,
    double t,
  ) =>
      ChannelPreviewThemeData(
        avatarTheme:
            const AvatarThemeData().lerp(a.avatarTheme!, b.avatarTheme!, t),
        indicatorIconSize: a.indicatorIconSize,
        lastMessageAtStyle:
            TextStyle.lerp(a.lastMessageAtStyle, b.lastMessageAtStyle, t),
        subtitleStyle: TextStyle.lerp(a.subtitleStyle, b.subtitleStyle, t),
        titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
        unreadCounterColor:
            Color.lerp(a.unreadCounterColor, b.unreadCounterColor, t),
      );

  /// Merge with theme
  ChannelPreviewThemeData merge(ChannelPreviewThemeData? other) {
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
      other is ChannelPreviewThemeData &&
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
