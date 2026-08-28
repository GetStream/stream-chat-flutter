// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_channel_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UploadChannelResponse {
  String get duration;
  String? get file;
  String? get moderationAction;
  String? get thumbUrl;
  List<ImageSize>? get uploadSizes;

  /// Create a copy of UploadChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UploadChannelResponseCopyWith<UploadChannelResponse> get copyWith =>
      _$UploadChannelResponseCopyWithImpl<UploadChannelResponse>(
        this as UploadChannelResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UploadChannelResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.moderationAction, moderationAction) ||
                other.moderationAction == moderationAction) &&
            (identical(other.thumbUrl, thumbUrl) ||
                other.thumbUrl == thumbUrl) &&
            const DeepCollectionEquality().equals(
              other.uploadSizes,
              uploadSizes,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    file,
    moderationAction,
    thumbUrl,
    const DeepCollectionEquality().hash(uploadSizes),
  );

  @override
  String toString() {
    return 'UploadChannelResponse(duration: $duration, file: $file, moderationAction: $moderationAction, thumbUrl: $thumbUrl, uploadSizes: $uploadSizes)';
  }
}

/// @nodoc
abstract mixin class $UploadChannelResponseCopyWith<$Res> {
  factory $UploadChannelResponseCopyWith(
    UploadChannelResponse value,
    $Res Function(UploadChannelResponse) _then,
  ) = _$UploadChannelResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    String? file,
    String? moderationAction,
    String? thumbUrl,
    List<ImageSize>? uploadSizes,
  });
}

/// @nodoc
class _$UploadChannelResponseCopyWithImpl<$Res>
    implements $UploadChannelResponseCopyWith<$Res> {
  _$UploadChannelResponseCopyWithImpl(this._self, this._then);

  final UploadChannelResponse _self;
  final $Res Function(UploadChannelResponse) _then;

  /// Create a copy of UploadChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? file = freezed,
    Object? moderationAction = freezed,
    Object? thumbUrl = freezed,
    Object? uploadSizes = freezed,
  }) {
    return _then(
      UploadChannelResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        file: freezed == file
            ? _self.file
            : file // ignore: cast_nullable_to_non_nullable
                  as String?,
        moderationAction: freezed == moderationAction
            ? _self.moderationAction
            : moderationAction // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbUrl: freezed == thumbUrl
            ? _self.thumbUrl
            : thumbUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        uploadSizes: freezed == uploadSizes
            ? _self.uploadSizes
            : uploadSizes // ignore: cast_nullable_to_non_nullable
                  as List<ImageSize>?,
      ),
    );
  }
}
