// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'voice_recording_attachment_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$StreamVoiceRecordingAttachmentThemeData {
  bool get canMerge => true;

  static StreamVoiceRecordingAttachmentThemeData? lerp(
    StreamVoiceRecordingAttachmentThemeData? a,
    StreamVoiceRecordingAttachmentThemeData? b,
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

    return StreamVoiceRecordingAttachmentThemeData(
      titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
      durationTextStyle: TextStyle.lerp(
        a.durationTextStyle,
        b.durationTextStyle,
        t,
      ),
      activeDurationTextStyle: TextStyle.lerp(
        a.activeDurationTextStyle,
        b.activeDurationTextStyle,
        t,
      ),
      controlButtonStyle: StreamButtonThemeStyle.lerp(
        a.controlButtonStyle,
        b.controlButtonStyle,
        t,
      ),
      speedToggleStyle: StreamPlaybackSpeedToggleStyle.lerp(
        a.speedToggleStyle,
        b.speedToggleStyle,
        t,
      ),
      waveformStyle: StreamAudioWaveformThemeData.lerp(
        a.waveformStyle,
        b.waveformStyle,
        t,
      ),
    );
  }

  StreamVoiceRecordingAttachmentThemeData copyWith({
    TextStyle? titleTextStyle,
    TextStyle? durationTextStyle,
    TextStyle? activeDurationTextStyle,
    StreamButtonThemeStyle? controlButtonStyle,
    StreamPlaybackSpeedToggleStyle? speedToggleStyle,
    StreamAudioWaveformThemeData? waveformStyle,
  }) {
    final _this = (this as StreamVoiceRecordingAttachmentThemeData);

    return StreamVoiceRecordingAttachmentThemeData(
      titleTextStyle: titleTextStyle ?? _this.titleTextStyle,
      durationTextStyle: durationTextStyle ?? _this.durationTextStyle,
      activeDurationTextStyle:
          activeDurationTextStyle ?? _this.activeDurationTextStyle,
      controlButtonStyle: controlButtonStyle ?? _this.controlButtonStyle,
      speedToggleStyle: speedToggleStyle ?? _this.speedToggleStyle,
      waveformStyle: waveformStyle ?? _this.waveformStyle,
    );
  }

  StreamVoiceRecordingAttachmentThemeData merge(
    StreamVoiceRecordingAttachmentThemeData? other,
  ) {
    final _this = (this as StreamVoiceRecordingAttachmentThemeData);

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
      durationTextStyle:
          _this.durationTextStyle?.merge(other.durationTextStyle) ??
          other.durationTextStyle,
      activeDurationTextStyle:
          _this.activeDurationTextStyle?.merge(other.activeDurationTextStyle) ??
          other.activeDurationTextStyle,
      controlButtonStyle:
          _this.controlButtonStyle?.merge(other.controlButtonStyle) ??
          other.controlButtonStyle,
      speedToggleStyle:
          _this.speedToggleStyle?.merge(other.speedToggleStyle) ??
          other.speedToggleStyle,
      waveformStyle:
          _this.waveformStyle?.merge(other.waveformStyle) ??
          other.waveformStyle,
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

    final _this = (this as StreamVoiceRecordingAttachmentThemeData);
    final _other = (other as StreamVoiceRecordingAttachmentThemeData);

    return _other.titleTextStyle == _this.titleTextStyle &&
        _other.durationTextStyle == _this.durationTextStyle &&
        _other.activeDurationTextStyle == _this.activeDurationTextStyle &&
        _other.controlButtonStyle == _this.controlButtonStyle &&
        _other.speedToggleStyle == _this.speedToggleStyle &&
        _other.waveformStyle == _this.waveformStyle;
  }

  @override
  int get hashCode {
    final _this = (this as StreamVoiceRecordingAttachmentThemeData);

    return Object.hash(
      runtimeType,
      _this.titleTextStyle,
      _this.durationTextStyle,
      _this.activeDurationTextStyle,
      _this.controlButtonStyle,
      _this.speedToggleStyle,
      _this.waveformStyle,
    );
  }
}
