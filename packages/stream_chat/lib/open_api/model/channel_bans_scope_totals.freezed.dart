// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_bans_scope_totals.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelBansScopeTotals {
  int get channel;
  int get futureChannel;

  /// Create a copy of ChannelBansScopeTotals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelBansScopeTotalsCopyWith<ChannelBansScopeTotals> get copyWith =>
      _$ChannelBansScopeTotalsCopyWithImpl<ChannelBansScopeTotals>(
        this as ChannelBansScopeTotals,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelBansScopeTotals &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.futureChannel, futureChannel) || other.futureChannel == futureChannel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, channel, futureChannel);

  @override
  String toString() {
    return 'ChannelBansScopeTotals(channel: $channel, futureChannel: $futureChannel)';
  }
}

/// @nodoc
abstract mixin class $ChannelBansScopeTotalsCopyWith<$Res> {
  factory $ChannelBansScopeTotalsCopyWith(
    ChannelBansScopeTotals value,
    $Res Function(ChannelBansScopeTotals) _then,
  ) = _$ChannelBansScopeTotalsCopyWithImpl;
  @useResult
  $Res call({int channel, int futureChannel});
}

/// @nodoc
class _$ChannelBansScopeTotalsCopyWithImpl<$Res> implements $ChannelBansScopeTotalsCopyWith<$Res> {
  _$ChannelBansScopeTotalsCopyWithImpl(this._self, this._then);

  final ChannelBansScopeTotals _self;
  final $Res Function(ChannelBansScopeTotals) _then;

  /// Create a copy of ChannelBansScopeTotals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? channel = null, Object? futureChannel = null}) {
    return _then(
      ChannelBansScopeTotals(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as int,
        futureChannel: null == futureChannel
            ? _self.futureChannel
            : futureChannel // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
