// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unread_counts_thread.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnreadCountsThread {
  DateTime get lastRead;
  String get lastReadMessageId;
  String get parentMessageId;
  int get unreadCount;

  /// Create a copy of UnreadCountsThread
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnreadCountsThreadCopyWith<UnreadCountsThread> get copyWith =>
      _$UnreadCountsThreadCopyWithImpl<UnreadCountsThread>(
        this as UnreadCountsThread,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnreadCountsThread &&
            (identical(other.lastRead, lastRead) ||
                other.lastRead == lastRead) &&
            (identical(other.lastReadMessageId, lastReadMessageId) ||
                other.lastReadMessageId == lastReadMessageId) &&
            (identical(other.parentMessageId, parentMessageId) ||
                other.parentMessageId == parentMessageId) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    lastRead,
    lastReadMessageId,
    parentMessageId,
    unreadCount,
  );

  @override
  String toString() {
    return 'UnreadCountsThread(lastRead: $lastRead, lastReadMessageId: $lastReadMessageId, parentMessageId: $parentMessageId, unreadCount: $unreadCount)';
  }
}

/// @nodoc
abstract mixin class $UnreadCountsThreadCopyWith<$Res> {
  factory $UnreadCountsThreadCopyWith(
    UnreadCountsThread value,
    $Res Function(UnreadCountsThread) _then,
  ) = _$UnreadCountsThreadCopyWithImpl;
  @useResult
  $Res call({
    DateTime lastRead,
    String lastReadMessageId,
    String parentMessageId,
    int unreadCount,
  });
}

/// @nodoc
class _$UnreadCountsThreadCopyWithImpl<$Res>
    implements $UnreadCountsThreadCopyWith<$Res> {
  _$UnreadCountsThreadCopyWithImpl(this._self, this._then);

  final UnreadCountsThread _self;
  final $Res Function(UnreadCountsThread) _then;

  /// Create a copy of UnreadCountsThread
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastRead = null,
    Object? lastReadMessageId = null,
    Object? parentMessageId = null,
    Object? unreadCount = null,
  }) {
    return _then(
      UnreadCountsThread(
        lastRead: null == lastRead
            ? _self.lastRead
            : lastRead // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastReadMessageId: null == lastReadMessageId
            ? _self.lastReadMessageId
            : lastReadMessageId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentMessageId: null == parentMessageId
            ? _self.parentMessageId
            : parentMessageId // ignore: cast_nullable_to_non_nullable
                  as String,
        unreadCount: null == unreadCount
            ? _self.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
