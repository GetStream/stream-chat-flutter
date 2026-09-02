// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageOptions {
  bool? get includeThreadParticipants;
  List<String>? get memberCustomInclude;

  /// Create a copy of MessageOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageOptionsCopyWith<MessageOptions> get copyWith => _$MessageOptionsCopyWithImpl<MessageOptions>(
    this as MessageOptions,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageOptions &&
            (identical(
                  other.includeThreadParticipants,
                  includeThreadParticipants,
                ) ||
                other.includeThreadParticipants == includeThreadParticipants) &&
            const DeepCollectionEquality().equals(
              other.memberCustomInclude,
              memberCustomInclude,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    includeThreadParticipants,
    const DeepCollectionEquality().hash(memberCustomInclude),
  );

  @override
  String toString() {
    return 'MessageOptions(includeThreadParticipants: $includeThreadParticipants, memberCustomInclude: $memberCustomInclude)';
  }
}

/// @nodoc
abstract mixin class $MessageOptionsCopyWith<$Res> {
  factory $MessageOptionsCopyWith(
    MessageOptions value,
    $Res Function(MessageOptions) _then,
  ) = _$MessageOptionsCopyWithImpl;
  @useResult
  $Res call({
    bool? includeThreadParticipants,
    List<String>? memberCustomInclude,
  });
}

/// @nodoc
class _$MessageOptionsCopyWithImpl<$Res> implements $MessageOptionsCopyWith<$Res> {
  _$MessageOptionsCopyWithImpl(this._self, this._then);

  final MessageOptions _self;
  final $Res Function(MessageOptions) _then;

  /// Create a copy of MessageOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? includeThreadParticipants = freezed,
    Object? memberCustomInclude = freezed,
  }) {
    return _then(
      MessageOptions(
        includeThreadParticipants: freezed == includeThreadParticipants
            ? _self.includeThreadParticipants
            : includeThreadParticipants // ignore: cast_nullable_to_non_nullable
                  as bool?,
        memberCustomInclude: freezed == memberCustomInclude
            ? _self.memberCustomInclude
            : memberCustomInclude // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}
