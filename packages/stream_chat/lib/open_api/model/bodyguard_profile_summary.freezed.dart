// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bodyguard_profile_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BodyguardProfileSummary {
  String? get displayName;
  String get name;
  String? get textType;

  /// Create a copy of BodyguardProfileSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BodyguardProfileSummaryCopyWith<BodyguardProfileSummary> get copyWith =>
      _$BodyguardProfileSummaryCopyWithImpl<BodyguardProfileSummary>(
        this as BodyguardProfileSummary,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BodyguardProfileSummary &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.textType, textType) ||
                other.textType == textType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, displayName, name, textType);

  @override
  String toString() {
    return 'BodyguardProfileSummary(displayName: $displayName, name: $name, textType: $textType)';
  }
}

/// @nodoc
abstract mixin class $BodyguardProfileSummaryCopyWith<$Res> {
  factory $BodyguardProfileSummaryCopyWith(
    BodyguardProfileSummary value,
    $Res Function(BodyguardProfileSummary) _then,
  ) = _$BodyguardProfileSummaryCopyWithImpl;
  @useResult
  $Res call({String? displayName, String name, String? textType});
}

/// @nodoc
class _$BodyguardProfileSummaryCopyWithImpl<$Res>
    implements $BodyguardProfileSummaryCopyWith<$Res> {
  _$BodyguardProfileSummaryCopyWithImpl(this._self, this._then);

  final BodyguardProfileSummary _self;
  final $Res Function(BodyguardProfileSummary) _then;

  /// Create a copy of BodyguardProfileSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = freezed,
    Object? name = null,
    Object? textType = freezed,
  }) {
    return _then(
      BodyguardProfileSummary(
        displayName: freezed == displayName
            ? _self.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        textType: freezed == textType
            ? _self.textType
            : textType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
