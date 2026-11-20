// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_or_create_channel_defaults.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetOrCreateChannelDefaults {
  PagerDefaults get members;
  PagerDefaults get messages;

  /// Create a copy of GetOrCreateChannelDefaults
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GetOrCreateChannelDefaultsCopyWith<GetOrCreateChannelDefaults> get copyWith =>
      _$GetOrCreateChannelDefaultsCopyWithImpl<GetOrCreateChannelDefaults>(
        this as GetOrCreateChannelDefaults,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GetOrCreateChannelDefaults &&
            (identical(other.members, members) || other.members == members) &&
            (identical(other.messages, messages) || other.messages == messages));
  }

  @override
  int get hashCode => Object.hash(runtimeType, members, messages);

  @override
  String toString() {
    return 'GetOrCreateChannelDefaults(members: $members, messages: $messages)';
  }
}

/// @nodoc
abstract mixin class $GetOrCreateChannelDefaultsCopyWith<$Res> {
  factory $GetOrCreateChannelDefaultsCopyWith(
    GetOrCreateChannelDefaults value,
    $Res Function(GetOrCreateChannelDefaults) _then,
  ) = _$GetOrCreateChannelDefaultsCopyWithImpl;
  @useResult
  $Res call({PagerDefaults members, PagerDefaults messages});
}

/// @nodoc
class _$GetOrCreateChannelDefaultsCopyWithImpl<$Res> implements $GetOrCreateChannelDefaultsCopyWith<$Res> {
  _$GetOrCreateChannelDefaultsCopyWithImpl(this._self, this._then);

  final GetOrCreateChannelDefaults _self;
  final $Res Function(GetOrCreateChannelDefaults) _then;

  /// Create a copy of GetOrCreateChannelDefaults
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? members = null, Object? messages = null}) {
    return _then(
      GetOrCreateChannelDefaults(
        members: null == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as PagerDefaults,
        messages: null == messages
            ? _self.messages
            : messages // ignore: cast_nullable_to_non_nullable
                  as PagerDefaults,
      ),
    );
  }
}
