// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mark_channels_read_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarkChannelsReadRequest {
  Map<String, String>? get readByChannel;

  /// Create a copy of MarkChannelsReadRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MarkChannelsReadRequestCopyWith<MarkChannelsReadRequest> get copyWith =>
      _$MarkChannelsReadRequestCopyWithImpl<MarkChannelsReadRequest>(
        this as MarkChannelsReadRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MarkChannelsReadRequest &&
            const DeepCollectionEquality().equals(
              other.readByChannel,
              readByChannel,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(readByChannel),
  );

  @override
  String toString() {
    return 'MarkChannelsReadRequest(readByChannel: $readByChannel)';
  }
}

/// @nodoc
abstract mixin class $MarkChannelsReadRequestCopyWith<$Res> {
  factory $MarkChannelsReadRequestCopyWith(
    MarkChannelsReadRequest value,
    $Res Function(MarkChannelsReadRequest) _then,
  ) = _$MarkChannelsReadRequestCopyWithImpl;
  @useResult
  $Res call({Map<String, String>? readByChannel});
}

/// @nodoc
class _$MarkChannelsReadRequestCopyWithImpl<$Res> implements $MarkChannelsReadRequestCopyWith<$Res> {
  _$MarkChannelsReadRequestCopyWithImpl(this._self, this._then);

  final MarkChannelsReadRequest _self;
  final $Res Function(MarkChannelsReadRequest) _then;

  /// Create a copy of MarkChannelsReadRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? readByChannel = freezed}) {
    return _then(
      MarkChannelsReadRequest(
        readByChannel: freezed == readByChannel
            ? _self.readByChannel
            : readByChannel // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
      ),
    );
  }
}
