// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserRequest {
  Map<String, Object?>? get custom;
  String get id;
  String? get image;
  bool? get invisible;
  String? get language;
  String? get name;
  PrivacySettingsResponse? get privacySettings;

  /// Create a copy of UserRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserRequestCopyWith<UserRequest> get copyWith =>
      _$UserRequestCopyWithImpl<UserRequest>(this as UserRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserRequest &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.invisible, invisible) ||
                other.invisible == invisible) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.privacySettings, privacySettings) ||
                other.privacySettings == privacySettings));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(custom),
    id,
    image,
    invisible,
    language,
    name,
    privacySettings,
  );

  @override
  String toString() {
    return 'UserRequest(custom: $custom, id: $id, image: $image, invisible: $invisible, language: $language, name: $name, privacySettings: $privacySettings)';
  }
}

/// @nodoc
abstract mixin class $UserRequestCopyWith<$Res> {
  factory $UserRequestCopyWith(
    UserRequest value,
    $Res Function(UserRequest) _then,
  ) = _$UserRequestCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?>? custom,
    String id,
    String? image,
    bool? invisible,
    String? language,
    String? name,
    PrivacySettingsResponse? privacySettings,
  });
}

/// @nodoc
class _$UserRequestCopyWithImpl<$Res> implements $UserRequestCopyWith<$Res> {
  _$UserRequestCopyWithImpl(this._self, this._then);

  final UserRequest _self;
  final $Res Function(UserRequest) _then;

  /// Create a copy of UserRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? custom = freezed,
    Object? id = null,
    Object? image = freezed,
    Object? invisible = freezed,
    Object? language = freezed,
    Object? name = freezed,
    Object? privacySettings = freezed,
  }) {
    return _then(
      UserRequest(
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        image: freezed == image
            ? _self.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String?,
        invisible: freezed == invisible
            ? _self.invisible
            : invisible // ignore: cast_nullable_to_non_nullable
                  as bool?,
        language: freezed == language
            ? _self.language
            : language // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        privacySettings: freezed == privacySettings
            ? _self.privacySettings
            : privacySettings // ignore: cast_nullable_to_non_nullable
                  as PrivacySettingsResponse?,
      ),
    );
  }
}
