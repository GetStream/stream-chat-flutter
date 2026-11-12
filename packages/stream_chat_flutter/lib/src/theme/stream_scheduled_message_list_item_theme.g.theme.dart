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
      backgroundColor: WidgetStateProperty.lerp<Color?>(
        a.backgroundColor,
        b.backgroundColor,
        t,
        Color.lerp,
      ),
      contentPadding: EdgeInsetsGeometry.lerp(
        a.contentPadding,
        b.contentPadding,
        t,
      ),
      scheduledAtStyle: TextStyle.lerp(
        a.scheduledAtStyle,
        b.scheduledAtStyle,
        t,
      ),
      failedScheduledAtStyle: TextStyle.lerp(
        a.failedScheduledAtStyle,
        b.failedScheduledAtStyle,
        t,
      ),
      scheduledAtFormatter: t < 0.5
          ? a.scheduledAtFormatter
          : b.scheduledAtFormatter,
      channelNameStyle: TextStyle.lerp(
        a.channelNameStyle,
        b.channelNameStyle,
        t,
      ),
      messagePreviewStyle: TextStyle.lerp(
        a.messagePreviewStyle,
        b.messagePreviewStyle,
        t,
      ),
      messagePreviewTextTheme: StreamMessagePreviewTextThemeData.lerp(
        a.messagePreviewTextTheme,
        b.messagePreviewTextTheme,
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
    WidgetStateProperty<Color?>? backgroundColor,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? scheduledAtStyle,
    TextStyle? failedScheduledAtStyle,
    String Function(BuildContext, DateTime)? scheduledAtFormatter,
    TextStyle? channelNameStyle,
    TextStyle? messagePreviewStyle,
    StreamMessagePreviewTextThemeData? messagePreviewTextTheme,
    TextStyle? statusStyle,
    TextStyle? failedStatusStyle,
  }) {
    final _this = (this as StreamScheduledMessageListItemThemeData);

    return StreamScheduledMessageListItemThemeData(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      contentPadding: contentPadding ?? _this.contentPadding,
      scheduledAtStyle: scheduledAtStyle ?? _this.scheduledAtStyle,
      failedScheduledAtStyle:
          failedScheduledAtStyle ?? _this.failedScheduledAtStyle,
      scheduledAtFormatter: scheduledAtFormatter ?? _this.scheduledAtFormatter,
      channelNameStyle: channelNameStyle ?? _this.channelNameStyle,
      messagePreviewStyle: messagePreviewStyle ?? _this.messagePreviewStyle,
      messagePreviewTextTheme:
          messagePreviewTextTheme ?? _this.messagePreviewTextTheme,
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
      contentPadding: other.contentPadding,
      scheduledAtStyle:
          _this.scheduledAtStyle?.merge(other.scheduledAtStyle) ??
          other.scheduledAtStyle,
      failedScheduledAtStyle:
          _this.failedScheduledAtStyle?.merge(other.failedScheduledAtStyle) ??
          other.failedScheduledAtStyle,
      scheduledAtFormatter: other.scheduledAtFormatter,
      channelNameStyle:
          _this.channelNameStyle?.merge(other.channelNameStyle) ??
          other.channelNameStyle,
      messagePreviewStyle:
          _this.messagePreviewStyle?.merge(other.messagePreviewStyle) ??
          other.messagePreviewStyle,
      messagePreviewTextTheme:
          _this.messagePreviewTextTheme?.merge(other.messagePreviewTextTheme) ??
          other.messagePreviewTextTheme,
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
        _other.contentPadding == _this.contentPadding &&
        _other.scheduledAtStyle == _this.scheduledAtStyle &&
        _other.failedScheduledAtStyle == _this.failedScheduledAtStyle &&
        _other.scheduledAtFormatter == _this.scheduledAtFormatter &&
        _other.channelNameStyle == _this.channelNameStyle &&
        _other.messagePreviewStyle == _this.messagePreviewStyle &&
        _other.messagePreviewTextTheme == _this.messagePreviewTextTheme &&
        _other.statusStyle == _this.statusStyle &&
        _other.failedStatusStyle == _this.failedStatusStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamScheduledMessageListItemThemeData);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.contentPadding,
      _this.scheduledAtStyle,
      _this.failedScheduledAtStyle,
      _this.scheduledAtFormatter,
      _this.channelNameStyle,
      _this.messagePreviewStyle,
      _this.messagePreviewTextTheme,
      _this.statusStyle,
      _this.failedStatusStyle,
    );
  }
}
