import 'package:flutter/material.dart';

/// Theme for avatar
class AvatarTheme {
  /// Constructor for creating [AvatarTheme]
  AvatarTheme({
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

  /// Copy with another theme
  AvatarTheme copyWith({
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
  }) =>
      AvatarTheme(
        constraints: constraints ?? _constraints,
        borderRadius: borderRadius ?? _borderRadius,
      );

  /// Merge with another AvatarTheme
  AvatarTheme merge(AvatarTheme? other) {
    if (other == null) return this;
    return copyWith(
      constraints: other._constraints,
      borderRadius: other._borderRadius,
    );
  }
}