// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flag_message_details_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlagMessageDetailsResponse {
  bool? get pinChanged;
  bool? get shouldEnrich;
  bool? get skipPush;
  String? get updatedById;

  /// Create a copy of FlagMessageDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FlagMessageDetailsResponseCopyWith<FlagMessageDetailsResponse> get copyWith =>
      _$FlagMessageDetailsResponseCopyWithImpl<FlagMessageDetailsResponse>(
        this as FlagMessageDetailsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FlagMessageDetailsResponse &&
            (identical(other.pinChanged, pinChanged) || other.pinChanged == pinChanged) &&
            (identical(other.shouldEnrich, shouldEnrich) || other.shouldEnrich == shouldEnrich) &&
            (identical(other.skipPush, skipPush) || other.skipPush == skipPush) &&
            (identical(other.updatedById, updatedById) || other.updatedById == updatedById));
  }

  @override
  int get hashCode => Object.hash(runtimeType, pinChanged, shouldEnrich, skipPush, updatedById);

  @override
  String toString() {
    return 'FlagMessageDetailsResponse(pinChanged: $pinChanged, shouldEnrich: $shouldEnrich, skipPush: $skipPush, updatedById: $updatedById)';
  }
}

/// @nodoc
abstract mixin class $FlagMessageDetailsResponseCopyWith<$Res> {
  factory $FlagMessageDetailsResponseCopyWith(
    FlagMessageDetailsResponse value,
    $Res Function(FlagMessageDetailsResponse) _then,
  ) = _$FlagMessageDetailsResponseCopyWithImpl;
  @useResult
  $Res call({
    bool? pinChanged,
    bool? shouldEnrich,
    bool? skipPush,
    String? updatedById,
  });
}

/// @nodoc
class _$FlagMessageDetailsResponseCopyWithImpl<$Res> implements $FlagMessageDetailsResponseCopyWith<$Res> {
  _$FlagMessageDetailsResponseCopyWithImpl(this._self, this._then);

  final FlagMessageDetailsResponse _self;
  final $Res Function(FlagMessageDetailsResponse) _then;

  /// Create a copy of FlagMessageDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pinChanged = freezed,
    Object? shouldEnrich = freezed,
    Object? skipPush = freezed,
    Object? updatedById = freezed,
  }) {
    return _then(
      FlagMessageDetailsResponse(
        pinChanged: freezed == pinChanged
            ? _self.pinChanged
            : pinChanged // ignore: cast_nullable_to_non_nullable
                  as bool?,
        shouldEnrich: freezed == shouldEnrich
            ? _self.shouldEnrich
            : shouldEnrich // ignore: cast_nullable_to_non_nullable
                  as bool?,
        skipPush: freezed == skipPush
            ? _self.skipPush
            : skipPush // ignore: cast_nullable_to_non_nullable
                  as bool?,
        updatedById: freezed == updatedById
            ? _self.updatedById
            : updatedById // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
