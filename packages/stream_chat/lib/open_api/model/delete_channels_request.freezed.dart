// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_channels_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteChannelsRequest {
  List<String> get cids;
  bool? get hardDelete;

  /// Create a copy of DeleteChannelsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeleteChannelsRequestCopyWith<DeleteChannelsRequest> get copyWith =>
      _$DeleteChannelsRequestCopyWithImpl<DeleteChannelsRequest>(
        this as DeleteChannelsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeleteChannelsRequest &&
            const DeepCollectionEquality().equals(other.cids, cids) &&
            (identical(other.hardDelete, hardDelete) || other.hardDelete == hardDelete));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(cids),
    hardDelete,
  );

  @override
  String toString() {
    return 'DeleteChannelsRequest(cids: $cids, hardDelete: $hardDelete)';
  }
}

/// @nodoc
abstract mixin class $DeleteChannelsRequestCopyWith<$Res> {
  factory $DeleteChannelsRequestCopyWith(
    DeleteChannelsRequest value,
    $Res Function(DeleteChannelsRequest) _then,
  ) = _$DeleteChannelsRequestCopyWithImpl;
  @useResult
  $Res call({List<String> cids, bool? hardDelete});
}

/// @nodoc
class _$DeleteChannelsRequestCopyWithImpl<$Res> implements $DeleteChannelsRequestCopyWith<$Res> {
  _$DeleteChannelsRequestCopyWithImpl(this._self, this._then);

  final DeleteChannelsRequest _self;
  final $Res Function(DeleteChannelsRequest) _then;

  /// Create a copy of DeleteChannelsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? cids = null, Object? hardDelete = freezed}) {
    return _then(
      DeleteChannelsRequest(
        cids: null == cids
            ? _self.cids
            : cids // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        hardDelete: freezed == hardDelete
            ? _self.hardDelete
            : hardDelete // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
