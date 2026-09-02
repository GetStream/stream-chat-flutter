// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_reaction_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendReactionRequest {
  bool? get enforceUnique;
  ReactionRequest get reaction;
  bool? get skipPush;

  /// Create a copy of SendReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SendReactionRequestCopyWith<SendReactionRequest> get copyWith =>
      _$SendReactionRequestCopyWithImpl<SendReactionRequest>(
        this as SendReactionRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SendReactionRequest &&
            (identical(other.enforceUnique, enforceUnique) || other.enforceUnique == enforceUnique) &&
            (identical(other.reaction, reaction) || other.reaction == reaction) &&
            (identical(other.skipPush, skipPush) || other.skipPush == skipPush));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enforceUnique, reaction, skipPush);

  @override
  String toString() {
    return 'SendReactionRequest(enforceUnique: $enforceUnique, reaction: $reaction, skipPush: $skipPush)';
  }
}

/// @nodoc
abstract mixin class $SendReactionRequestCopyWith<$Res> {
  factory $SendReactionRequestCopyWith(
    SendReactionRequest value,
    $Res Function(SendReactionRequest) _then,
  ) = _$SendReactionRequestCopyWithImpl;
  @useResult
  $Res call({bool? enforceUnique, ReactionRequest reaction, bool? skipPush});
}

/// @nodoc
class _$SendReactionRequestCopyWithImpl<$Res> implements $SendReactionRequestCopyWith<$Res> {
  _$SendReactionRequestCopyWithImpl(this._self, this._then);

  final SendReactionRequest _self;
  final $Res Function(SendReactionRequest) _then;

  /// Create a copy of SendReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enforceUnique = freezed,
    Object? reaction = null,
    Object? skipPush = freezed,
  }) {
    return _then(
      SendReactionRequest(
        enforceUnique: freezed == enforceUnique
            ? _self.enforceUnique
            : enforceUnique // ignore: cast_nullable_to_non_nullable
                  as bool?,
        reaction: null == reaction
            ? _self.reaction
            : reaction // ignore: cast_nullable_to_non_nullable
                  as ReactionRequest,
        skipPush: freezed == skipPush
            ? _self.skipPush
            : skipPush // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
