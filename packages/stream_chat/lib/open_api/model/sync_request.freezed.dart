// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncRequest {
  List<String> get channelCids;
  DateTime get lastSyncAt;

  /// Create a copy of SyncRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SyncRequestCopyWith<SyncRequest> get copyWith =>
      _$SyncRequestCopyWithImpl<SyncRequest>(this as SyncRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SyncRequest &&
            const DeepCollectionEquality().equals(
              other.channelCids,
              channelCids,
            ) &&
            (identical(other.lastSyncAt, lastSyncAt) || other.lastSyncAt == lastSyncAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channelCids),
    lastSyncAt,
  );

  @override
  String toString() {
    return 'SyncRequest(channelCids: $channelCids, lastSyncAt: $lastSyncAt)';
  }
}

/// @nodoc
abstract mixin class $SyncRequestCopyWith<$Res> {
  factory $SyncRequestCopyWith(
    SyncRequest value,
    $Res Function(SyncRequest) _then,
  ) = _$SyncRequestCopyWithImpl;
  @useResult
  $Res call({List<String> channelCids, DateTime lastSyncAt});
}

/// @nodoc
class _$SyncRequestCopyWithImpl<$Res> implements $SyncRequestCopyWith<$Res> {
  _$SyncRequestCopyWithImpl(this._self, this._then);

  final SyncRequest _self;
  final $Res Function(SyncRequest) _then;

  /// Create a copy of SyncRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? channelCids = null, Object? lastSyncAt = null}) {
    return _then(
      SyncRequest(
        channelCids: null == channelCids
            ? _self.channelCids
            : channelCids // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        lastSyncAt: null == lastSyncAt
            ? _self.lastSyncAt
            : lastSyncAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
