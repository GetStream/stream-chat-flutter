import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A style that overrides the default appearance of various avatar widgets.
// ignore: prefer-match-file-name
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
