// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduled_messages_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduledMessagesFilter {
  String? get cid;
  List<ScheduledMessageQueryStatus>? get status;

  /// Create a copy of ScheduledMessagesFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduledMessagesFilterCopyWith<ScheduledMessagesFilter> get copyWith =>
      _$ScheduledMessagesFilterCopyWithImpl<ScheduledMessagesFilter>(
        this as ScheduledMessagesFilter,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScheduledMessagesFilter &&
            (identical(other.cid, cid) || other.cid == cid) &&
            const DeepCollectionEquality().equals(other.status, status));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    const DeepCollectionEquality().hash(status),
  );

  @override
  String toString() {
    return 'ScheduledMessagesFilter(cid: $cid, status: $status)';
  }
}

/// @nodoc
abstract mixin class $ScheduledMessagesFilterCopyWith<$Res> {
  factory $ScheduledMessagesFilterCopyWith(
    ScheduledMessagesFilter value,
    $Res Function(ScheduledMessagesFilter) _then,
  ) = _$ScheduledMessagesFilterCopyWithImpl;
  @useResult
  $Res call({String? cid, List<ScheduledMessageQueryStatus>? status});
}

/// @nodoc
class _$ScheduledMessagesFilterCopyWithImpl<$Res> implements $ScheduledMessagesFilterCopyWith<$Res> {
  _$ScheduledMessagesFilterCopyWithImpl(this._self, this._then);

  final ScheduledMessagesFilter _self;
  final $Res Function(ScheduledMessagesFilter) _then;

  /// Create a copy of ScheduledMessagesFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? cid = freezed, Object? status = freezed}) {
    return _then(
      ScheduledMessagesFilter(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as List<ScheduledMessageQueryStatus>?,
      ),
    );
  }
}
