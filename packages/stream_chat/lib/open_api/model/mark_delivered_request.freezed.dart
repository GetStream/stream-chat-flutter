// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mark_delivered_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarkDeliveredRequest {
  List<DeliveredMessagePayload>? get latestDeliveredMessages;

  /// Create a copy of MarkDeliveredRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MarkDeliveredRequestCopyWith<MarkDeliveredRequest> get copyWith =>
      _$MarkDeliveredRequestCopyWithImpl<MarkDeliveredRequest>(
        this as MarkDeliveredRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MarkDeliveredRequest &&
            const DeepCollectionEquality().equals(
              other.latestDeliveredMessages,
              latestDeliveredMessages,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(latestDeliveredMessages),
  );

  @override
  String toString() {
    return 'MarkDeliveredRequest(latestDeliveredMessages: $latestDeliveredMessages)';
  }
}

/// @nodoc
abstract mixin class $MarkDeliveredRequestCopyWith<$Res> {
  factory $MarkDeliveredRequestCopyWith(
    MarkDeliveredRequest value,
    $Res Function(MarkDeliveredRequest) _then,
  ) = _$MarkDeliveredRequestCopyWithImpl;
  @useResult
  $Res call({List<DeliveredMessagePayload>? latestDeliveredMessages});
}

/// @nodoc
class _$MarkDeliveredRequestCopyWithImpl<$Res>
    implements $MarkDeliveredRequestCopyWith<$Res> {
  _$MarkDeliveredRequestCopyWithImpl(this._self, this._then);

  final MarkDeliveredRequest _self;
  final $Res Function(MarkDeliveredRequest) _then;

  /// Create a copy of MarkDeliveredRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? latestDeliveredMessages = freezed}) {
    return _then(
      MarkDeliveredRequest(
        latestDeliveredMessages: freezed == latestDeliveredMessages
            ? _self.latestDeliveredMessages
            : latestDeliveredMessages // ignore: cast_nullable_to_non_nullable
                  as List<DeliveredMessagePayload>?,
      ),
    );
  }
}
