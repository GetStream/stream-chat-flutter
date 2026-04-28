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
