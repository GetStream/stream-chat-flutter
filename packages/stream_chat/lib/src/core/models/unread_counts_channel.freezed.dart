// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unread_counts_channel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnreadCountsChannel {
  String get channelId;
  int get unreadCount;
  DateTime get lastRead;

  /// Create a copy of UnreadCountsChannel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnreadCountsChannelCopyWith<UnreadCountsChannel> get copyWith =>
      _$UnreadCountsChannelCopyWithImpl<UnreadCountsChannel>(
        this as UnreadCountsChannel,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnreadCountsChannel &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount) &&
            (identical(other.lastRead, lastRead) || other.lastRead == lastRead));
  }

  @override
  int get hashCode => Object.hash(runtimeType, channelId, unreadCount, lastRead);

  @override
  String toString() {
    return 'UnreadCountsChannel(channelId: $channelId, unreadCount: $unreadCount, lastRead: $lastRead)';
  }
}

/// @nodoc
abstract mixin class $UnreadCountsChannelCopyWith<$Res> {
  factory $UnreadCountsChannelCopyWith(
    UnreadCountsChannel value,
    $Res Function(UnreadCountsChannel) _then,
  ) = _$UnreadCountsChannelCopyWithImpl;
  @useResult
  $Res call({String channelId, int unreadCount, DateTime lastRead});
}

/// @nodoc
class _$UnreadCountsChannelCopyWithImpl<$Res> implements $UnreadCountsChannelCopyWith<$Res> {
  _$UnreadCountsChannelCopyWithImpl(this._self, this._then);

  final UnreadCountsChannel _self;
  final $Res Function(UnreadCountsChannel) _then;

  /// Create a copy of UnreadCountsChannel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelId = null,
    Object? unreadCount = null,
    Object? lastRead = null,
  }) {
    return _then(
      UnreadCountsChannel(
        channelId: null == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String,
        unreadCount: null == unreadCount
            ? _self.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        lastRead: null == lastRead
            ? _self.lastRead
            : lastRead // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
