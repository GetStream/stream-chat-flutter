// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'stream_channel_list_item_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamChannelListItemThemeData {
  bool get canMerge => true;

  static StreamChannelListItemThemeData? lerp(
    StreamChannelListItemThemeData? a,
    StreamChannelListItemThemeData? b,
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

    return StreamChannelListItemThemeData(
      titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
      subtitleStyle: TextStyle.lerp(a.subtitleStyle, b.subtitleStyle, t),
      timestampStyle: TextStyle.lerp(a.timestampStyle, b.timestampStyle, t),
      backgroundColor: WidgetStateProperty.lerp<Color?>(
        a.backgroundColor,
        b.backgroundColor,
        t,
        Color.lerp,
      ),
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      muteIconPosition: t < 0.5 ? a.muteIconPosition : b.muteIconPosition,
    );
  }

  StreamChannelListItemThemeData copyWith({
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? timestampStyle,
    WidgetStateProperty<Color?>? backgroundColor,
    Color? borderColor,
    MuteIconPosition? muteIconPosition,
  }) {
    final _this = (this as StreamChannelListItemThemeData);

    return StreamChannelListItemThemeData(
      titleStyle: titleStyle ?? _this.titleStyle,
      subtitleStyle: subtitleStyle ?? _this.subtitleStyle,
      timestampStyle: timestampStyle ?? _this.timestampStyle,
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      borderColor: borderColor ?? _this.borderColor,
      muteIconPosition: muteIconPosition ?? _this.muteIconPosition,
    );
  }

  StreamChannelListItemThemeData merge(StreamChannelListItemThemeData? other) {
    final _this = (this as StreamChannelListItemThemeData);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      titleStyle: _this.titleStyle?.merge(other.titleStyle) ?? other.titleStyle,
      subtitleStyle:
          _this.subtitleStyle?.merge(other.subtitleStyle) ??
          other.subtitleStyle,
      timestampStyle:
          _this.timestampStyle?.merge(other.timestampStyle) ??
          other.timestampStyle,
      backgroundColor: other.backgroundColor,
      borderColor: other.borderColor,
      muteIconPosition: other.muteIconPosition,
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

    final _this = (this as StreamChannelListItemThemeData);
    final _other = (other as StreamChannelListItemThemeData);

    return _other.titleStyle == _this.titleStyle &&
        _other.subtitleStyle == _this.subtitleStyle &&
        _other.timestampStyle == _this.timestampStyle &&
        _other.backgroundColor == _this.backgroundColor &&
        _other.borderColor == _this.borderColor &&
        _other.muteIconPosition == _this.muteIconPosition;
  }

  @override
  int get hashCode {
    final _this = (this as StreamChannelListItemThemeData);

    return Object.hash(
      runtimeType,
      _this.titleStyle,
      _this.subtitleStyle,
      _this.timestampStyle,
      _this.backgroundColor,
      _this.borderColor,
      _this.muteIconPosition,
    );
  }
}
