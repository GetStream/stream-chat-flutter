import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/theme/themes.dart';

/// Overrides the default style of [UserAvatar] descendants.
///
/// See also:
///
///  * [AvatarThemeData], which is used to configure this theme.
class AvatarTheme extends InheritedTheme {
  /// Creates an [AvatarTheme].
  ///
  /// The [data] parameter must not be null.
  const AvatarTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final AvatarThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [GalleryHeaderTheme] widget, then
  /// [StreamChatThemeData.avatarTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = AvatarTheme.of(context);
  /// ```
  static AvatarThemeData of(BuildContext context) {
    final avatarTheme =
        context.dependOnInheritedWidgetOfExactType<AvatarTheme>();
    return avatarTheme?.data ?? StreamChatTheme.of(context).avatarTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      AvatarTheme(data: data, child: child);

  @override
  bool updateShouldNotify(AvatarTheme oldWidget) => data != oldWidget.data;
}

/// A style that overrides the default appearance of [UserAvatar]s when used
/// with [AvatarTheme] or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.avatarTheme].
///
/// See also:
///
/// * [AvatarTheme], the theme which is configured with this class.
/// * [StreamChatThemeData.avatarTheme], which can be used to override
/// the default style for [UserAvatar]s below the overall [StreamChatTheme].
class AvatarThemeData with Diagnosticable {
  /// Creates an [AvatarThemeData].
  const AvatarThemeData({
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
  })  : _constraints = constraints,
        _borderRadius = borderRadius;

  final BoxConstraints? _constraints;
  final BorderRadius? _borderRadius;

  /// Get constraints for avatar
  BoxConstraints get constraints =>
      _constraints ??
      const BoxConstraints.tightFor(
        height: 32,
        width: 32,
      );

  /// Get border radius
  BorderRadius get borderRadius => _borderRadius ?? BorderRadius.circular(20);

  /// Copy this [AvatarThemeData] to another.
  AvatarThemeData copyWith({
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
  }) =>
      AvatarThemeData(
        constraints: constraints ?? _constraints,
        borderRadius: borderRadius ?? _borderRadius,
      );

  /// Linearly interpolate between two [UserAvatar] themes.
  ///
  /// All the properties must be non-null.
  AvatarThemeData lerp(
    AvatarThemeData a,
    AvatarThemeData b,
    double t,
  ) =>
      AvatarThemeData(
        borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
        constraints: BoxConstraints.lerp(a.constraints, b.constraints, t),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvatarThemeData &&
          runtimeType == other.runtimeType &&
          _constraints == other._constraints &&
          _borderRadius == other._borderRadius;

  @override
  int get hashCode => _constraints.hashCode ^ _borderRadius.hashCode;

  /// Merges one [AvatarThemeData] with the another
  AvatarThemeData merge(AvatarThemeData? other) {
    if (other == null) return this;
    return copyWith(
      constraints: other._constraints,
      borderRadius: other._borderRadius,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('borderRadius', borderRadius))
      ..add(DiagnosticsProperty('constraints', constraints));
  }
}
