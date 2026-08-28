// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_shared_location_response_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatSharedLocationResponseData {
  String get channelCid;
  DateTime get createdAt;
  String get createdByDeviceId;
  DateTime? get endAt;
  double get latitude;
  double get longitude;
  ChatMessageResponse? get message;
  String get messageId;
  DateTime get updatedAt;
  String get userId;

  /// Create a copy of ChatSharedLocationResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatSharedLocationResponseDataCopyWith<ChatSharedLocationResponseData>
  get copyWith =>
      _$ChatSharedLocationResponseDataCopyWithImpl<
        ChatSharedLocationResponseData
      >(this as ChatSharedLocationResponseData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatSharedLocationResponseData &&
            (identical(other.channelCid, channelCid) ||
                other.channelCid == channelCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdByDeviceId, createdByDeviceId) ||
                other.createdByDeviceId == createdByDeviceId) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelCid,
    createdAt,
    createdByDeviceId,
    endAt,
    latitude,
    longitude,
    message,
    messageId,
    updatedAt,
    userId,
  );

  @override
  String toString() {
    return 'ChatSharedLocationResponseData(channelCid: $channelCid, createdAt: $createdAt, createdByDeviceId: $createdByDeviceId, endAt: $endAt, latitude: $latitude, longitude: $longitude, message: $message, messageId: $messageId, updatedAt: $updatedAt, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $ChatSharedLocationResponseDataCopyWith<$Res> {
  factory $ChatSharedLocationResponseDataCopyWith(
    ChatSharedLocationResponseData value,
    $Res Function(ChatSharedLocationResponseData) _then,
  ) = _$ChatSharedLocationResponseDataCopyWithImpl;
  @useResult
  $Res call({
    String channelCid,
    DateTime createdAt,
    String createdByDeviceId,
    DateTime? endAt,
    double latitude,
    double longitude,
    ChatMessageResponse? message,
    String messageId,
    DateTime updatedAt,
    String userId,
  });
}

/// @nodoc
class _$ChatSharedLocationResponseDataCopyWithImpl<$Res>
    implements $ChatSharedLocationResponseDataCopyWith<$Res> {
  _$ChatSharedLocationResponseDataCopyWithImpl(this._self, this._then);

  final ChatSharedLocationResponseData _self;
  final $Res Function(ChatSharedLocationResponseData) _then;

  /// Create a copy of ChatSharedLocationResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelCid = null,
    Object? createdAt = null,
    Object? createdByDeviceId = null,
    Object? endAt = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? message = freezed,
    Object? messageId = null,
    Object? updatedAt = null,
    Object? userId = null,
  }) {
    return _then(
      ChatSharedLocationResponseData(
        channelCid: null == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdByDeviceId: null == createdByDeviceId
            ? _self.createdByDeviceId
            : createdByDeviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        endAt: freezed == endAt
            ? _self.endAt
            : endAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        latitude: null == latitude
            ? _self.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _self.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as ChatMessageResponse?,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
