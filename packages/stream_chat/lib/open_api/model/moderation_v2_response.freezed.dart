// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation_v2_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModerationV2Response {
  String get action;
  String? get blocklistMatched;
  List<String>? get blocklistsMatched;
  List<String>? get imageHarms;
  String get originalText;
  bool? get platformCircumvented;
  String? get semanticFilterMatched;
  List<String>? get textHarms;

  /// Create a copy of ModerationV2Response
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModerationV2ResponseCopyWith<ModerationV2Response> get copyWith =>
      _$ModerationV2ResponseCopyWithImpl<ModerationV2Response>(
        this as ModerationV2Response,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModerationV2Response &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.blocklistMatched, blocklistMatched) ||
                other.blocklistMatched == blocklistMatched) &&
            const DeepCollectionEquality().equals(
              other.blocklistsMatched,
              blocklistsMatched,
            ) &&
            const DeepCollectionEquality().equals(
              other.imageHarms,
              imageHarms,
            ) &&
            (identical(other.originalText, originalText) ||
                other.originalText == originalText) &&
            (identical(other.platformCircumvented, platformCircumvented) ||
                other.platformCircumvented == platformCircumvented) &&
            (identical(other.semanticFilterMatched, semanticFilterMatched) ||
                other.semanticFilterMatched == semanticFilterMatched) &&
            const DeepCollectionEquality().equals(other.textHarms, textHarms));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    action,
    blocklistMatched,
    const DeepCollectionEquality().hash(blocklistsMatched),
    const DeepCollectionEquality().hash(imageHarms),
    originalText,
    platformCircumvented,
    semanticFilterMatched,
    const DeepCollectionEquality().hash(textHarms),
  );

  @override
  String toString() {
    return 'ModerationV2Response(action: $action, blocklistMatched: $blocklistMatched, blocklistsMatched: $blocklistsMatched, imageHarms: $imageHarms, originalText: $originalText, platformCircumvented: $platformCircumvented, semanticFilterMatched: $semanticFilterMatched, textHarms: $textHarms)';
  }
}

/// @nodoc
abstract mixin class $ModerationV2ResponseCopyWith<$Res> {
  factory $ModerationV2ResponseCopyWith(
    ModerationV2Response value,
    $Res Function(ModerationV2Response) _then,
  ) = _$ModerationV2ResponseCopyWithImpl;
  @useResult
  $Res call({
    String action,
    String? blocklistMatched,
    List<String>? blocklistsMatched,
    List<String>? imageHarms,
    String originalText,
    bool? platformCircumvented,
    String? semanticFilterMatched,
    List<String>? textHarms,
  });
}

/// @nodoc
class _$ModerationV2ResponseCopyWithImpl<$Res>
    implements $ModerationV2ResponseCopyWith<$Res> {
  _$ModerationV2ResponseCopyWithImpl(this._self, this._then);

  final ModerationV2Response _self;
  final $Res Function(ModerationV2Response) _then;

  /// Create a copy of ModerationV2Response
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? blocklistMatched = freezed,
    Object? blocklistsMatched = freezed,
    Object? imageHarms = freezed,
    Object? originalText = null,
    Object? platformCircumvented = freezed,
    Object? semanticFilterMatched = freezed,
    Object? textHarms = freezed,
  }) {
    return _then(
      ModerationV2Response(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        blocklistMatched: freezed == blocklistMatched
            ? _self.blocklistMatched
            : blocklistMatched // ignore: cast_nullable_to_non_nullable
                  as String?,
        blocklistsMatched: freezed == blocklistsMatched
            ? _self.blocklistsMatched
            : blocklistsMatched // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        imageHarms: freezed == imageHarms
            ? _self.imageHarms
            : imageHarms // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        originalText: null == originalText
            ? _self.originalText
            : originalText // ignore: cast_nullable_to_non_nullable
                  as String,
        platformCircumvented: freezed == platformCircumvented
            ? _self.platformCircumvented
            : platformCircumvented // ignore: cast_nullable_to_non_nullable
                  as bool?,
        semanticFilterMatched: freezed == semanticFilterMatched
            ? _self.semanticFilterMatched
            : semanticFilterMatched // ignore: cast_nullable_to_non_nullable
                  as String?,
        textHarms: freezed == textHarms
            ? _self.textHarms
            : textHarms // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}
