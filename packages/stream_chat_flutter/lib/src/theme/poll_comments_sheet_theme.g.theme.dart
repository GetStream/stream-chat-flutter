// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'poll_comments_sheet_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamPollCommentsSheetThemeData {
  bool get canMerge => true;

  static StreamPollCommentsSheetThemeData? lerp(
    StreamPollCommentsSheetThemeData? a,
    StreamPollCommentsSheetThemeData? b,
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

    return StreamPollCommentsSheetThemeData(
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
      itemSpacing: lerpDouble$(a.itemSpacing, b.itemSpacing, t),
      commentStyle: StreamPollOptionVotesStyle.lerp(
        a.commentStyle,
        b.commentStyle,
        t,
      ),
    );
  }

  StreamPollCommentsSheetThemeData copyWith({
    Color? backgroundColor,
    StreamSheetHeaderStyle? sheetHeaderStyle,
    EdgeInsetsGeometry? contentPadding,
    double? itemSpacing,
    StreamPollOptionVotesStyle? commentStyle,
  }) {
    final _this = (this as StreamPollCommentsSheetThemeData);

    return StreamPollCommentsSheetThemeData(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      sheetHeaderStyle: sheetHeaderStyle ?? _this.sheetHeaderStyle,
      contentPadding: contentPadding ?? _this.contentPadding,
      itemSpacing: itemSpacing ?? _this.itemSpacing,
      commentStyle: commentStyle ?? _this.commentStyle,
    );
  }

  StreamPollCommentsSheetThemeData merge(
    StreamPollCommentsSheetThemeData? other,
  ) {
    final _this = (this as StreamPollCommentsSheetThemeData);

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
      itemSpacing: other.itemSpacing,
      commentStyle:
          _this.commentStyle?.merge(other.commentStyle) ?? other.commentStyle,
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

    final _this = (this as StreamPollCommentsSheetThemeData);
    final _other = (other as StreamPollCommentsSheetThemeData);

    return _other.backgroundColor == _this.backgroundColor &&
        _other.sheetHeaderStyle == _this.sheetHeaderStyle &&
        _other.contentPadding == _this.contentPadding &&
        _other.itemSpacing == _this.itemSpacing &&
        _other.commentStyle == _this.commentStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamPollCommentsSheetThemeData);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.sheetHeaderStyle,
      _this.contentPadding,
      _this.itemSpacing,
      _this.commentStyle,
    );
  }
}
