// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'message_list_view_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamMessageListViewThemeData {
  bool get canMerge => true;

  static StreamMessageListViewThemeData? lerp(
    StreamMessageListViewThemeData? a,
    StreamMessageListViewThemeData? b,
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

    return StreamMessageListViewThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      backgroundImage: DecorationImage.lerp(
        a.backgroundImage,
        b.backgroundImage,
        t,
      ),
      messageHighlightColor: Color.lerp(
        a.messageHighlightColor,
        b.messageHighlightColor,
        t,
      ),
    );
  }

  StreamMessageListViewThemeData copyWith({
    Color? backgroundColor,
    DecorationImage? backgroundImage,
    Color? messageHighlightColor,
  }) {
    final _this = (this as StreamMessageListViewThemeData);

    return StreamMessageListViewThemeData(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      backgroundImage: backgroundImage ?? _this.backgroundImage,
      messageHighlightColor:
          messageHighlightColor ?? _this.messageHighlightColor,
    );
  }

  StreamMessageListViewThemeData merge(StreamMessageListViewThemeData? other) {
    final _this = (this as StreamMessageListViewThemeData);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      backgroundColor: other.backgroundColor,
      backgroundImage: other.backgroundImage,
      messageHighlightColor: other.messageHighlightColor,
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

    final _this = (this as StreamMessageListViewThemeData);
    final _other = (other as StreamMessageListViewThemeData);

    return _other.backgroundColor == _this.backgroundColor &&
        _other.backgroundImage == _this.backgroundImage &&
        _other.messageHighlightColor == _this.messageHighlightColor;
  }

  @override
  int get hashCode {
    final _this = (this as StreamMessageListViewThemeData);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.backgroundImage,
      _this.messageHighlightColor,
    );
  }
}
