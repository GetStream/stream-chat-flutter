// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unread_counts_channel_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnreadCountsChannelType {
  String get channelType;
  int get channelCount;
  int get unreadCount;

  /// Create a copy of UnreadCountsChannelType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnreadCountsChannelTypeCopyWith<UnreadCountsChannelType> get copyWith =>
      _$UnreadCountsChannelTypeCopyWithImpl<UnreadCountsChannelType>(
        this as UnreadCountsChannelType,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnreadCountsChannelType &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelCount, channelCount) || other.channelCount == channelCount) &&
            (identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, channelType, channelCount, unreadCount);

  @override
  String toString() {
    return 'UnreadCountsChannelType(channelType: $channelType, channelCount: $channelCount, unreadCount: $unreadCount)';
  }
}

/// @nodoc
abstract mixin class $UnreadCountsChannelTypeCopyWith<$Res> {
  factory $UnreadCountsChannelTypeCopyWith(
    UnreadCountsChannelType value,
    $Res Function(UnreadCountsChannelType) _then,
  ) = _$UnreadCountsChannelTypeCopyWithImpl;
  @useResult
  $Res call({String channelType, int channelCount, int unreadCount});
}

/// @nodoc
class _$UnreadCountsChannelTypeCopyWithImpl<$Res> implements $UnreadCountsChannelTypeCopyWith<$Res> {
  _$UnreadCountsChannelTypeCopyWithImpl(this._self, this._then);

  final UnreadCountsChannelType _self;
  final $Res Function(UnreadCountsChannelType) _then;

  /// Create a copy of UnreadCountsChannelType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelType = null,
    Object? channelCount = null,
    Object? unreadCount = null,
  }) {
    return _then(
      UnreadCountsChannelType(
        channelType: null == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String,
        channelCount: null == channelCount
            ? _self.channelCount
            : channelCount // ignore: cast_nullable_to_non_nullable
                  as int,
        unreadCount: null == unreadCount
            ? _self.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
