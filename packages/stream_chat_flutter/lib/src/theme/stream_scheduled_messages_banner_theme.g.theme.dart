// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'stream_scheduled_messages_banner_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamScheduledMessagesBannerThemeData {
  bool get canMerge => true;

  static StreamScheduledMessagesBannerThemeData? lerp(
    StreamScheduledMessagesBannerThemeData? a,
    StreamScheduledMessagesBannerThemeData? b,
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

    return StreamScheduledMessagesBannerThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      shape: ShapeBorder.lerp(a.shape, b.shape, t),
      elevation: lerpDouble$(a.elevation, b.elevation, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      countStyle: TextStyle.lerp(a.countStyle, b.countStyle, t),
      viewAllStyle: TextStyle.lerp(a.viewAllStyle, b.viewAllStyle, t),
      iconColor: Color.lerp(a.iconColor, b.iconColor, t),
      failedIconColor: Color.lerp(a.failedIconColor, b.failedIconColor, t),
    );
  }

  StreamScheduledMessagesBannerThemeData copyWith({
    Color? backgroundColor,
    ShapeBorder? shape,
    double? elevation,
    EdgeInsetsGeometry? padding,
    TextStyle? countStyle,
    TextStyle? viewAllStyle,
    Color? iconColor,
    Color? failedIconColor,
  }) {
    final _this = (this as StreamScheduledMessagesBannerThemeData);

    return StreamScheduledMessagesBannerThemeData(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      shape: shape ?? _this.shape,
      elevation: elevation ?? _this.elevation,
      padding: padding ?? _this.padding,
      countStyle: countStyle ?? _this.countStyle,
      viewAllStyle: viewAllStyle ?? _this.viewAllStyle,
      iconColor: iconColor ?? _this.iconColor,
      failedIconColor: failedIconColor ?? _this.failedIconColor,
    );
  }

  StreamScheduledMessagesBannerThemeData merge(
    StreamScheduledMessagesBannerThemeData? other,
  ) {
    final _this = (this as StreamScheduledMessagesBannerThemeData);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      backgroundColor: other.backgroundColor,
      shape: other.shape,
      elevation: other.elevation,
      padding: other.padding,
      countStyle: _this.countStyle?.merge(other.countStyle) ?? other.countStyle,
      viewAllStyle:
          _this.viewAllStyle?.merge(other.viewAllStyle) ?? other.viewAllStyle,
      iconColor: other.iconColor,
      failedIconColor: other.failedIconColor,
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

    final _this = (this as StreamScheduledMessagesBannerThemeData);
    final _other = (other as StreamScheduledMessagesBannerThemeData);

    return _other.backgroundColor == _this.backgroundColor &&
        _other.shape == _this.shape &&
        _other.elevation == _this.elevation &&
        _other.padding == _this.padding &&
        _other.countStyle == _this.countStyle &&
        _other.viewAllStyle == _this.viewAllStyle &&
        _other.iconColor == _this.iconColor &&
        _other.failedIconColor == _this.failedIconColor;
  }

  @override
  int get hashCode {
    final _this = (this as StreamScheduledMessagesBannerThemeData);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.shape,
      _this.elevation,
      _this.padding,
      _this.countStyle,
      _this.viewAllStyle,
      _this.iconColor,
      _this.failedIconColor,
    );
  }
}
