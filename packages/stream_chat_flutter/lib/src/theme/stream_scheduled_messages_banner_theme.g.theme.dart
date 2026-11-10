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
      side: a.side == null
          ? b.side
          : b.side == null
          ? a.side
          : BorderSide.lerp(a.side!, b.side!, t),
      boxShadow: t < 0.5 ? a.boxShadow : b.boxShadow,
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      labelStyle: TextStyle.lerp(a.labelStyle, b.labelStyle, t),
      linkStyle: TextStyle.lerp(a.linkStyle, b.linkStyle, t),
      iconColor: Color.lerp(a.iconColor, b.iconColor, t),
      failedIconColor: Color.lerp(a.failedIconColor, b.failedIconColor, t),
    );
  }

  StreamScheduledMessagesBannerThemeData copyWith({
    Color? backgroundColor,
    BorderSide? side,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    TextStyle? labelStyle,
    TextStyle? linkStyle,
    Color? iconColor,
    Color? failedIconColor,
  }) {
    final _this = (this as StreamScheduledMessagesBannerThemeData);

    return StreamScheduledMessagesBannerThemeData(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      side: side ?? _this.side,
      boxShadow: boxShadow ?? _this.boxShadow,
      padding: padding ?? _this.padding,
      labelStyle: labelStyle ?? _this.labelStyle,
      linkStyle: linkStyle ?? _this.linkStyle,
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
      side: _this.side != null && other.side != null
          ? BorderSide.merge(_this.side!, other.side!)
          : other.side,
      boxShadow: other.boxShadow,
      padding: other.padding,
      labelStyle: _this.labelStyle?.merge(other.labelStyle) ?? other.labelStyle,
      linkStyle: _this.linkStyle?.merge(other.linkStyle) ?? other.linkStyle,
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
        _other.side == _this.side &&
        _other.boxShadow == _this.boxShadow &&
        _other.padding == _this.padding &&
        _other.labelStyle == _this.labelStyle &&
        _other.linkStyle == _this.linkStyle &&
        _other.iconColor == _this.iconColor &&
        _other.failedIconColor == _this.failedIconColor;
  }

  @override
  int get hashCode {
    final _this = (this as StreamScheduledMessagesBannerThemeData);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.side,
      _this.boxShadow,
      _this.padding,
      _this.labelStyle,
      _this.linkStyle,
      _this.iconColor,
      _this.failedIconColor,
    );
  }
}
