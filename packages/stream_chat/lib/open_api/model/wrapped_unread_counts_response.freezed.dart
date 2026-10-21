// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wrapped_unread_counts_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WrappedUnreadCountsResponse {
  List<UnreadCountsChannelType> get channelType;
  List<UnreadCountsChannel> get channels;
  String get duration;
  List<UnreadCountsThread> get threads;
  int get totalUnreadCount;
  Map<String, int>? get totalUnreadCountByTeam;
  int get totalUnreadThreadsCount;

  /// Create a copy of WrappedUnreadCountsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WrappedUnreadCountsResponseCopyWith<WrappedUnreadCountsResponse> get copyWith =>
      _$WrappedUnreadCountsResponseCopyWithImpl<WrappedUnreadCountsResponse>(
        this as WrappedUnreadCountsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WrappedUnreadCountsResponse &&
            const DeepCollectionEquality().equals(
              other.channelType,
              channelType,
            ) &&
            const DeepCollectionEquality().equals(other.channels, channels) &&
            (identical(other.duration, duration) || other.duration == duration) &&
            const DeepCollectionEquality().equals(other.threads, threads) &&
            (identical(other.totalUnreadCount, totalUnreadCount) || other.totalUnreadCount == totalUnreadCount) &&
            const DeepCollectionEquality().equals(
              other.totalUnreadCountByTeam,
              totalUnreadCountByTeam,
            ) &&
            (identical(
                  other.totalUnreadThreadsCount,
                  totalUnreadThreadsCount,
                ) ||
                other.totalUnreadThreadsCount == totalUnreadThreadsCount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channelType),
    const DeepCollectionEquality().hash(channels),
    duration,
    const DeepCollectionEquality().hash(threads),
    totalUnreadCount,
    const DeepCollectionEquality().hash(totalUnreadCountByTeam),
    totalUnreadThreadsCount,
  );

  @override
  String toString() {
    return 'WrappedUnreadCountsResponse(channelType: $channelType, channels: $channels, duration: $duration, threads: $threads, totalUnreadCount: $totalUnreadCount, totalUnreadCountByTeam: $totalUnreadCountByTeam, totalUnreadThreadsCount: $totalUnreadThreadsCount)';
  }
}

/// @nodoc
abstract mixin class $WrappedUnreadCountsResponseCopyWith<$Res> {
  factory $WrappedUnreadCountsResponseCopyWith(
    WrappedUnreadCountsResponse value,
    $Res Function(WrappedUnreadCountsResponse) _then,
  ) = _$WrappedUnreadCountsResponseCopyWithImpl;
  @useResult
  $Res call({
    List<UnreadCountsChannelType> channelType,
    List<UnreadCountsChannel> channels,
    String duration,
    List<UnreadCountsThread> threads,
    int totalUnreadCount,
    Map<String, int>? totalUnreadCountByTeam,
    int totalUnreadThreadsCount,
  });
}

/// @nodoc
class _$WrappedUnreadCountsResponseCopyWithImpl<$Res> implements $WrappedUnreadCountsResponseCopyWith<$Res> {
  _$WrappedUnreadCountsResponseCopyWithImpl(this._self, this._then);

  final WrappedUnreadCountsResponse _self;
  final $Res Function(WrappedUnreadCountsResponse) _then;

  /// Create a copy of WrappedUnreadCountsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelType = null,
    Object? channels = null,
    Object? duration = null,
    Object? threads = null,
    Object? totalUnreadCount = null,
    Object? totalUnreadCountByTeam = freezed,
    Object? totalUnreadThreadsCount = null,
  }) {
    return _then(
      WrappedUnreadCountsResponse(
        channelType: null == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as List<UnreadCountsChannelType>,
        channels: null == channels
            ? _self.channels
            : channels // ignore: cast_nullable_to_non_nullable
                  as List<UnreadCountsChannel>,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        threads: null == threads
            ? _self.threads
            : threads // ignore: cast_nullable_to_non_nullable
                  as List<UnreadCountsThread>,
        totalUnreadCount: null == totalUnreadCount
            ? _self.totalUnreadCount
            : totalUnreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalUnreadCountByTeam: freezed == totalUnreadCountByTeam
            ? _self.totalUnreadCountByTeam
            : totalUnreadCountByTeam // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
        totalUnreadThreadsCount: null == totalUnreadThreadsCount
            ? _self.totalUnreadThreadsCount
            : totalUnreadThreadsCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
