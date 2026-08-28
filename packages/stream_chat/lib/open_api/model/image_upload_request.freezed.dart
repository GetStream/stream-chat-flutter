// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_upload_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImageUploadRequest {
  String? get file;
  List<ImageSize>? get uploadSizes;
  OnlyUserID? get user;

  /// Create a copy of ImageUploadRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImageUploadRequestCopyWith<ImageUploadRequest> get copyWith =>
      _$ImageUploadRequestCopyWithImpl<ImageUploadRequest>(
        this as ImageUploadRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ImageUploadRequest &&
            (identical(other.file, file) || other.file == file) &&
            const DeepCollectionEquality().equals(
              other.uploadSizes,
              uploadSizes,
            ) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    file,
    const DeepCollectionEquality().hash(uploadSizes),
    user,
  );

  @override
  String toString() {
    return 'ImageUploadRequest(file: $file, uploadSizes: $uploadSizes, user: $user)';
  }
}

/// @nodoc
abstract mixin class $ImageUploadRequestCopyWith<$Res> {
  factory $ImageUploadRequestCopyWith(
    ImageUploadRequest value,
    $Res Function(ImageUploadRequest) _then,
  ) = _$ImageUploadRequestCopyWithImpl;
  @useResult
  $Res call({String? file, List<ImageSize>? uploadSizes, OnlyUserID? user});
}

/// @nodoc
class _$ImageUploadRequestCopyWithImpl<$Res>
    implements $ImageUploadRequestCopyWith<$Res> {
  _$ImageUploadRequestCopyWithImpl(this._self, this._then);

  final ImageUploadRequest _self;
  final $Res Function(ImageUploadRequest) _then;

  /// Create a copy of ImageUploadRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? file = freezed,
    Object? uploadSizes = freezed,
    Object? user = freezed,
  }) {
    return _then(
      ImageUploadRequest(
        file: freezed == file
            ? _self.file
            : file // ignore: cast_nullable_to_non_nullable
                  as String?,
        uploadSizes: freezed == uploadSizes
            ? _self.uploadSizes
            : uploadSizes // ignore: cast_nullable_to_non_nullable
                  as List<ImageSize>?,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as OnlyUserID?,
      ),
    );
  }
}
