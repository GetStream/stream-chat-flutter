import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@macro avatar_theme_data}
@Deprecated("Use 'StreamAvatarThemeData' instead")
typedef AvatarThemeData = StreamAvatarThemeData;

/// {@template avatar_theme_data}
/// A style that overrides the default appearance of various avatar widgets.
/// {@endtemplate}
// ignore: prefer-match-file-name
class StreamAvatarThemeData with Diagnosticable {
  /// Creates an [StreamAvatarThemeData].
  const StreamAvatarThemeData({
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

  /// Copy this [StreamAvatarThemeData] to another.
  StreamAvatarThemeData copyWith({
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
  }) =>
      StreamAvatarThemeData(
        constraints: constraints ?? _constraints,
        borderRadius: borderRadius ?? _borderRadius,
      );

  /// Linearly interpolate between two [UserAvatar] themes.
  ///
  /// All the properties must be non-null.
  StreamAvatarThemeData lerp(
    StreamAvatarThemeData a,
    StreamAvatarThemeData b,
    double t,
  ) =>
      StreamAvatarThemeData(
        borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
        constraints: BoxConstraints.lerp(a.constraints, b.constraints, t),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamAvatarThemeData &&
          runtimeType == other.runtimeType &&
          _constraints == other._constraints &&
          _borderRadius == other._borderRadius;

  @override
  int get hashCode => _constraints.hashCode ^ _borderRadius.hashCode;

  /// Merges one [StreamAvatarThemeData] with the another
  StreamAvatarThemeData merge(StreamAvatarThemeData? other) {
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
