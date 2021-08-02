import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/theme/avatar_theme.dart';

/// Overrides the default style of [ChannelListHeader] descendants.
///
/// See also:
///
///  * [ChannelListHeaderThemeData], which is used to configure this theme.
class ChannelListHeaderTheme extends InheritedTheme {
  /// Creates a [ChannelListHeaderTheme].
  ///
  /// The [data] parameter must not be null.
  const ChannelListHeaderTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final ChannelListHeaderThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [ChannelListHeaderTheme] widget, then
  /// [StreamChatThemeData.channelListHeaderTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = ChannelListHeaderTheme.of(context);
  /// ```
  static ChannelListHeaderThemeData of(BuildContext context) {
    final channelListHeaderTheme =
        context.dependOnInheritedWidgetOfExactType<ChannelListHeaderTheme>();
    return channelListHeaderTheme?.data ??
        StreamChatTheme.of(context).channelListHeaderTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      ChannelListHeaderTheme(data: data, child: child);

  @override
  bool updateShouldNotify(ChannelListHeaderTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme dedicated to the [ChannelListHeader]
class ChannelListHeaderThemeData with Diagnosticable {
  /// Returns a new [ChannelListHeaderThemeData]
  const ChannelListHeaderThemeData({
    this.titleStyle,
    this.avatarTheme,
    this.color,
  });

  /// Style of the title text
  final TextStyle? titleStyle;

  /// Theme dedicated to the userAvatar
  final AvatarThemeData? avatarTheme;

  /// Background color of the appbar
  final Color? color;

  /// Returns a new [ChannelListHeaderThemeData] replacing some of its
  /// properties
  ChannelListHeaderThemeData copyWith({
    TextStyle? titleStyle,
    AvatarThemeData? avatarTheme,
    Color? color,
  }) =>
      ChannelListHeaderThemeData(
        titleStyle: titleStyle ?? this.titleStyle,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        color: color ?? this.color,
      );

  /// Linearly interpolate from one [ChannelListHeaderThemeData] to another.
  ChannelListHeaderThemeData lerp(
    ChannelListHeaderThemeData a,
    ChannelListHeaderThemeData b,
    double t,
  ) =>
      ChannelListHeaderThemeData(
        avatarTheme:
            const AvatarThemeData().lerp(a.avatarTheme!, b.avatarTheme!, t),
        color: Color.lerp(a.color, b.color, t),
        titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
      );

  /// Merges [this] [ChannelListHeaderThemeData] with the [other]
  ChannelListHeaderThemeData merge(ChannelListHeaderThemeData? other) {
    if (other == null) return this;
    return copyWith(
      titleStyle: titleStyle?.merge(other.titleStyle) ?? other.titleStyle,
      avatarTheme: avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
      color: other.color,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelListHeaderThemeData &&
          runtimeType == other.runtimeType &&
          titleStyle == other.titleStyle &&
          avatarTheme == other.avatarTheme &&
          color == other.color;

  @override
  int get hashCode =>
      titleStyle.hashCode ^ avatarTheme.hashCode ^ color.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('titleStyle', titleStyle))
      ..add(DiagnosticsProperty('avatarTheme', avatarTheme))
      ..add(ColorProperty('color', color));
  }
}
