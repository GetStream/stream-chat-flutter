// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'poll_option_votes_sheet_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamPollOptionVotesSheetThemeData {
  bool get canMerge => true;

  static StreamPollOptionVotesSheetThemeData? lerp(
    StreamPollOptionVotesSheetThemeData? a,
    StreamPollOptionVotesSheetThemeData? b,
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

    return StreamPollOptionVotesSheetThemeData(
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
      optionStyle: StreamPollOptionVotesStyle.lerp(
        a.optionStyle,
        b.optionStyle,
        t,
      ),
    );
  }

  StreamPollOptionVotesSheetThemeData copyWith({
    Color? backgroundColor,
    StreamSheetHeaderStyle? sheetHeaderStyle,
    EdgeInsetsGeometry? contentPadding,
    StreamPollOptionVotesStyle? optionStyle,
  }) {
    final _this = (this as StreamPollOptionVotesSheetThemeData);

    return StreamPollOptionVotesSheetThemeData(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      sheetHeaderStyle: sheetHeaderStyle ?? _this.sheetHeaderStyle,
      contentPadding: contentPadding ?? _this.contentPadding,
      optionStyle: optionStyle ?? _this.optionStyle,
    );
  }

  StreamPollOptionVotesSheetThemeData merge(
    StreamPollOptionVotesSheetThemeData? other,
  ) {
    final _this = (this as StreamPollOptionVotesSheetThemeData);

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

    final _this = (this as StreamPollOptionVotesSheetThemeData);
    final _other = (other as StreamPollOptionVotesSheetThemeData);

    return _other.backgroundColor == _this.backgroundColor &&
        _other.sheetHeaderStyle == _this.sheetHeaderStyle &&
        _other.contentPadding == _this.contentPadding &&
        _other.optionStyle == _this.optionStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamPollOptionVotesSheetThemeData);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.sheetHeaderStyle,
      _this.contentPadding,
      _this.optionStyle,
    );
  }
}
