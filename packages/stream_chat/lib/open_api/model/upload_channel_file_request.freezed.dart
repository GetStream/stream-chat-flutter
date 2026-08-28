// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_channel_file_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UploadChannelFileRequest {
  String? get file;
  OnlyUserID? get user;

  /// Create a copy of UploadChannelFileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UploadChannelFileRequestCopyWith<UploadChannelFileRequest> get copyWith =>
      _$UploadChannelFileRequestCopyWithImpl<UploadChannelFileRequest>(
        this as UploadChannelFileRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UploadChannelFileRequest &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, file, user);

  @override
  String toString() {
    return 'UploadChannelFileRequest(file: $file, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UploadChannelFileRequestCopyWith<$Res> {
  factory $UploadChannelFileRequestCopyWith(
    UploadChannelFileRequest value,
    $Res Function(UploadChannelFileRequest) _then,
  ) = _$UploadChannelFileRequestCopyWithImpl;
  @useResult
  $Res call({String? file, OnlyUserID? user});
}

/// @nodoc
class _$UploadChannelFileRequestCopyWithImpl<$Res>
    implements $UploadChannelFileRequestCopyWith<$Res> {
  _$UploadChannelFileRequestCopyWithImpl(this._self, this._then);

  final UploadChannelFileRequest _self;
  final $Res Function(UploadChannelFileRequest) _then;

  /// Create a copy of UploadChannelFileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? file = freezed, Object? user = freezed}) {
    return _then(
      UploadChannelFileRequest(
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
