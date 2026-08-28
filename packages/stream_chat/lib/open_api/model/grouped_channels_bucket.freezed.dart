// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grouped_channels_bucket.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupedChannelsBucket {
  List<ChannelStateResponseFields> get channels;
  String? get next;
  String? get prev;
  int? get unreadChannels;

  /// Create a copy of GroupedChannelsBucket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupedChannelsBucketCopyWith<GroupedChannelsBucket> get copyWith =>
      _$GroupedChannelsBucketCopyWithImpl<GroupedChannelsBucket>(
        this as GroupedChannelsBucket,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GroupedChannelsBucket &&
            const DeepCollectionEquality().equals(other.channels, channels) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.prev, prev) || other.prev == prev) &&
            (identical(other.unreadChannels, unreadChannels) || other.unreadChannels == unreadChannels));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channels),
    next,
    prev,
    unreadChannels,
  );

  @override
  String toString() {
    return 'GroupedChannelsBucket(channels: $channels, next: $next, prev: $prev, unreadChannels: $unreadChannels)';
  }
}

/// @nodoc
abstract mixin class $GroupedChannelsBucketCopyWith<$Res> {
  factory $GroupedChannelsBucketCopyWith(
    GroupedChannelsBucket value,
    $Res Function(GroupedChannelsBucket) _then,
  ) = _$GroupedChannelsBucketCopyWithImpl;
  @useResult
  $Res call({
    List<ChannelStateResponseFields> channels,
    String? next,
    String? prev,
    int? unreadChannels,
  });
}

/// @nodoc
class _$GroupedChannelsBucketCopyWithImpl<$Res> implements $GroupedChannelsBucketCopyWith<$Res> {
  _$GroupedChannelsBucketCopyWithImpl(this._self, this._then);

  final GroupedChannelsBucket _self;
  final $Res Function(GroupedChannelsBucket) _then;

  /// Create a copy of GroupedChannelsBucket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channels = null,
    Object? next = freezed,
    Object? prev = freezed,
    Object? unreadChannels = freezed,
  }) {
    return _then(
      GroupedChannelsBucket(
        channels: null == channels
            ? _self.channels
            : channels // ignore: cast_nullable_to_non_nullable
                  as List<ChannelStateResponseFields>,
        next: freezed == next
            ? _self.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String?,
        prev: freezed == prev
            ? _self.prev
            : prev // ignore: cast_nullable_to_non_nullable
                  as String?,
        unreadChannels: freezed == unreadChannels
            ? _self.unreadChannels
            : unreadChannels // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
