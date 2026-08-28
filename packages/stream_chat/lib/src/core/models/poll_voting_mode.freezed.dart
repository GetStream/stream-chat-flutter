// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll_voting_mode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollVotingMode {
  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is PollVotingMode);
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
    return identical(this, other) || (other.runtimeType == runtimeType && other is VotingDisabled);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PollVotingMode.disabled()';
  }
}

/// @nodoc
class $VotingDisabledCopyWith<$Res> implements $PollVotingModeCopyWith<$Res> {
  $VotingDisabledCopyWith(VotingDisabled _, $Res Function(VotingDisabled) __);
}

/// @nodoc
class _$VotingDisabledCopyWithImpl<$Res> implements $VotingDisabledCopyWith<$Res> {
  _$VotingDisabledCopyWithImpl(this._self, this._then);

  final VotingDisabled _self;
  final $Res Function(VotingDisabled) _then;
}

/// @nodoc

class VotingUnique implements PollVotingMode {
  const VotingUnique();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is VotingUnique);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PollVotingMode.unique()';
  }
}

/// @nodoc
class $VotingUniqueCopyWith<$Res> implements $PollVotingModeCopyWith<$Res> {
  $VotingUniqueCopyWith(VotingUnique _, $Res Function(VotingUnique) __);
}

/// @nodoc
class _$VotingUniqueCopyWithImpl<$Res> implements $VotingUniqueCopyWith<$Res> {
  _$VotingUniqueCopyWithImpl(this._self, this._then);

  final VotingUnique _self;
  final $Res Function(VotingUnique) _then;
}

/// @nodoc

class VotingLimited implements PollVotingMode {
  const VotingLimited({required this.count});

  final int count;

  /// Create a copy of PollVotingMode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VotingLimitedCopyWith<VotingLimited> get copyWith => _$VotingLimitedCopyWithImpl<VotingLimited>(this, _$identity);

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
abstract mixin class $VotingLimitedCopyWith<$Res> implements $PollVotingModeCopyWith<$Res> {
  factory $VotingLimitedCopyWith(
    VotingLimited value,
    $Res Function(VotingLimited) _then,
  ) = _$VotingLimitedCopyWithImpl;
  @useResult
  $Res call({int count});
}

/// @nodoc
class _$VotingLimitedCopyWithImpl<$Res> implements $VotingLimitedCopyWith<$Res> {
  _$VotingLimitedCopyWithImpl(this._self, this._then);

  final VotingLimited _self;
  final $Res Function(VotingLimited) _then;

  /// Create a copy of PollVotingMode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({Object? count = null}) {
    return _then(
      VotingLimited(
        count: null == count
            ? _self.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class VotingAll implements PollVotingMode {
  const VotingAll();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is VotingAll);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PollVotingMode.all()';
  }
}

/// @nodoc
class $VotingAllCopyWith<$Res> implements $PollVotingModeCopyWith<$Res> {
  $VotingAllCopyWith(VotingAll _, $Res Function(VotingAll) __);
}

/// @nodoc
class _$VotingAllCopyWithImpl<$Res> implements $VotingAllCopyWith<$Res> {
  _$VotingAllCopyWithImpl(this._self, this._then);

  final VotingAll _self;
  final $Res Function(VotingAll) _then;
}
