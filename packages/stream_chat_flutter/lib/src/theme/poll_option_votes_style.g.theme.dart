// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'poll_option_votes_style.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamPollOptionVotesStyle {
  bool get canMerge => true;

  static StreamPollOptionVotesStyle? lerp(
    StreamPollOptionVotesStyle? a,
    StreamPollOptionVotesStyle? b,
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

    return StreamPollOptionVotesStyle(
      cardStyle: StreamPollCardStyle.lerp(a.cardStyle, b.cardStyle, t),
      numberTextStyle: TextStyle.lerp(a.numberTextStyle, b.numberTextStyle, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      voteCountTextStyle: TextStyle.lerp(
        a.voteCountTextStyle,
        b.voteCountTextStyle,
        t,
      ),
      winnerIconColor: Color.lerp(a.winnerIconColor, b.winnerIconColor, t),
      winnerIconSize: lerpDouble$(a.winnerIconSize, b.winnerIconSize, t),
      footerDividerColor: Color.lerp(
        a.footerDividerColor,
        b.footerDividerColor,
        t,
      ),
      footerButtonStyle: StreamButtonThemeStyle.lerp(
        a.footerButtonStyle,
        b.footerButtonStyle,
        t,
      ),
    );
  }

  StreamPollOptionVotesStyle copyWith({
    StreamPollCardStyle? cardStyle,
    TextStyle? numberTextStyle,
    TextStyle? textStyle,
    TextStyle? voteCountTextStyle,
    Color? winnerIconColor,
    double? winnerIconSize,
    Color? footerDividerColor,
    StreamButtonThemeStyle? footerButtonStyle,
  }) {
    final _this = (this as StreamPollOptionVotesStyle);

    return StreamPollOptionVotesStyle(
      cardStyle: cardStyle ?? _this.cardStyle,
      numberTextStyle: numberTextStyle ?? _this.numberTextStyle,
      textStyle: textStyle ?? _this.textStyle,
      voteCountTextStyle: voteCountTextStyle ?? _this.voteCountTextStyle,
      winnerIconColor: winnerIconColor ?? _this.winnerIconColor,
      winnerIconSize: winnerIconSize ?? _this.winnerIconSize,
      footerDividerColor: footerDividerColor ?? _this.footerDividerColor,
      footerButtonStyle: footerButtonStyle ?? _this.footerButtonStyle,
    );
  }

  StreamPollOptionVotesStyle merge(StreamPollOptionVotesStyle? other) {
    final _this = (this as StreamPollOptionVotesStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      cardStyle: _this.cardStyle?.merge(other.cardStyle) ?? other.cardStyle,
      numberTextStyle:
          _this.numberTextStyle?.merge(other.numberTextStyle) ??
          other.numberTextStyle,
      textStyle: _this.textStyle?.merge(other.textStyle) ?? other.textStyle,
      voteCountTextStyle:
          _this.voteCountTextStyle?.merge(other.voteCountTextStyle) ??
          other.voteCountTextStyle,
      winnerIconColor: other.winnerIconColor,
      winnerIconSize: other.winnerIconSize,
      footerDividerColor: other.footerDividerColor,
      footerButtonStyle:
          _this.footerButtonStyle?.merge(other.footerButtonStyle) ??
          other.footerButtonStyle,
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

    final _this = (this as StreamPollOptionVotesStyle);
    final _other = (other as StreamPollOptionVotesStyle);

    return _other.cardStyle == _this.cardStyle &&
        _other.numberTextStyle == _this.numberTextStyle &&
        _other.textStyle == _this.textStyle &&
        _other.voteCountTextStyle == _this.voteCountTextStyle &&
        _other.winnerIconColor == _this.winnerIconColor &&
        _other.winnerIconSize == _this.winnerIconSize &&
        _other.footerDividerColor == _this.footerDividerColor &&
        _other.footerButtonStyle == _this.footerButtonStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamPollOptionVotesStyle);

    return Object.hash(
      runtimeType,
      _this.cardStyle,
      _this.numberTextStyle,
      _this.textStyle,
      _this.voteCountTextStyle,
      _this.winnerIconColor,
      _this.winnerIconSize,
      _this.footerDividerColor,
      _this.footerButtonStyle,
    );
  }
}
