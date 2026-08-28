// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_reaction_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendReactionResponse {
  String get duration;
  MessageResponse get message;
  ReactionResponse get reaction;

  /// Create a copy of SendReactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SendReactionResponseCopyWith<SendReactionResponse> get copyWith =>
      _$SendReactionResponseCopyWithImpl<SendReactionResponse>(
        this as SendReactionResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SendReactionResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.reaction, reaction) ||
                other.reaction == reaction));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, message, reaction);

  @override
  String toString() {
    return 'SendReactionResponse(duration: $duration, message: $message, reaction: $reaction)';
  }
}

/// @nodoc
abstract mixin class $SendReactionResponseCopyWith<$Res> {
  factory $SendReactionResponseCopyWith(
    SendReactionResponse value,
    $Res Function(SendReactionResponse) _then,
  ) = _$SendReactionResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    MessageResponse message,
    ReactionResponse reaction,
  });
}

/// @nodoc
class _$SendReactionResponseCopyWithImpl<$Res>
    implements $SendReactionResponseCopyWith<$Res> {
  _$SendReactionResponseCopyWithImpl(this._self, this._then);

  final SendReactionResponse _self;
  final $Res Function(SendReactionResponse) _then;

  /// Create a copy of SendReactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? message = null,
    Object? reaction = null,
  }) {
    return _then(
      SendReactionResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse,
        reaction: null == reaction
            ? _self.reaction
            : reaction // ignore: cast_nullable_to_non_nullable
                  as ReactionResponse,
      ),
    );
  }
}
