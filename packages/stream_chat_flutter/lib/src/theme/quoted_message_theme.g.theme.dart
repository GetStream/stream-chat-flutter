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
      contentPadding: EdgeInsetsGeometry.lerp(
        a.contentPadding,
        b.contentPadding,
        t,
      ),
    );
  }

  StreamQuotedMessageThemeData copyWith({
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
    Color? indicatorColor,
    EdgeInsetsGeometry? contentPadding,
  }) {
    final _this = (this as StreamQuotedMessageThemeData);

    return StreamQuotedMessageThemeData(
      titleTextStyle: titleTextStyle ?? _this.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? _this.subtitleTextStyle,
      indicatorColor: indicatorColor ?? _this.indicatorColor,
      contentPadding: contentPadding ?? _this.contentPadding,
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
      contentPadding: other.contentPadding,
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
        _other.contentPadding == _this.contentPadding;
  }

  @override
  int get hashCode {
    final _this = (this as StreamQuotedMessageThemeData);

    return Object.hash(
      runtimeType,
      _this.titleTextStyle,
      _this.subtitleTextStyle,
      _this.indicatorColor,
      _this.contentPadding,
    );
  }
}
