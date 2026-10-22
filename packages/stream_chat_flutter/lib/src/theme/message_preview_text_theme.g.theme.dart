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
      deletedMessageStyle: TextStyle.lerp(
        a.deletedMessageStyle,
        b.deletedMessageStyle,
        t,
      ),
    );
  }

  StreamMessagePreviewTextThemeData copyWith({
    TextStyle? draftPrefixStyle,
    TextStyle? senderPrefixStyle,
    TextStyle? deletedMessageStyle,
  }) {
    final _this = (this as StreamMessagePreviewTextThemeData);

    return StreamMessagePreviewTextThemeData(
      draftPrefixStyle: draftPrefixStyle ?? _this.draftPrefixStyle,
      senderPrefixStyle: senderPrefixStyle ?? _this.senderPrefixStyle,
      deletedMessageStyle: deletedMessageStyle ?? _this.deletedMessageStyle,
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
      deletedMessageStyle:
          _this.deletedMessageStyle?.merge(other.deletedMessageStyle) ??
          other.deletedMessageStyle,
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
        _other.deletedMessageStyle == _this.deletedMessageStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamMessagePreviewTextThemeData);

    return Object.hash(
      runtimeType,
      _this.draftPrefixStyle,
      _this.senderPrefixStyle,
      _this.deletedMessageStyle,
    );
  }
}
