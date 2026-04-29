// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'poll_creator_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamPollCreatorThemeData {
  bool get canMerge => true;

  static StreamPollCreatorThemeData? lerp(
    StreamPollCreatorThemeData? a,
    StreamPollCreatorThemeData? b,
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

    return StreamPollCreatorThemeData(
      sheetHeaderStyle: StreamSheetHeaderStyle.lerp(
        a.sheetHeaderStyle,
        b.sheetHeaderStyle,
        t,
      ),
      headerTextStyle: TextStyle.lerp(a.headerTextStyle, b.headerTextStyle, t),
      questionInputStyle: StreamTextInputStyle.lerp(
        a.questionInputStyle,
        b.questionInputStyle,
        t,
      ),
      optionInputStyle: StreamTextInputStyle.lerp(
        a.optionInputStyle,
        b.optionInputStyle,
        t,
      ),
      configOptionStyle: StreamPollConfigOptionStyle.lerp(
        a.configOptionStyle,
        b.configOptionStyle,
        t,
      ),
    );
  }

  StreamPollCreatorThemeData copyWith({
    StreamSheetHeaderStyle? sheetHeaderStyle,
    TextStyle? headerTextStyle,
    StreamTextInputStyle? questionInputStyle,
    StreamTextInputStyle? optionInputStyle,
    StreamPollConfigOptionStyle? configOptionStyle,
  }) {
    final _this = (this as StreamPollCreatorThemeData);

    return StreamPollCreatorThemeData(
      sheetHeaderStyle: sheetHeaderStyle ?? _this.sheetHeaderStyle,
      headerTextStyle: headerTextStyle ?? _this.headerTextStyle,
      questionInputStyle: questionInputStyle ?? _this.questionInputStyle,
      optionInputStyle: optionInputStyle ?? _this.optionInputStyle,
      configOptionStyle: configOptionStyle ?? _this.configOptionStyle,
    );
  }

  StreamPollCreatorThemeData merge(StreamPollCreatorThemeData? other) {
    final _this = (this as StreamPollCreatorThemeData);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      sheetHeaderStyle:
          _this.sheetHeaderStyle?.merge(other.sheetHeaderStyle) ??
          other.sheetHeaderStyle,
      headerTextStyle:
          _this.headerTextStyle?.merge(other.headerTextStyle) ??
          other.headerTextStyle,
      questionInputStyle:
          _this.questionInputStyle?.merge(other.questionInputStyle) ??
          other.questionInputStyle,
      optionInputStyle:
          _this.optionInputStyle?.merge(other.optionInputStyle) ??
          other.optionInputStyle,
      configOptionStyle:
          _this.configOptionStyle?.merge(other.configOptionStyle) ??
          other.configOptionStyle,
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

    final _this = (this as StreamPollCreatorThemeData);
    final _other = (other as StreamPollCreatorThemeData);

    return _other.sheetHeaderStyle == _this.sheetHeaderStyle &&
        _other.headerTextStyle == _this.headerTextStyle &&
        _other.questionInputStyle == _this.questionInputStyle &&
        _other.optionInputStyle == _this.optionInputStyle &&
        _other.configOptionStyle == _this.configOptionStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamPollCreatorThemeData);

    return Object.hash(
      runtimeType,
      _this.sheetHeaderStyle,
      _this.headerTextStyle,
      _this.questionInputStyle,
      _this.optionInputStyle,
      _this.configOptionStyle,
    );
  }
}

mixin _$StreamPollConfigOptionStyle {
  bool get canMerge => true;

  static StreamPollConfigOptionStyle? lerp(
    StreamPollConfigOptionStyle? a,
    StreamPollConfigOptionStyle? b,
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

    return StreamPollConfigOptionStyle(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      contentPadding: EdgeInsetsGeometry.lerp(
        a.contentPadding,
        b.contentPadding,
        t,
      ),
      childSpacing: lerpDouble$(a.childSpacing, b.childSpacing, t),
      titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
      descriptionTextStyle: TextStyle.lerp(
        a.descriptionTextStyle,
        b.descriptionTextStyle,
        t,
      ),
      switchStyle: StreamSwitchStyle.lerp(a.switchStyle, b.switchStyle, t),
      stepperStyle: StreamStepperStyle.lerp(a.stepperStyle, b.stepperStyle, t),
    );
  }

  StreamPollConfigOptionStyle copyWith({
    Color? backgroundColor,
    EdgeInsetsGeometry? contentPadding,
    double? childSpacing,
    TextStyle? titleTextStyle,
    TextStyle? descriptionTextStyle,
    StreamSwitchStyle? switchStyle,
    StreamStepperStyle? stepperStyle,
  }) {
    final _this = (this as StreamPollConfigOptionStyle);

    return StreamPollConfigOptionStyle(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      contentPadding: contentPadding ?? _this.contentPadding,
      childSpacing: childSpacing ?? _this.childSpacing,
      titleTextStyle: titleTextStyle ?? _this.titleTextStyle,
      descriptionTextStyle: descriptionTextStyle ?? _this.descriptionTextStyle,
      switchStyle: switchStyle ?? _this.switchStyle,
      stepperStyle: stepperStyle ?? _this.stepperStyle,
    );
  }

  StreamPollConfigOptionStyle merge(StreamPollConfigOptionStyle? other) {
    final _this = (this as StreamPollConfigOptionStyle);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      backgroundColor: other.backgroundColor,
      contentPadding: other.contentPadding,
      childSpacing: other.childSpacing,
      titleTextStyle:
          _this.titleTextStyle?.merge(other.titleTextStyle) ??
          other.titleTextStyle,
      descriptionTextStyle:
          _this.descriptionTextStyle?.merge(other.descriptionTextStyle) ??
          other.descriptionTextStyle,
      switchStyle:
          _this.switchStyle?.merge(other.switchStyle) ?? other.switchStyle,
      stepperStyle:
          _this.stepperStyle?.merge(other.stepperStyle) ?? other.stepperStyle,
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

    final _this = (this as StreamPollConfigOptionStyle);
    final _other = (other as StreamPollConfigOptionStyle);

    return _other.backgroundColor == _this.backgroundColor &&
        _other.contentPadding == _this.contentPadding &&
        _other.childSpacing == _this.childSpacing &&
        _other.titleTextStyle == _this.titleTextStyle &&
        _other.descriptionTextStyle == _this.descriptionTextStyle &&
        _other.switchStyle == _this.switchStyle &&
        _other.stepperStyle == _this.stepperStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamPollConfigOptionStyle);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.contentPadding,
      _this.childSpacing,
      _this.titleTextStyle,
      _this.descriptionTextStyle,
      _this.switchStyle,
      _this.stepperStyle,
    );
  }
}
