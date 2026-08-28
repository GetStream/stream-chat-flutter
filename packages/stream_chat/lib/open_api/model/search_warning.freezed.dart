// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_warning.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchWarning {
  List<String>? get channelSearchCids;
  int? get channelSearchCount;
  int get warningCode;
  String get warningDescription;

  /// Create a copy of SearchWarning
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchWarningCopyWith<SearchWarning> get copyWith => _$SearchWarningCopyWithImpl<SearchWarning>(
    this as SearchWarning,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchWarning &&
            const DeepCollectionEquality().equals(
              other.channelSearchCids,
              channelSearchCids,
            ) &&
            (identical(other.channelSearchCount, channelSearchCount) ||
                other.channelSearchCount == channelSearchCount) &&
            (identical(other.warningCode, warningCode) || other.warningCode == warningCode) &&
            (identical(other.warningDescription, warningDescription) ||
                other.warningDescription == warningDescription));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channelSearchCids),
    channelSearchCount,
    warningCode,
    warningDescription,
  );

  @override
  String toString() {
    return 'SearchWarning(channelSearchCids: $channelSearchCids, channelSearchCount: $channelSearchCount, warningCode: $warningCode, warningDescription: $warningDescription)';
  }
}

/// @nodoc
abstract mixin class $SearchWarningCopyWith<$Res> {
  factory $SearchWarningCopyWith(
    SearchWarning value,
    $Res Function(SearchWarning) _then,
  ) = _$SearchWarningCopyWithImpl;
  @useResult
  $Res call({
    List<String>? channelSearchCids,
    int? channelSearchCount,
    int warningCode,
    String warningDescription,
  });
}

/// @nodoc
class _$SearchWarningCopyWithImpl<$Res> implements $SearchWarningCopyWith<$Res> {
  _$SearchWarningCopyWithImpl(this._self, this._then);

  final SearchWarning _self;
  final $Res Function(SearchWarning) _then;

  /// Create a copy of SearchWarning
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelSearchCids = freezed,
    Object? channelSearchCount = freezed,
    Object? warningCode = null,
    Object? warningDescription = null,
  }) {
    return _then(
      SearchWarning(
        channelSearchCids: freezed == channelSearchCids
            ? _self.channelSearchCids
            : channelSearchCids // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        channelSearchCount: freezed == channelSearchCount
            ? _self.channelSearchCount
            : channelSearchCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        warningCode: null == warningCode
            ? _self.warningCode
            : warningCode // ignore: cast_nullable_to_non_nullable
                  as int,
        warningDescription: null == warningDescription
            ? _self.warningDescription
            : warningDescription // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
