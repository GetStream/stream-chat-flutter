// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_upload_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FileUploadRequest {
  String? get file;
  OnlyUserID? get user;

  /// Create a copy of FileUploadRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FileUploadRequestCopyWith<FileUploadRequest> get copyWith =>
      _$FileUploadRequestCopyWithImpl<FileUploadRequest>(
        this as FileUploadRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FileUploadRequest &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, file, user);

  @override
  String toString() {
    return 'FileUploadRequest(file: $file, user: $user)';
  }
}

/// @nodoc
abstract mixin class $FileUploadRequestCopyWith<$Res> {
  factory $FileUploadRequestCopyWith(
    FileUploadRequest value,
    $Res Function(FileUploadRequest) _then,
  ) = _$FileUploadRequestCopyWithImpl;
  @useResult
  $Res call({String? file, OnlyUserID? user});
}

/// @nodoc
class _$FileUploadRequestCopyWithImpl<$Res>
    implements $FileUploadRequestCopyWith<$Res> {
  _$FileUploadRequestCopyWithImpl(this._self, this._then);

  final FileUploadRequest _self;
  final $Res Function(FileUploadRequest) _then;

  /// Create a copy of FileUploadRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? file = freezed, Object? user = freezed}) {
    return _then(
      FileUploadRequest(
        file: freezed == file
            ? _self.file
            : file // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as OnlyUserID?,
      ),
    );
  }
}
