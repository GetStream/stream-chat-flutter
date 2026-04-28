// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'poll_card_style.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamPollCardStyle {
  bool get canMerge => true;

  static StreamPollCardStyle? lerp(
    StreamPollCardStyle? a,
    StreamPollCardStyle? b,
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

    return StreamPollCardStyle(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
    );
  }

  StreamPollCardStyle copyWith({
    Color? backgroundColor,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    final _this = (this as StreamPollCardStyle);

    return StreamPollCardStyle(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      borderRadius: borderRadius ?? _this.borderRadius,
      padding: padding ?? _this.padding,
    );
  }

  StreamPollCardStyle merge(StreamPollCardStyle? other) {
    final _this = (this as StreamPollCardStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      backgroundColor: other.backgroundColor,
      borderRadius: other.borderRadius,
      padding: other.padding,
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

    final _this = (this as StreamPollCardStyle);
    final _other = (other as StreamPollCardStyle);

    return _other.backgroundColor == _this.backgroundColor &&
        _other.borderRadius == _this.borderRadius &&
        _other.padding == _this.padding;
  }

  @override
  int get hashCode {
    final _this = (this as StreamPollCardStyle);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.borderRadius,
      _this.padding,
    );
  }
}
