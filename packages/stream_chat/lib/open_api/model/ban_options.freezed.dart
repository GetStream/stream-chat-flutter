// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ban_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BanOptions {
  BanOptionsDeleteMessages? get deleteMessages;
  int? get duration;
  bool? get ipBan;
  String? get reason;
  bool? get shadowBan;

  /// Create a copy of BanOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BanOptionsCopyWith<BanOptions> get copyWith =>
      _$BanOptionsCopyWithImpl<BanOptions>(this as BanOptions, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BanOptions &&
            (identical(other.deleteMessages, deleteMessages) ||
                other.deleteMessages == deleteMessages) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.ipBan, ipBan) || other.ipBan == ipBan) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.shadowBan, shadowBan) ||
                other.shadowBan == shadowBan));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    deleteMessages,
    duration,
    ipBan,
    reason,
    shadowBan,
  );

  @override
  String toString() {
    return 'BanOptions(deleteMessages: $deleteMessages, duration: $duration, ipBan: $ipBan, reason: $reason, shadowBan: $shadowBan)';
  }
}

/// @nodoc
abstract mixin class $BanOptionsCopyWith<$Res> {
  factory $BanOptionsCopyWith(
    BanOptions value,
    $Res Function(BanOptions) _then,
  ) = _$BanOptionsCopyWithImpl;
  @useResult
  $Res call({
    BanOptionsDeleteMessages? deleteMessages,
    int? duration,
    bool? ipBan,
    String? reason,
    bool? shadowBan,
  });
}

/// @nodoc
class _$BanOptionsCopyWithImpl<$Res> implements $BanOptionsCopyWith<$Res> {
  _$BanOptionsCopyWithImpl(this._self, this._then);

  final BanOptions _self;
  final $Res Function(BanOptions) _then;

  /// Create a copy of BanOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deleteMessages = freezed,
    Object? duration = freezed,
    Object? ipBan = freezed,
    Object? reason = freezed,
    Object? shadowBan = freezed,
  }) {
    return _then(
      BanOptions(
        deleteMessages: freezed == deleteMessages
            ? _self.deleteMessages
            : deleteMessages // ignore: cast_nullable_to_non_nullable
                  as BanOptionsDeleteMessages?,
        duration: freezed == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int?,
        ipBan: freezed == ipBan
            ? _self.ipBan
            : ipBan // ignore: cast_nullable_to_non_nullable
                  as bool?,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        shadowBan: freezed == shadowBan
            ? _self.shadowBan
            : shadowBan // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
