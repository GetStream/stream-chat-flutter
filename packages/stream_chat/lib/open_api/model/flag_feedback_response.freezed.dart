// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flag_feedback_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlagFeedbackResponse {
  DateTime get createdAt;
  List<LabelResponse> get labels;
  String get messageId;

  /// Create a copy of FlagFeedbackResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FlagFeedbackResponseCopyWith<FlagFeedbackResponse> get copyWith =>
      _$FlagFeedbackResponseCopyWithImpl<FlagFeedbackResponse>(
        this as FlagFeedbackResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FlagFeedbackResponse &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.labels, labels) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(labels),
    messageId,
  );

  @override
  String toString() {
    return 'FlagFeedbackResponse(createdAt: $createdAt, labels: $labels, messageId: $messageId)';
  }
}

/// @nodoc
abstract mixin class $FlagFeedbackResponseCopyWith<$Res> {
  factory $FlagFeedbackResponseCopyWith(
    FlagFeedbackResponse value,
    $Res Function(FlagFeedbackResponse) _then,
  ) = _$FlagFeedbackResponseCopyWithImpl;
  @useResult
  $Res call({DateTime createdAt, List<LabelResponse> labels, String messageId});
}

/// @nodoc
class _$FlagFeedbackResponseCopyWithImpl<$Res>
    implements $FlagFeedbackResponseCopyWith<$Res> {
  _$FlagFeedbackResponseCopyWithImpl(this._self, this._then);

  final FlagFeedbackResponse _self;
  final $Res Function(FlagFeedbackResponse) _then;

  /// Create a copy of FlagFeedbackResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? labels = null,
    Object? messageId = null,
  }) {
    return _then(
      FlagFeedbackResponse(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        labels: null == labels
            ? _self.labels
            : labels // ignore: cast_nullable_to_non_nullable
                  as List<LabelResponse>,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
