// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'quoted_message_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamQuotedMessageThemeData {
  bool get canMerge => true;

  static StreamQuotedMessageThemeData? lerp(
    StreamQuotedMessageThemeData? a,
    StreamQuotedMessageThemeData? b,
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

    return StreamQuotedMessageThemeData(
      titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
      subtitleTextStyle: TextStyle.lerp(
        a.subtitleTextStyle,
        b.subtitleTextStyle,
        t,
      ),
      indicatorColor: Color.lerp(a.indicatorColor, b.indicatorColor, t),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      shape: OutlinedBorder.lerp(a.shape, b.shape, t),
      side: a.side == null
          ? b.side
          : b.side == null
          ? a.side
          : BorderSide.lerp(a.side!, b.side!, t),
      margin: EdgeInsetsGeometry.lerp(a.margin, b.margin, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      thumbnailShape: OutlinedBorder.lerp(
        a.thumbnailShape,
        b.thumbnailShape,
        t,
      ),
      thumbnailSide: a.thumbnailSide == null
          ? b.thumbnailSide
          : b.thumbnailSide == null
          ? a.thumbnailSide
          : BorderSide.lerp(a.thumbnailSide!, b.thumbnailSide!, t),
      thumbnailSize: Size.lerp(a.thumbnailSize, b.thumbnailSize, t),
    );
  }

  StreamQuotedMessageThemeData copyWith({
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
    Color? indicatorColor,
    Color? backgroundColor,
    OutlinedBorder? shape,
    BorderSide? side,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    OutlinedBorder? thumbnailShape,
    BorderSide? thumbnailSide,
    Size? thumbnailSize,
  }) {
    final _this = (this as StreamQuotedMessageThemeData);

    return StreamQuotedMessageThemeData(
      titleTextStyle: titleTextStyle ?? _this.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? _this.subtitleTextStyle,
      indicatorColor: indicatorColor ?? _this.indicatorColor,
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      shape: shape ?? _this.shape,
      side: side ?? _this.side,
      margin: margin ?? _this.margin,
      padding: padding ?? _this.padding,
      thumbnailShape: thumbnailShape ?? _this.thumbnailShape,
      thumbnailSide: thumbnailSide ?? _this.thumbnailSide,
      thumbnailSize: thumbnailSize ?? _this.thumbnailSize,
    );
  }

  StreamQuotedMessageThemeData merge(StreamQuotedMessageThemeData? other) {
    final _this = (this as StreamQuotedMessageThemeData);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      titleTextStyle:
          _this.titleTextStyle?.merge(other.titleTextStyle) ??
          other.titleTextStyle,
      subtitleTextStyle:
          _this.subtitleTextStyle?.merge(other.subtitleTextStyle) ??
          other.subtitleTextStyle,
      indicatorColor: other.indicatorColor,
      backgroundColor: other.backgroundColor,
      shape: other.shape,
      side: _this.side != null && other.side != null
          ? BorderSide.merge(_this.side!, other.side!)
          : other.side,
      margin: other.margin,
      padding: other.padding,
      thumbnailShape: other.thumbnailShape,
      thumbnailSide: _this.thumbnailSide != null && other.thumbnailSide != null
          ? BorderSide.merge(_this.thumbnailSide!, other.thumbnailSide!)
          : other.thumbnailSide,
      thumbnailSize: other.thumbnailSize,
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

    final _this = (this as StreamQuotedMessageThemeData);
    final _other = (other as StreamQuotedMessageThemeData);

    return _other.titleTextStyle == _this.titleTextStyle &&
        _other.subtitleTextStyle == _this.subtitleTextStyle &&
        _other.indicatorColor == _this.indicatorColor &&
        _other.backgroundColor == _this.backgroundColor &&
        _other.shape == _this.shape &&
        _other.side == _this.side &&
        _other.margin == _this.margin &&
        _other.padding == _this.padding &&
        _other.thumbnailShape == _this.thumbnailShape &&
        _other.thumbnailSide == _this.thumbnailSide &&
        _other.thumbnailSize == _this.thumbnailSize;
  }

  @override
  int get hashCode {
    final _this = (this as StreamQuotedMessageThemeData);

    return Object.hash(
      runtimeType,
      _this.titleTextStyle,
      _this.subtitleTextStyle,
      _this.indicatorColor,
      _this.backgroundColor,
      _this.shape,
      _this.side,
      _this.margin,
      _this.padding,
      _this.thumbnailShape,
      _this.thumbnailSide,
      _this.thumbnailSize,
    );
  }
}
