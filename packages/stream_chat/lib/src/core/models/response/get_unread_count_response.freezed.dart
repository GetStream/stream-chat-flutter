// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_unread_count_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetUnreadCountResponse {
  String get duration;
  int get totalUnreadCount;
  int get totalUnreadThreadsCount;
  Map<String, int>? get totalUnreadCountByTeam;
  List<UnreadCountsChannel> get channels;
  List<UnreadCountsChannelType> get channelType;
  List<UnreadCountsThread> get threads;

  /// Create a copy of GetUnreadCountResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GetUnreadCountResponseCopyWith<GetUnreadCountResponse> get copyWith =>
      _$GetUnreadCountResponseCopyWithImpl<GetUnreadCountResponse>(
        this as GetUnreadCountResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GetUnreadCountResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.totalUnreadCount, totalUnreadCount) || other.totalUnreadCount == totalUnreadCount) &&
            (identical(
                  other.totalUnreadThreadsCount,
                  totalUnreadThreadsCount,
                ) ||
                other.totalUnreadThreadsCount == totalUnreadThreadsCount) &&
            const DeepCollectionEquality().equals(
              other.totalUnreadCountByTeam,
              totalUnreadCountByTeam,
            ) &&
            const DeepCollectionEquality().equals(other.channels, channels) &&
            const DeepCollectionEquality().equals(
              other.channelType,
              channelType,
            ) &&
            const DeepCollectionEquality().equals(other.threads, threads));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    totalUnreadCount,
    totalUnreadThreadsCount,
    const DeepCollectionEquality().hash(totalUnreadCountByTeam),
    const DeepCollectionEquality().hash(channels),
    const DeepCollectionEquality().hash(channelType),
    const DeepCollectionEquality().hash(threads),
  );

  @override
  String toString() {
    return 'GetUnreadCountResponse(duration: $duration, totalUnreadCount: $totalUnreadCount, totalUnreadThreadsCount: $totalUnreadThreadsCount, totalUnreadCountByTeam: $totalUnreadCountByTeam, channels: $channels, channelType: $channelType, threads: $threads)';
  }
}

/// @nodoc
abstract mixin class $GetUnreadCountResponseCopyWith<$Res> {
  factory $GetUnreadCountResponseCopyWith(
    GetUnreadCountResponse value,
    $Res Function(GetUnreadCountResponse) _then,
  ) = _$GetUnreadCountResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    int totalUnreadCount,
    int totalUnreadThreadsCount,
    Map<String, int>? totalUnreadCountByTeam,
    List<UnreadCountsChannel> channels,
    List<UnreadCountsChannelType> channelType,
    List<UnreadCountsThread> threads,
  });
}

/// @nodoc
class _$GetUnreadCountResponseCopyWithImpl<$Res> implements $GetUnreadCountResponseCopyWith<$Res> {
  _$GetUnreadCountResponseCopyWithImpl(this._self, this._then);

  final GetUnreadCountResponse _self;
  final $Res Function(GetUnreadCountResponse) _then;

  /// Create a copy of GetUnreadCountResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? totalUnreadCount = null,
    Object? totalUnreadThreadsCount = null,
    Object? totalUnreadCountByTeam = freezed,
    Object? channels = null,
    Object? channelType = null,
    Object? threads = null,
  }) {
    return _then(
      GetUnreadCountResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        totalUnreadCount: null == totalUnreadCount
            ? _self.totalUnreadCount
            : totalUnreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalUnreadThreadsCount: null == totalUnreadThreadsCount
            ? _self.totalUnreadThreadsCount
            : totalUnreadThreadsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalUnreadCountByTeam: freezed == totalUnreadCountByTeam
            ? _self.totalUnreadCountByTeam
            : totalUnreadCountByTeam // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
        channels: null == channels
            ? _self.channels
            : channels // ignore: cast_nullable_to_non_nullable
                  as List<UnreadCountsChannel>,
        channelType: null == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as List<UnreadCountsChannelType>,
        threads: null == threads
            ? _self.threads
            : threads // ignore: cast_nullable_to_non_nullable
                  as List<UnreadCountsThread>,
      ),
    );
  }
}
