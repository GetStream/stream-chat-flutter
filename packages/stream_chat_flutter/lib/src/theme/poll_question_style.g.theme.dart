// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'poll_question_style.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamPollQuestionStyle {
  bool get canMerge => true;

  static StreamPollQuestionStyle? lerp(
    StreamPollQuestionStyle? a,
    StreamPollQuestionStyle? b,
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

    return StreamPollQuestionStyle(
      cardStyle: StreamPollCardStyle.lerp(a.cardStyle, b.cardStyle, t),
      headerTextStyle: TextStyle.lerp(a.headerTextStyle, b.headerTextStyle, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
    );
  }

  StreamPollQuestionStyle copyWith({
    StreamPollCardStyle? cardStyle,
    TextStyle? headerTextStyle,
    TextStyle? textStyle,
  }) {
    final _this = (this as StreamPollQuestionStyle);

    return StreamPollQuestionStyle(
      cardStyle: cardStyle ?? _this.cardStyle,
      headerTextStyle: headerTextStyle ?? _this.headerTextStyle,
      textStyle: textStyle ?? _this.textStyle,
    );
  }

  StreamPollQuestionStyle merge(StreamPollQuestionStyle? other) {
    final _this = (this as StreamPollQuestionStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      cardStyle: _this.cardStyle?.merge(other.cardStyle) ?? other.cardStyle,
      headerTextStyle:
          _this.headerTextStyle?.merge(other.headerTextStyle) ??
          other.headerTextStyle,
      textStyle: _this.textStyle?.merge(other.textStyle) ?? other.textStyle,
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

    final _this = (this as StreamPollQuestionStyle);
    final _other = (other as StreamPollQuestionStyle);

    return _other.cardStyle == _this.cardStyle &&
        _other.headerTextStyle == _this.headerTextStyle &&
        _other.textStyle == _this.textStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamPollQuestionStyle);

    return Object.hash(
      runtimeType,
      _this.cardStyle,
      _this.headerTextStyle,
      _this.textStyle,
    );
  }
}
