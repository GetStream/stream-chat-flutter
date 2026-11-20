// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_delivery.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageDelivery {
  String get channelCid;
  String get messageId;

  /// Create a copy of MessageDelivery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageDeliveryCopyWith<MessageDelivery> get copyWith => _$MessageDeliveryCopyWithImpl<MessageDelivery>(
    this as MessageDelivery,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageDelivery &&
            (identical(other.channelCid, channelCid) || other.channelCid == channelCid) &&
            (identical(other.messageId, messageId) || other.messageId == messageId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, channelCid, messageId);

  @override
  String toString() {
    return 'MessageDelivery(channelCid: $channelCid, messageId: $messageId)';
  }
}

/// @nodoc
abstract mixin class $MessageDeliveryCopyWith<$Res> {
  factory $MessageDeliveryCopyWith(
    MessageDelivery value,
    $Res Function(MessageDelivery) _then,
  ) = _$MessageDeliveryCopyWithImpl;
  @useResult
  $Res call({String channelCid, String messageId});
}

/// @nodoc
class _$MessageDeliveryCopyWithImpl<$Res> implements $MessageDeliveryCopyWith<$Res> {
  _$MessageDeliveryCopyWithImpl(this._self, this._then);

  final MessageDelivery _self;
  final $Res Function(MessageDelivery) _then;

  /// Create a copy of MessageDelivery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? channelCid = null, Object? messageId = null}) {
    return _then(
      MessageDelivery(
        channelCid: null == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
