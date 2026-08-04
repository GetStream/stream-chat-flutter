// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'message_composer_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamMessageComposerThemeData {
  bool get canMerge => true;

  static StreamMessageComposerThemeData? lerp(
    StreamMessageComposerThemeData? a,
    StreamMessageComposerThemeData? b,
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

    return StreamMessageComposerThemeData(
      behavior: t < 0.5 ? a.behavior : b.behavior,
    );
  }

  StreamMessageComposerThemeData copyWith({
    StreamMessageComposerBehavior? behavior,
  }) {
    final _this = (this as StreamMessageComposerThemeData);

    return StreamMessageComposerThemeData(behavior: behavior ?? _this.behavior);
  }

  StreamMessageComposerThemeData merge(StreamMessageComposerThemeData? other) {
    final _this = (this as StreamMessageComposerThemeData);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(behavior: other.behavior);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as StreamMessageComposerThemeData);
    final _other = (other as StreamMessageComposerThemeData);

    return _other.behavior == _this.behavior;
  }

  @override
  int get hashCode {
    final _this = (this as StreamMessageComposerThemeData);

    return Object.hash(runtimeType, _this.behavior);
  }
}
