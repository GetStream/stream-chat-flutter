// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'message_preview_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamMessagePreviewThemeData {
  bool get canMerge => true;

  static StreamMessagePreviewThemeData? lerp(
    StreamMessagePreviewThemeData? a,
    StreamMessagePreviewThemeData? b,
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

    return StreamMessagePreviewThemeData(
      deletedTextStyle: TextStyle.lerp(
        a.deletedTextStyle,
        b.deletedTextStyle,
        t,
      ),
      draftLabelStyle: TextStyle.lerp(a.draftLabelStyle, b.draftLabelStyle, t),
    );
  }

  StreamMessagePreviewThemeData copyWith({
    TextStyle? deletedTextStyle,
    TextStyle? draftLabelStyle,
  }) {
    final _this = (this as StreamMessagePreviewThemeData);

    return StreamMessagePreviewThemeData(
      deletedTextStyle: deletedTextStyle ?? _this.deletedTextStyle,
      draftLabelStyle: draftLabelStyle ?? _this.draftLabelStyle,
    );
  }

  StreamMessagePreviewThemeData merge(StreamMessagePreviewThemeData? other) {
    final _this = (this as StreamMessagePreviewThemeData);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      deletedTextStyle:
          _this.deletedTextStyle?.merge(other.deletedTextStyle) ??
          other.deletedTextStyle,
      draftLabelStyle:
          _this.draftLabelStyle?.merge(other.draftLabelStyle) ??
          other.draftLabelStyle,
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

    final _this = (this as StreamMessagePreviewThemeData);
    final _other = (other as StreamMessagePreviewThemeData);

    return _other.deletedTextStyle == _this.deletedTextStyle &&
        _other.draftLabelStyle == _this.draftLabelStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamMessagePreviewThemeData);

    return Object.hash(
      runtimeType,
      _this.deletedTextStyle,
      _this.draftLabelStyle,
    );
  }
}
