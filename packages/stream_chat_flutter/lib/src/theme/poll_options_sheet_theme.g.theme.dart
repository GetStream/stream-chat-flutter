// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'poll_options_sheet_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamPollOptionsSheetThemeData {
  bool get canMerge => true;

  static StreamPollOptionsSheetThemeData? lerp(
    StreamPollOptionsSheetThemeData? a,
    StreamPollOptionsSheetThemeData? b,
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

    return StreamPollOptionsSheetThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      sheetHeaderStyle: StreamSheetHeaderStyle.lerp(
        a.sheetHeaderStyle,
        b.sheetHeaderStyle,
        t,
      ),
      contentPadding: EdgeInsetsGeometry.lerp(
        a.contentPadding,
        b.contentPadding,
        t,
      ),
      sectionSpacing: lerpDouble$(a.sectionSpacing, b.sectionSpacing, t),
      questionStyle: StreamPollQuestionStyle.lerp(
        a.questionStyle,
        b.questionStyle,
        t,
      ),
      optionsCardStyle: StreamPollCardStyle.lerp(
        a.optionsCardStyle,
        b.optionsCardStyle,
        t,
      ),
      optionsItemSpacing: lerpDouble$(
        a.optionsItemSpacing,
        b.optionsItemSpacing,
        t,
      ),
      optionStyle: StreamPollOptionStyle.lerp(a.optionStyle, b.optionStyle, t),
    );
  }

  StreamPollOptionsSheetThemeData copyWith({
    Color? backgroundColor,
    StreamSheetHeaderStyle? sheetHeaderStyle,
    EdgeInsetsGeometry? contentPadding,
    double? sectionSpacing,
    StreamPollQuestionStyle? questionStyle,
    StreamPollCardStyle? optionsCardStyle,
    double? optionsItemSpacing,
    StreamPollOptionStyle? optionStyle,
  }) {
    final _this = (this as StreamPollOptionsSheetThemeData);

    return StreamPollOptionsSheetThemeData(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      sheetHeaderStyle: sheetHeaderStyle ?? _this.sheetHeaderStyle,
      contentPadding: contentPadding ?? _this.contentPadding,
      sectionSpacing: sectionSpacing ?? _this.sectionSpacing,
      questionStyle: questionStyle ?? _this.questionStyle,
      optionsCardStyle: optionsCardStyle ?? _this.optionsCardStyle,
      optionsItemSpacing: optionsItemSpacing ?? _this.optionsItemSpacing,
      optionStyle: optionStyle ?? _this.optionStyle,
    );
  }

  StreamPollOptionsSheetThemeData merge(
    StreamPollOptionsSheetThemeData? other,
  ) {
    final _this = (this as StreamPollOptionsSheetThemeData);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      backgroundColor: other.backgroundColor,
      sheetHeaderStyle:
          _this.sheetHeaderStyle?.merge(other.sheetHeaderStyle) ??
          other.sheetHeaderStyle,
      contentPadding: other.contentPadding,
      sectionSpacing: other.sectionSpacing,
      questionStyle:
          _this.questionStyle?.merge(other.questionStyle) ??
          other.questionStyle,
      optionsCardStyle:
          _this.optionsCardStyle?.merge(other.optionsCardStyle) ??
          other.optionsCardStyle,
      optionsItemSpacing: other.optionsItemSpacing,
      optionStyle:
          _this.optionStyle?.merge(other.optionStyle) ?? other.optionStyle,
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

    final _this = (this as StreamPollOptionsSheetThemeData);
    final _other = (other as StreamPollOptionsSheetThemeData);

    return _other.backgroundColor == _this.backgroundColor &&
        _other.sheetHeaderStyle == _this.sheetHeaderStyle &&
        _other.contentPadding == _this.contentPadding &&
        _other.sectionSpacing == _this.sectionSpacing &&
        _other.questionStyle == _this.questionStyle &&
        _other.optionsCardStyle == _this.optionsCardStyle &&
        _other.optionsItemSpacing == _this.optionsItemSpacing &&
        _other.optionStyle == _this.optionStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamPollOptionsSheetThemeData);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.sheetHeaderStyle,
      _this.contentPadding,
      _this.sectionSpacing,
      _this.questionStyle,
      _this.optionsCardStyle,
      _this.optionsItemSpacing,
      _this.optionStyle,
    );
  }
}
