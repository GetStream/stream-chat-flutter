// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_rewind_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelRewindResponse {
  DateTime get createdAt;
  int get hiddenCountAtRewind;
  String get id;
  bool get inclusive;
  String get messageId;

  /// Create a copy of ChannelRewindResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelRewindResponseCopyWith<ChannelRewindResponse> get copyWith =>
      _$ChannelRewindResponseCopyWithImpl<ChannelRewindResponse>(
        this as ChannelRewindResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelRewindResponse &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.hiddenCountAtRewind, hiddenCountAtRewind) ||
                other.hiddenCountAtRewind == hiddenCountAtRewind) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.inclusive, inclusive) || other.inclusive == inclusive) &&
            (identical(other.messageId, messageId) || other.messageId == messageId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    hiddenCountAtRewind,
    id,
    inclusive,
    messageId,
  );

  @override
  String toString() {
    return 'ChannelRewindResponse(createdAt: $createdAt, hiddenCountAtRewind: $hiddenCountAtRewind, id: $id, inclusive: $inclusive, messageId: $messageId)';
  }
}

/// @nodoc
abstract mixin class $ChannelRewindResponseCopyWith<$Res> {
  factory $ChannelRewindResponseCopyWith(
    ChannelRewindResponse value,
    $Res Function(ChannelRewindResponse) _then,
  ) = _$ChannelRewindResponseCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    int hiddenCountAtRewind,
    String id,
    bool inclusive,
    String messageId,
  });
}

/// @nodoc
class _$ChannelRewindResponseCopyWithImpl<$Res> implements $ChannelRewindResponseCopyWith<$Res> {
  _$ChannelRewindResponseCopyWithImpl(this._self, this._then);

  final ChannelRewindResponse _self;
  final $Res Function(ChannelRewindResponse) _then;

  /// Create a copy of ChannelRewindResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? hiddenCountAtRewind = null,
    Object? id = null,
    Object? inclusive = null,
    Object? messageId = null,
  }) {
    return _then(
      ChannelRewindResponse(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        hiddenCountAtRewind: null == hiddenCountAtRewind
            ? _self.hiddenCountAtRewind
            : hiddenCountAtRewind // ignore: cast_nullable_to_non_nullable
                  as int,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        inclusive: null == inclusive
            ? _self.inclusive
            : inclusive // ignore: cast_nullable_to_non_nullable
                  as bool,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
