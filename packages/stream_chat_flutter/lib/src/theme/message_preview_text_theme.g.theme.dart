// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'message_preview_text_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamMessagePreviewTextThemeData {
  bool get canMerge => true;

  static StreamMessagePreviewTextThemeData? lerp(
    StreamMessagePreviewTextThemeData? a,
    StreamMessagePreviewTextThemeData? b,
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

    return StreamMessagePreviewTextThemeData(
      deletedTextStyle: TextStyle.lerp(
        a.deletedTextStyle,
        b.deletedTextStyle,
        t,
      ),
      draftLabelStyle: TextStyle.lerp(a.draftLabelStyle, b.draftLabelStyle, t),
      senderTextStyle: TextStyle.lerp(a.senderTextStyle, b.senderTextStyle, t),
    );
  }

  StreamMessagePreviewTextThemeData copyWith({
    TextStyle? deletedTextStyle,
    TextStyle? draftLabelStyle,
    TextStyle? senderTextStyle,
  }) {
    final _this = (this as StreamMessagePreviewTextThemeData);

    return StreamMessagePreviewTextThemeData(
      deletedTextStyle: deletedTextStyle ?? _this.deletedTextStyle,
      draftLabelStyle: draftLabelStyle ?? _this.draftLabelStyle,
      senderTextStyle: senderTextStyle ?? _this.senderTextStyle,
    );
  }

  StreamMessagePreviewTextThemeData merge(
    StreamMessagePreviewTextThemeData? other,
  ) {
    final _this = (this as StreamMessagePreviewTextThemeData);

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
      senderTextStyle:
          _this.senderTextStyle?.merge(other.senderTextStyle) ??
          other.senderTextStyle,
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

    final _this = (this as StreamMessagePreviewTextThemeData);
    final _other = (other as StreamMessagePreviewTextThemeData);

    return _other.deletedTextStyle == _this.deletedTextStyle &&
        _other.draftLabelStyle == _this.draftLabelStyle &&
        _other.senderTextStyle == _this.senderTextStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamMessagePreviewTextThemeData);

    return Object.hash(
      runtimeType,
      _this.deletedTextStyle,
      _this.draftLabelStyle,
      _this.senderTextStyle,
    );
  }
}
