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
      draftPrefixStyle: TextStyle.lerp(
        a.draftPrefixStyle,
        b.draftPrefixStyle,
        t,
      ),
      senderPrefixStyle: TextStyle.lerp(
        a.senderPrefixStyle,
        b.senderPrefixStyle,
        t,
      ),
      deletedContentStyle: TextStyle.lerp(
        a.deletedContentStyle,
        b.deletedContentStyle,
        t,
      ),
      iconSize: lerpDouble$(a.iconSize, b.iconSize, t),
      iconColor: Color.lerp(a.iconColor, b.iconColor, t),
    );
  }

  StreamMessagePreviewTextThemeData copyWith({
    TextStyle? draftPrefixStyle,
    TextStyle? senderPrefixStyle,
    TextStyle? deletedContentStyle,
    double? iconSize,
    Color? iconColor,
  }) {
    final _this = (this as StreamMessagePreviewTextThemeData);

    return StreamMessagePreviewTextThemeData(
      draftPrefixStyle: draftPrefixStyle ?? _this.draftPrefixStyle,
      senderPrefixStyle: senderPrefixStyle ?? _this.senderPrefixStyle,
      deletedContentStyle: deletedContentStyle ?? _this.deletedContentStyle,
      iconSize: iconSize ?? _this.iconSize,
      iconColor: iconColor ?? _this.iconColor,
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
      draftPrefixStyle:
          _this.draftPrefixStyle?.merge(other.draftPrefixStyle) ??
          other.draftPrefixStyle,
      senderPrefixStyle:
          _this.senderPrefixStyle?.merge(other.senderPrefixStyle) ??
          other.senderPrefixStyle,
      deletedContentStyle:
          _this.deletedContentStyle?.merge(other.deletedContentStyle) ??
          other.deletedContentStyle,
      iconSize: other.iconSize,
      iconColor: other.iconColor,
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

    return _other.draftPrefixStyle == _this.draftPrefixStyle &&
        _other.senderPrefixStyle == _this.senderPrefixStyle &&
        _other.deletedContentStyle == _this.deletedContentStyle &&
        _other.iconSize == _this.iconSize &&
        _other.iconColor == _this.iconColor;
  }

  @override
  int get hashCode {
    final _this = (this as StreamMessagePreviewTextThemeData);

    return Object.hash(
      runtimeType,
      _this.draftPrefixStyle,
      _this.senderPrefixStyle,
      _this.deletedContentStyle,
      _this.iconSize,
      _this.iconColor,
    );
  }
}
