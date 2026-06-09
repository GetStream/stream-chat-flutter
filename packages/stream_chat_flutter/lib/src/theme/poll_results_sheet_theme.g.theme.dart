// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'poll_results_sheet_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamPollResultsSheetThemeData {
  bool get canMerge => true;

  static StreamPollResultsSheetThemeData? lerp(
    StreamPollResultsSheetThemeData? a,
    StreamPollResultsSheetThemeData? b,
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

    return StreamPollResultsSheetThemeData(
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
      optionsItemSpacing: lerpDouble$(
        a.optionsItemSpacing,
        b.optionsItemSpacing,
        t,
      ),
      optionStyle: StreamPollOptionVotesStyle.lerp(
        a.optionStyle,
        b.optionStyle,
        t,
      ),
      totalVoteCountTextStyle: TextStyle.lerp(
        a.totalVoteCountTextStyle,
        b.totalVoteCountTextStyle,
        t,
      ),
    );
  }

  StreamPollResultsSheetThemeData copyWith({
    Color? backgroundColor,
    StreamSheetHeaderStyle? sheetHeaderStyle,
    EdgeInsetsGeometry? contentPadding,
    double? sectionSpacing,
    StreamPollQuestionStyle? questionStyle,
    double? optionsItemSpacing,
    StreamPollOptionVotesStyle? optionStyle,
    TextStyle? totalVoteCountTextStyle,
  }) {
    final _this = (this as StreamPollResultsSheetThemeData);

    return StreamPollResultsSheetThemeData(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      sheetHeaderStyle: sheetHeaderStyle ?? _this.sheetHeaderStyle,
      contentPadding: contentPadding ?? _this.contentPadding,
      sectionSpacing: sectionSpacing ?? _this.sectionSpacing,
      questionStyle: questionStyle ?? _this.questionStyle,
      optionsItemSpacing: optionsItemSpacing ?? _this.optionsItemSpacing,
      optionStyle: optionStyle ?? _this.optionStyle,
      totalVoteCountTextStyle:
          totalVoteCountTextStyle ?? _this.totalVoteCountTextStyle,
    );
  }

  StreamPollResultsSheetThemeData merge(
    StreamPollResultsSheetThemeData? other,
  ) {
    final _this = (this as StreamPollResultsSheetThemeData);

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
      optionsItemSpacing: other.optionsItemSpacing,
      optionStyle:
          _this.optionStyle?.merge(other.optionStyle) ?? other.optionStyle,
      totalVoteCountTextStyle:
          _this.totalVoteCountTextStyle?.merge(other.totalVoteCountTextStyle) ??
          other.totalVoteCountTextStyle,
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

    final _this = (this as StreamPollResultsSheetThemeData);
    final _other = (other as StreamPollResultsSheetThemeData);

    return _other.backgroundColor == _this.backgroundColor &&
        _other.sheetHeaderStyle == _this.sheetHeaderStyle &&
        _other.contentPadding == _this.contentPadding &&
        _other.sectionSpacing == _this.sectionSpacing &&
        _other.questionStyle == _this.questionStyle &&
        _other.optionsItemSpacing == _this.optionsItemSpacing &&
        _other.optionStyle == _this.optionStyle &&
        _other.totalVoteCountTextStyle == _this.totalVoteCountTextStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamPollResultsSheetThemeData);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.sheetHeaderStyle,
      _this.contentPadding,
      _this.sectionSpacing,
      _this.questionStyle,
      _this.optionsItemSpacing,
      _this.optionStyle,
      _this.totalVoteCountTextStyle,
    );
  }
}
