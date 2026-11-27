// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_block_list_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateBlockListRequest {
  bool? get isConfusableFoldingEnabled;
  bool? get isLeetCheckEnabled;
  bool? get isPluralCheckEnabled;
  bool? get isSubstringMatchingEnabled;
  String get name;
  String? get team;
  CreateBlockListRequestType? get type;
  List<String> get words;

  /// Create a copy of CreateBlockListRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateBlockListRequestCopyWith<CreateBlockListRequest> get copyWith =>
      _$CreateBlockListRequestCopyWithImpl<CreateBlockListRequest>(
        this as CreateBlockListRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateBlockListRequest &&
            (identical(
                  other.isConfusableFoldingEnabled,
                  isConfusableFoldingEnabled,
                ) ||
                other.isConfusableFoldingEnabled == isConfusableFoldingEnabled) &&
            (identical(other.isLeetCheckEnabled, isLeetCheckEnabled) ||
                other.isLeetCheckEnabled == isLeetCheckEnabled) &&
            (identical(other.isPluralCheckEnabled, isPluralCheckEnabled) ||
                other.isPluralCheckEnabled == isPluralCheckEnabled) &&
            (identical(
                  other.isSubstringMatchingEnabled,
                  isSubstringMatchingEnabled,
                ) ||
                other.isSubstringMatchingEnabled == isSubstringMatchingEnabled) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other.words, words));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isConfusableFoldingEnabled,
    isLeetCheckEnabled,
    isPluralCheckEnabled,
    isSubstringMatchingEnabled,
    name,
    team,
    type,
    const DeepCollectionEquality().hash(words),
  );

  @override
  String toString() {
    return 'CreateBlockListRequest(isConfusableFoldingEnabled: $isConfusableFoldingEnabled, isLeetCheckEnabled: $isLeetCheckEnabled, isPluralCheckEnabled: $isPluralCheckEnabled, isSubstringMatchingEnabled: $isSubstringMatchingEnabled, name: $name, team: $team, type: $type, words: $words)';
  }
}

/// @nodoc
abstract mixin class $CreateBlockListRequestCopyWith<$Res> {
  factory $CreateBlockListRequestCopyWith(
    CreateBlockListRequest value,
    $Res Function(CreateBlockListRequest) _then,
  ) = _$CreateBlockListRequestCopyWithImpl;
  @useResult
  $Res call({
    bool? isConfusableFoldingEnabled,
    bool? isLeetCheckEnabled,
    bool? isPluralCheckEnabled,
    bool? isSubstringMatchingEnabled,
    String name,
    String? team,
    CreateBlockListRequestType? type,
    List<String> words,
  });
}

/// @nodoc
class _$CreateBlockListRequestCopyWithImpl<$Res> implements $CreateBlockListRequestCopyWith<$Res> {
  _$CreateBlockListRequestCopyWithImpl(this._self, this._then);

  final CreateBlockListRequest _self;
  final $Res Function(CreateBlockListRequest) _then;

  /// Create a copy of CreateBlockListRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isConfusableFoldingEnabled = freezed,
    Object? isLeetCheckEnabled = freezed,
    Object? isPluralCheckEnabled = freezed,
    Object? isSubstringMatchingEnabled = freezed,
    Object? name = null,
    Object? team = freezed,
    Object? type = freezed,
    Object? words = null,
  }) {
    return _then(
      CreateBlockListRequest(
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
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as CreateBlockListRequestType?,
        words: null == words
            ? _self.words
            : words // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}
