// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'automod_details_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AutomodDetailsResponse {
  String? get action;
  List<String>? get imageLabels;
  FlagMessageDetailsResponse? get messageDetails;
  String? get originalMessageType;
  MessageModerationResult? get result;

  /// Create a copy of AutomodDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AutomodDetailsResponseCopyWith<AutomodDetailsResponse> get copyWith =>
      _$AutomodDetailsResponseCopyWithImpl<AutomodDetailsResponse>(
        this as AutomodDetailsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AutomodDetailsResponse &&
            (identical(other.action, action) || other.action == action) &&
            const DeepCollectionEquality().equals(
              other.imageLabels,
              imageLabels,
            ) &&
            (identical(other.messageDetails, messageDetails) || other.messageDetails == messageDetails) &&
            (identical(other.originalMessageType, originalMessageType) ||
                other.originalMessageType == originalMessageType) &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    action,
    const DeepCollectionEquality().hash(imageLabels),
    messageDetails,
    originalMessageType,
    result,
  );

  @override
  String toString() {
    return 'AutomodDetailsResponse(action: $action, imageLabels: $imageLabels, messageDetails: $messageDetails, originalMessageType: $originalMessageType, result: $result)';
  }
}

/// @nodoc
abstract mixin class $AutomodDetailsResponseCopyWith<$Res> {
  factory $AutomodDetailsResponseCopyWith(
    AutomodDetailsResponse value,
    $Res Function(AutomodDetailsResponse) _then,
  ) = _$AutomodDetailsResponseCopyWithImpl;
  @useResult
  $Res call({
    String? action,
    List<String>? imageLabels,
    FlagMessageDetailsResponse? messageDetails,
    String? originalMessageType,
    MessageModerationResult? result,
  });
}

/// @nodoc
class _$AutomodDetailsResponseCopyWithImpl<$Res> implements $AutomodDetailsResponseCopyWith<$Res> {
  _$AutomodDetailsResponseCopyWithImpl(this._self, this._then);

  final AutomodDetailsResponse _self;
  final $Res Function(AutomodDetailsResponse) _then;

  /// Create a copy of AutomodDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = freezed,
    Object? imageLabels = freezed,
    Object? messageDetails = freezed,
    Object? originalMessageType = freezed,
    Object? result = freezed,
  }) {
    return _then(
      AutomodDetailsResponse(
        action: freezed == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageLabels: freezed == imageLabels
            ? _self.imageLabels
            : imageLabels // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        messageDetails: freezed == messageDetails
            ? _self.messageDetails
            : messageDetails // ignore: cast_nullable_to_non_nullable
                  as FlagMessageDetailsResponse?,
        originalMessageType: freezed == originalMessageType
            ? _self.originalMessageType
            : originalMessageType // ignore: cast_nullable_to_non_nullable
                  as String?,
        result: freezed == result
            ? _self.result
            : result // ignore: cast_nullable_to_non_nullable
                  as MessageModerationResult?,
      ),
    );
  }
}
