// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll_voting_mode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollVotingMode {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PollVotingMode);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PollVotingMode()';
  }
}

/// @nodoc
class $PollVotingModeCopyWith<$Res> {
  $PollVotingModeCopyWith(PollVotingMode _, $Res Function(PollVotingMode) __);
}

/// @nodoc

class VotingDisabled implements PollVotingMode {
  const VotingDisabled();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is VotingDisabled);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PollVotingMode.disabled()';
  }
}

/// @nodoc

class VotingUnique implements PollVotingMode {
  const VotingUnique();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is VotingUnique);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PollVotingMode.unique()';
  }
}

/// @nodoc

class VotingLimited implements PollVotingMode {
  const VotingLimited({required this.count});

  final int count;

  /// Create a copy of PollVotingMode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VotingLimitedCopyWith<VotingLimited> get copyWith =>
      _$VotingLimitedCopyWithImpl<VotingLimited>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VotingLimited &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count);

  @override
  String toString() {
    return 'PollVotingMode.limited(count: $count)';
  }
}

/// @nodoc
abstract mixin class $VotingLimitedCopyWith<$Res>
    implements $PollVotingModeCopyWith<$Res> {
  factory $VotingLimitedCopyWith(
          VotingLimited value, $Res Function(VotingLimited) _then) =
      _$VotingLimitedCopyWithImpl;
  @useResult
  $Res call({int count});
}

/// @nodoc
class _$VotingLimitedCopyWithImpl<$Res>
    implements $VotingLimitedCopyWith<$Res> {
  _$VotingLimitedCopyWithImpl(this._self, this._then);

  final VotingLimited _self;
  final $Res Function(VotingLimited) _then;

  /// Create a copy of PollVotingMode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? count = null,
  }) {
    return _then(VotingLimited(
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class VotingAll implements PollVotingMode {
  const VotingAll();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is VotingAll);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PollVotingMode.all()';
  }
}

// dart format on
