// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_action_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallActionOptions {
  int? get duration;
  String? get flagReason;
  String? get kickReason;
  bool? get muteAudio;
  bool? get muteVideo;
  String? get reason;
  String? get warningText;

  /// Create a copy of CallActionOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallActionOptionsCopyWith<CallActionOptions> get copyWith =>
      _$CallActionOptionsCopyWithImpl<CallActionOptions>(
        this as CallActionOptions,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallActionOptions &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.flagReason, flagReason) ||
                other.flagReason == flagReason) &&
            (identical(other.kickReason, kickReason) ||
                other.kickReason == kickReason) &&
            (identical(other.muteAudio, muteAudio) ||
                other.muteAudio == muteAudio) &&
            (identical(other.muteVideo, muteVideo) ||
                other.muteVideo == muteVideo) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.warningText, warningText) ||
                other.warningText == warningText));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    flagReason,
    kickReason,
    muteAudio,
    muteVideo,
    reason,
    warningText,
  );

  @override
  String toString() {
    return 'CallActionOptions(duration: $duration, flagReason: $flagReason, kickReason: $kickReason, muteAudio: $muteAudio, muteVideo: $muteVideo, reason: $reason, warningText: $warningText)';
  }
}

/// @nodoc
abstract mixin class $CallActionOptionsCopyWith<$Res> {
  factory $CallActionOptionsCopyWith(
    CallActionOptions value,
    $Res Function(CallActionOptions) _then,
  ) = _$CallActionOptionsCopyWithImpl;
  @useResult
  $Res call({
    int? duration,
    String? flagReason,
    String? kickReason,
    bool? muteAudio,
    bool? muteVideo,
    String? reason,
    String? warningText,
  });
}

/// @nodoc
class _$CallActionOptionsCopyWithImpl<$Res>
    implements $CallActionOptionsCopyWith<$Res> {
  _$CallActionOptionsCopyWithImpl(this._self, this._then);

  final CallActionOptions _self;
  final $Res Function(CallActionOptions) _then;

  /// Create a copy of CallActionOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = freezed,
    Object? flagReason = freezed,
    Object? kickReason = freezed,
    Object? muteAudio = freezed,
    Object? muteVideo = freezed,
    Object? reason = freezed,
    Object? warningText = freezed,
  }) {
    return _then(
      CallActionOptions(
        duration: freezed == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int?,
        flagReason: freezed == flagReason
            ? _self.flagReason
            : flagReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        kickReason: freezed == kickReason
            ? _self.kickReason
            : kickReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        muteAudio: freezed == muteAudio
            ? _self.muteAudio
            : muteAudio // ignore: cast_nullable_to_non_nullable
                  as bool?,
        muteVideo: freezed == muteVideo
            ? _self.muteVideo
            : muteVideo // ignore: cast_nullable_to_non_nullable
                  as bool?,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        warningText: freezed == warningText
            ? _self.warningText
            : warningText // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
