// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_defaults.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppDefaults {
  GetOrCreateChannelDefaults get getOrCreateChannel;
  QueryChannelsDefaults get queryChannels;

  /// Create a copy of AppDefaults
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppDefaultsCopyWith<AppDefaults> get copyWith =>
      _$AppDefaultsCopyWithImpl<AppDefaults>(this as AppDefaults, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppDefaults &&
            (identical(other.getOrCreateChannel, getOrCreateChannel) ||
                other.getOrCreateChannel == getOrCreateChannel) &&
            (identical(other.queryChannels, queryChannels) || other.queryChannels == queryChannels));
  }

  @override
  int get hashCode => Object.hash(runtimeType, getOrCreateChannel, queryChannels);

  @override
  String toString() {
    return 'AppDefaults(getOrCreateChannel: $getOrCreateChannel, queryChannels: $queryChannels)';
  }
}

/// @nodoc
abstract mixin class $AppDefaultsCopyWith<$Res> {
  factory $AppDefaultsCopyWith(
    AppDefaults value,
    $Res Function(AppDefaults) _then,
  ) = _$AppDefaultsCopyWithImpl;
  @useResult
  $Res call({
    GetOrCreateChannelDefaults getOrCreateChannel,
    QueryChannelsDefaults queryChannels,
  });
}

/// @nodoc
class _$AppDefaultsCopyWithImpl<$Res> implements $AppDefaultsCopyWith<$Res> {
  _$AppDefaultsCopyWithImpl(this._self, this._then);

  final AppDefaults _self;
  final $Res Function(AppDefaults) _then;

  /// Create a copy of AppDefaults
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? getOrCreateChannel = null, Object? queryChannels = null}) {
    return _then(
      AppDefaults(
        getOrCreateChannel: null == getOrCreateChannel
            ? _self.getOrCreateChannel
            : getOrCreateChannel // ignore: cast_nullable_to_non_nullable
                  as GetOrCreateChannelDefaults,
        queryChannels: null == queryChannels
            ? _self.queryChannels
            : queryChannels // ignore: cast_nullable_to_non_nullable
                  as QueryChannelsDefaults,
      ),
    );
  }
}
