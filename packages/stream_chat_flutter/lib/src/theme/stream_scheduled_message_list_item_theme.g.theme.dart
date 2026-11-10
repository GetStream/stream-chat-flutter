// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'stream_scheduled_message_list_item_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamScheduledMessageListItemThemeData {
  bool get canMerge => true;

  static StreamScheduledMessageListItemThemeData? lerp(
    StreamScheduledMessageListItemThemeData? a,
    StreamScheduledMessageListItemThemeData? b,
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

    return StreamScheduledMessageListItemThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      sendTimeStyle: TextStyle.lerp(a.sendTimeStyle, b.sendTimeStyle, t),
      failedSendTimeStyle: TextStyle.lerp(
        a.failedSendTimeStyle,
        b.failedSendTimeStyle,
        t,
      ),
      sendTimeFormatter: t < 0.5 ? a.sendTimeFormatter : b.sendTimeFormatter,
      titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
      previewStyle: TextStyle.lerp(a.previewStyle, b.previewStyle, t),
      previewTextTheme: StreamMessagePreviewTextThemeData.lerp(
        a.previewTextTheme,
        b.previewTextTheme,
        t,
      ),
      statusStyle: TextStyle.lerp(a.statusStyle, b.statusStyle, t),
      failedStatusStyle: TextStyle.lerp(
        a.failedStatusStyle,
        b.failedStatusStyle,
        t,
      ),
    );
  }

  StreamScheduledMessageListItemThemeData copyWith({
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    TextStyle? sendTimeStyle,
    TextStyle? failedSendTimeStyle,
    String Function(BuildContext, DateTime)? sendTimeFormatter,
    TextStyle? titleStyle,
    TextStyle? previewStyle,
    StreamMessagePreviewTextThemeData? previewTextTheme,
    TextStyle? statusStyle,
    TextStyle? failedStatusStyle,
  }) {
    final _this = (this as StreamScheduledMessageListItemThemeData);

    return StreamScheduledMessageListItemThemeData(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      padding: padding ?? _this.padding,
      sendTimeStyle: sendTimeStyle ?? _this.sendTimeStyle,
      failedSendTimeStyle: failedSendTimeStyle ?? _this.failedSendTimeStyle,
      sendTimeFormatter: sendTimeFormatter ?? _this.sendTimeFormatter,
      titleStyle: titleStyle ?? _this.titleStyle,
      previewStyle: previewStyle ?? _this.previewStyle,
      previewTextTheme: previewTextTheme ?? _this.previewTextTheme,
      statusStyle: statusStyle ?? _this.statusStyle,
      failedStatusStyle: failedStatusStyle ?? _this.failedStatusStyle,
    );
  }

  StreamScheduledMessageListItemThemeData merge(
    StreamScheduledMessageListItemThemeData? other,
  ) {
    final _this = (this as StreamScheduledMessageListItemThemeData);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      backgroundColor: other.backgroundColor,
      padding: other.padding,
      sendTimeStyle:
          _this.sendTimeStyle?.merge(other.sendTimeStyle) ??
          other.sendTimeStyle,
      failedSendTimeStyle:
          _this.failedSendTimeStyle?.merge(other.failedSendTimeStyle) ??
          other.failedSendTimeStyle,
      sendTimeFormatter: other.sendTimeFormatter,
      titleStyle: _this.titleStyle?.merge(other.titleStyle) ?? other.titleStyle,
      previewStyle:
          _this.previewStyle?.merge(other.previewStyle) ?? other.previewStyle,
      previewTextTheme:
          _this.previewTextTheme?.merge(other.previewTextTheme) ??
          other.previewTextTheme,
      statusStyle:
          _this.statusStyle?.merge(other.statusStyle) ?? other.statusStyle,
      failedStatusStyle:
          _this.failedStatusStyle?.merge(other.failedStatusStyle) ??
          other.failedStatusStyle,
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

    final _this = (this as StreamScheduledMessageListItemThemeData);
    final _other = (other as StreamScheduledMessageListItemThemeData);

    return _other.backgroundColor == _this.backgroundColor &&
        _other.padding == _this.padding &&
        _other.sendTimeStyle == _this.sendTimeStyle &&
        _other.failedSendTimeStyle == _this.failedSendTimeStyle &&
        _other.sendTimeFormatter == _this.sendTimeFormatter &&
        _other.titleStyle == _this.titleStyle &&
        _other.previewStyle == _this.previewStyle &&
        _other.previewTextTheme == _this.previewTextTheme &&
        _other.statusStyle == _this.statusStyle &&
        _other.failedStatusStyle == _this.failedStatusStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamScheduledMessageListItemThemeData);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.padding,
      _this.sendTimeStyle,
      _this.failedSendTimeStyle,
      _this.sendTimeFormatter,
      _this.titleStyle,
      _this.previewStyle,
      _this.previewTextTheme,
      _this.statusStyle,
      _this.failedStatusStyle,
    );
  }
}
