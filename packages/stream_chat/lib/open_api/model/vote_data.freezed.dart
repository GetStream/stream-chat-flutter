// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vote_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VoteData {
  String? get answerText;
  String? get optionId;

  /// Create a copy of VoteData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VoteDataCopyWith<VoteData> get copyWith => _$VoteDataCopyWithImpl<VoteData>(this as VoteData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VoteData &&
            (identical(other.answerText, answerText) || other.answerText == answerText) &&
            (identical(other.optionId, optionId) || other.optionId == optionId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, answerText, optionId);

  @override
  String toString() {
    return 'VoteData(answerText: $answerText, optionId: $optionId)';
  }
}

/// @nodoc
abstract mixin class $VoteDataCopyWith<$Res> {
  factory $VoteDataCopyWith(VoteData value, $Res Function(VoteData) _then) = _$VoteDataCopyWithImpl;
  @useResult
  $Res call({String? answerText, String? optionId});
}

/// @nodoc
class _$VoteDataCopyWithImpl<$Res> implements $VoteDataCopyWith<$Res> {
  _$VoteDataCopyWithImpl(this._self, this._then);

  final VoteData _self;
  final $Res Function(VoteData) _then;

  /// Create a copy of VoteData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? answerText = freezed, Object? optionId = freezed}) {
    return _then(
      VoteData(
        answerText: freezed == answerText
            ? _self.answerText
            : answerText // ignore: cast_nullable_to_non_nullable
                  as String?,
        optionId: freezed == optionId
            ? _self.optionId
            : optionId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
