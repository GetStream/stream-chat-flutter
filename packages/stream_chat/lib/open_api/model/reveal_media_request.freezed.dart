// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reveal_media_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RevealMediaRequest {
  String get itemId;

  /// Create a copy of RevealMediaRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RevealMediaRequestCopyWith<RevealMediaRequest> get copyWith => _$RevealMediaRequestCopyWithImpl<RevealMediaRequest>(
    this as RevealMediaRequest,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RevealMediaRequest &&
            (identical(other.itemId, itemId) || other.itemId == itemId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, itemId);

  @override
  String toString() {
    return 'RevealMediaRequest(itemId: $itemId)';
  }
}

/// @nodoc
abstract mixin class $RevealMediaRequestCopyWith<$Res> {
  factory $RevealMediaRequestCopyWith(
    RevealMediaRequest value,
    $Res Function(RevealMediaRequest) _then,
  ) = _$RevealMediaRequestCopyWithImpl;
  @useResult
  $Res call({String itemId});
}

/// @nodoc
class _$RevealMediaRequestCopyWithImpl<$Res> implements $RevealMediaRequestCopyWith<$Res> {
  _$RevealMediaRequestCopyWithImpl(this._self, this._then);

  final RevealMediaRequest _self;
  final $Res Function(RevealMediaRequest) _then;

  /// Create a copy of RevealMediaRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? itemId = null}) {
    return _then(
      RevealMediaRequest(
        itemId: null == itemId
            ? _self.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
