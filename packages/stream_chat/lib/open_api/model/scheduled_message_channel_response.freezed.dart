// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduled_message_channel_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduledMessageChannelResponse {
  String get cid;
  String get id;
  String? get image;
  String? get name;
  String get type;

  /// Create a copy of ScheduledMessageChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduledMessageChannelResponseCopyWith<ScheduledMessageChannelResponse> get copyWith =>
      _$ScheduledMessageChannelResponseCopyWithImpl<ScheduledMessageChannelResponse>(
        this as ScheduledMessageChannelResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScheduledMessageChannelResponse &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cid, id, image, name, type);

  @override
  String toString() {
    return 'ScheduledMessageChannelResponse(cid: $cid, id: $id, image: $image, name: $name, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ScheduledMessageChannelResponseCopyWith<$Res> {
  factory $ScheduledMessageChannelResponseCopyWith(
    ScheduledMessageChannelResponse value,
    $Res Function(ScheduledMessageChannelResponse) _then,
  ) = _$ScheduledMessageChannelResponseCopyWithImpl;
  @useResult
  $Res call({String cid, String id, String? image, String? name, String type});
}

/// @nodoc
class _$ScheduledMessageChannelResponseCopyWithImpl<$Res> implements $ScheduledMessageChannelResponseCopyWith<$Res> {
  _$ScheduledMessageChannelResponseCopyWithImpl(this._self, this._then);

  final ScheduledMessageChannelResponse _self;
  final $Res Function(ScheduledMessageChannelResponse) _then;

  /// Create a copy of ScheduledMessageChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = null,
    Object? id = null,
    Object? image = freezed,
    Object? name = freezed,
    Object? type = null,
  }) {
    return _then(
      ScheduledMessageChannelResponse(
        cid: null == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        image: freezed == image
            ? _self.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
