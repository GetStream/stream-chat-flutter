// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Moderation {
  ModerationAction get action;
  String get originalText;
  List<String>? get textHarms;
  List<String>? get imageHarms;
  String? get blocklistMatched;
  String? get semanticFilterMatched;
  bool get platformCircumvented;

  /// Create a copy of Moderation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModerationCopyWith<Moderation> get copyWith => _$ModerationCopyWithImpl<Moderation>(this as Moderation, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Moderation &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.originalText, originalText) || other.originalText == originalText) &&
            const DeepCollectionEquality().equals(other.textHarms, textHarms) &&
            const DeepCollectionEquality().equals(other.imageHarms, imageHarms) &&
            (identical(other.blocklistMatched, blocklistMatched) || other.blocklistMatched == blocklistMatched) &&
            (identical(other.semanticFilterMatched, semanticFilterMatched) ||
                other.semanticFilterMatched == semanticFilterMatched) &&
            (identical(other.platformCircumvented, platformCircumvented) ||
                other.platformCircumvented == platformCircumvented));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    action,
    originalText,
    const DeepCollectionEquality().hash(textHarms),
    const DeepCollectionEquality().hash(imageHarms),
    blocklistMatched,
    semanticFilterMatched,
    platformCircumvented,
  );

  @override
  String toString() {
    return 'Moderation(action: $action, originalText: $originalText, textHarms: $textHarms, imageHarms: $imageHarms, blocklistMatched: $blocklistMatched, semanticFilterMatched: $semanticFilterMatched, platformCircumvented: $platformCircumvented)';
  }
}

/// @nodoc
abstract mixin class $ModerationCopyWith<$Res> {
  factory $ModerationCopyWith(Moderation value, $Res Function(Moderation) _then) = _$ModerationCopyWithImpl;
  @useResult
  $Res call({
    ModerationAction action,
    String originalText,
    List<String>? textHarms,
    List<String>? imageHarms,
    String? blocklistMatched,
    String? semanticFilterMatched,
    bool platformCircumvented,
  });
}

/// @nodoc
class _$ModerationCopyWithImpl<$Res> implements $ModerationCopyWith<$Res> {
  _$ModerationCopyWithImpl(this._self, this._then);

  final Moderation _self;
  final $Res Function(Moderation) _then;

  /// Create a copy of Moderation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? originalText = null,
    Object? textHarms = freezed,
    Object? imageHarms = freezed,
    Object? blocklistMatched = freezed,
    Object? semanticFilterMatched = freezed,
    Object? platformCircumvented = null,
  }) {
    return _then(
      Moderation(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as ModerationAction,
        originalText: null == originalText
            ? _self.originalText
            : originalText // ignore: cast_nullable_to_non_nullable
                  as String,
        textHarms: freezed == textHarms
            ? _self.textHarms
            : textHarms // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        imageHarms: freezed == imageHarms
            ? _self.imageHarms
            : imageHarms // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        blocklistMatched: freezed == blocklistMatched
            ? _self.blocklistMatched
            : blocklistMatched // ignore: cast_nullable_to_non_nullable
                  as String?,
        semanticFilterMatched: freezed == semanticFilterMatched
            ? _self.semanticFilterMatched
            : semanticFilterMatched // ignore: cast_nullable_to_non_nullable
                  as String?,
        platformCircumvented: null == platformCircumvented
            ? _self.platformCircumvented
            : platformCircumvented // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
