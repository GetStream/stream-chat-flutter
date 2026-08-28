// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_block_list_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateBlockListRequest {
  bool? get isConfusableFoldingEnabled;
  bool? get isLeetCheckEnabled;
  bool? get isPluralCheckEnabled;
  bool? get isSubstringMatchingEnabled;
  String? get team;
  List<String>? get words;

  /// Create a copy of UpdateBlockListRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateBlockListRequestCopyWith<UpdateBlockListRequest> get copyWith =>
      _$UpdateBlockListRequestCopyWithImpl<UpdateBlockListRequest>(
        this as UpdateBlockListRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateBlockListRequest &&
            (identical(
                  other.isConfusableFoldingEnabled,
                  isConfusableFoldingEnabled,
                ) ||
                other.isConfusableFoldingEnabled ==
                    isConfusableFoldingEnabled) &&
            (identical(other.isLeetCheckEnabled, isLeetCheckEnabled) ||
                other.isLeetCheckEnabled == isLeetCheckEnabled) &&
            (identical(other.isPluralCheckEnabled, isPluralCheckEnabled) ||
                other.isPluralCheckEnabled == isPluralCheckEnabled) &&
            (identical(
                  other.isSubstringMatchingEnabled,
                  isSubstringMatchingEnabled,
                ) ||
                other.isSubstringMatchingEnabled ==
                    isSubstringMatchingEnabled) &&
            (identical(other.team, team) || other.team == team) &&
            const DeepCollectionEquality().equals(other.words, words));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isConfusableFoldingEnabled,
    isLeetCheckEnabled,
    isPluralCheckEnabled,
    isSubstringMatchingEnabled,
    team,
    const DeepCollectionEquality().hash(words),
  );

  @override
  String toString() {
    return 'UpdateBlockListRequest(isConfusableFoldingEnabled: $isConfusableFoldingEnabled, isLeetCheckEnabled: $isLeetCheckEnabled, isPluralCheckEnabled: $isPluralCheckEnabled, isSubstringMatchingEnabled: $isSubstringMatchingEnabled, team: $team, words: $words)';
  }
}

/// @nodoc
abstract mixin class $UpdateBlockListRequestCopyWith<$Res> {
  factory $UpdateBlockListRequestCopyWith(
    UpdateBlockListRequest value,
    $Res Function(UpdateBlockListRequest) _then,
  ) = _$UpdateBlockListRequestCopyWithImpl;
  @useResult
  $Res call({
    bool? isConfusableFoldingEnabled,
    bool? isLeetCheckEnabled,
    bool? isPluralCheckEnabled,
    bool? isSubstringMatchingEnabled,
    String? team,
    List<String>? words,
  });
}

/// @nodoc
class _$UpdateBlockListRequestCopyWithImpl<$Res>
    implements $UpdateBlockListRequestCopyWith<$Res> {
  _$UpdateBlockListRequestCopyWithImpl(this._self, this._then);

  final UpdateBlockListRequest _self;
  final $Res Function(UpdateBlockListRequest) _then;

  /// Create a copy of UpdateBlockListRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isConfusableFoldingEnabled = freezed,
    Object? isLeetCheckEnabled = freezed,
    Object? isPluralCheckEnabled = freezed,
    Object? isSubstringMatchingEnabled = freezed,
    Object? team = freezed,
    Object? words = freezed,
  }) {
    return _then(
      UpdateBlockListRequest(
        isConfusableFoldingEnabled: freezed == isConfusableFoldingEnabled
            ? _self.isConfusableFoldingEnabled
            : isConfusableFoldingEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isLeetCheckEnabled: freezed == isLeetCheckEnabled
            ? _self.isLeetCheckEnabled
            : isLeetCheckEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isPluralCheckEnabled: freezed == isPluralCheckEnabled
            ? _self.isPluralCheckEnabled
            : isPluralCheckEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isSubstringMatchingEnabled: freezed == isSubstringMatchingEnabled
            ? _self.isSubstringMatchingEnabled
            : isSubstringMatchingEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        words: freezed == words
            ? _self.words
            : words // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}
