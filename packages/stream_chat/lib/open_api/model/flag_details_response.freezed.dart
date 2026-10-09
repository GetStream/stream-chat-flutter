// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flag_details_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlagDetailsResponse {
  AutomodDetailsResponse? get automod;
  Map<String, Object?>? get extra;
  String get originalText;

  /// Create a copy of FlagDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FlagDetailsResponseCopyWith<FlagDetailsResponse> get copyWith =>
      _$FlagDetailsResponseCopyWithImpl<FlagDetailsResponse>(
        this as FlagDetailsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FlagDetailsResponse &&
            (identical(other.automod, automod) || other.automod == automod) &&
            const DeepCollectionEquality().equals(other.extra, extra) &&
            (identical(other.originalText, originalText) || other.originalText == originalText));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    automod,
    const DeepCollectionEquality().hash(extra),
    originalText,
  );

  @override
  String toString() {
    return 'FlagDetailsResponse(automod: $automod, extra: $extra, originalText: $originalText)';
  }
}

/// @nodoc
abstract mixin class $FlagDetailsResponseCopyWith<$Res> {
  factory $FlagDetailsResponseCopyWith(
    FlagDetailsResponse value,
    $Res Function(FlagDetailsResponse) _then,
  ) = _$FlagDetailsResponseCopyWithImpl;
  @useResult
  $Res call({
    AutomodDetailsResponse? automod,
    Map<String, Object?>? extra,
    String originalText,
  });
}

/// @nodoc
class _$FlagDetailsResponseCopyWithImpl<$Res> implements $FlagDetailsResponseCopyWith<$Res> {
  _$FlagDetailsResponseCopyWithImpl(this._self, this._then);

  final FlagDetailsResponse _self;
  final $Res Function(FlagDetailsResponse) _then;

  /// Create a copy of FlagDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? automod = freezed,
    Object? extra = freezed,
    Object? originalText = null,
  }) {
    return _then(
      FlagDetailsResponse(
        automod: freezed == automod
            ? _self.automod
            : automod // ignore: cast_nullable_to_non_nullable
                  as AutomodDetailsResponse?,
        extra: freezed == extra
            ? _self.extra
            : extra // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        originalText: null == originalText
            ? _self.originalText
            : originalText // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
