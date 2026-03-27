// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'poll_interactor_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamPollInteractorThemeData {
  bool get canMerge => true;

  static StreamPollInteractorThemeData? lerp(
    StreamPollInteractorThemeData? a,
    StreamPollInteractorThemeData? b,
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

    return StreamPollInteractorThemeData(
      titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
      subtitleTextStyle: TextStyle.lerp(
        a.subtitleTextStyle,
        b.subtitleTextStyle,
        t,
      ),
      primaryActionStyle: StreamButtonThemeStyle.lerp(
        a.primaryActionStyle,
        b.primaryActionStyle,
        t,
      ),
      secondaryActionStyle: StreamButtonThemeStyle.lerp(
        a.secondaryActionStyle,
        b.secondaryActionStyle,
        t,
      ),
      optionStyle: StreamPollOptionStyle.lerp(a.optionStyle, b.optionStyle, t),
    );
  }

  StreamPollInteractorThemeData copyWith({
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
    StreamButtonThemeStyle? primaryActionStyle,
    StreamButtonThemeStyle? secondaryActionStyle,
    StreamPollOptionStyle? optionStyle,
  }) {
    final _this = (this as StreamPollInteractorThemeData);

    return StreamPollInteractorThemeData(
      titleTextStyle: titleTextStyle ?? _this.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? _this.subtitleTextStyle,
      primaryActionStyle: primaryActionStyle ?? _this.primaryActionStyle,
      secondaryActionStyle: secondaryActionStyle ?? _this.secondaryActionStyle,
      optionStyle: optionStyle ?? _this.optionStyle,
    );
  }

  StreamPollInteractorThemeData merge(StreamPollInteractorThemeData? other) {
    final _this = (this as StreamPollInteractorThemeData);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      titleTextStyle:
          _this.titleTextStyle?.merge(other.titleTextStyle) ??
          other.titleTextStyle,
      subtitleTextStyle:
          _this.subtitleTextStyle?.merge(other.subtitleTextStyle) ??
          other.subtitleTextStyle,
      primaryActionStyle:
          _this.primaryActionStyle?.merge(other.primaryActionStyle) ??
          other.primaryActionStyle,
      secondaryActionStyle:
          _this.secondaryActionStyle?.merge(other.secondaryActionStyle) ??
          other.secondaryActionStyle,
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

    final _this = (this as StreamPollInteractorThemeData);
    final _other = (other as StreamPollInteractorThemeData);

    return _other.titleTextStyle == _this.titleTextStyle &&
        _other.subtitleTextStyle == _this.subtitleTextStyle &&
        _other.primaryActionStyle == _this.primaryActionStyle &&
        _other.secondaryActionStyle == _this.secondaryActionStyle &&
        _other.optionStyle == _this.optionStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamPollInteractorThemeData);

    return Object.hash(
      runtimeType,
      _this.titleTextStyle,
      _this.subtitleTextStyle,
      _this.primaryActionStyle,
      _this.secondaryActionStyle,
      _this.optionStyle,
    );
  }
}

mixin _$StreamPollOptionStyle {
  bool get canMerge => true;

  static StreamPollOptionStyle? lerp(
    StreamPollOptionStyle? a,
    StreamPollOptionStyle? b,
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

    return StreamPollOptionStyle(
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      votesTextStyle: TextStyle.lerp(a.votesTextStyle, b.votesTextStyle, t),
      votesAvatarSize: t < 0.5 ? a.votesAvatarSize : b.votesAvatarSize,
      checkboxStyle: StreamCheckboxStyle.lerp(
        a.checkboxStyle,
        b.checkboxStyle,
        t,
      ),
      progressBarStyle: StreamProgressBarStyle.lerp(
        a.progressBarStyle,
        b.progressBarStyle,
        t,
      ),
    );
  }

  StreamPollOptionStyle copyWith({
    TextStyle? textStyle,
    TextStyle? votesTextStyle,
    StreamAvatarStackSize? votesAvatarSize,
    StreamCheckboxStyle? checkboxStyle,
    StreamProgressBarStyle? progressBarStyle,
  }) {
    final _this = (this as StreamPollOptionStyle);

    return StreamPollOptionStyle(
      textStyle: textStyle ?? _this.textStyle,
      votesTextStyle: votesTextStyle ?? _this.votesTextStyle,
      votesAvatarSize: votesAvatarSize ?? _this.votesAvatarSize,
      checkboxStyle: checkboxStyle ?? _this.checkboxStyle,
      progressBarStyle: progressBarStyle ?? _this.progressBarStyle,
    );
  }

  StreamPollOptionStyle merge(StreamPollOptionStyle? other) {
    final _this = (this as StreamPollOptionStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      textStyle: _this.textStyle?.merge(other.textStyle) ?? other.textStyle,
      votesTextStyle:
          _this.votesTextStyle?.merge(other.votesTextStyle) ??
          other.votesTextStyle,
      votesAvatarSize: other.votesAvatarSize,
      checkboxStyle:
          _this.checkboxStyle?.merge(other.checkboxStyle) ??
          other.checkboxStyle,
      progressBarStyle:
          _this.progressBarStyle?.merge(other.progressBarStyle) ??
          other.progressBarStyle,
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

    final _this = (this as StreamPollOptionStyle);
    final _other = (other as StreamPollOptionStyle);

    return _other.textStyle == _this.textStyle &&
        _other.votesTextStyle == _this.votesTextStyle &&
        _other.votesAvatarSize == _this.votesAvatarSize &&
        _other.checkboxStyle == _this.checkboxStyle &&
        _other.progressBarStyle == _this.progressBarStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamPollOptionStyle);

    return Object.hash(
      runtimeType,
      _this.textStyle,
      _this.votesTextStyle,
      _this.votesAvatarSize,
      _this.checkboxStyle,
      _this.progressBarStyle,
    );
  }
}
