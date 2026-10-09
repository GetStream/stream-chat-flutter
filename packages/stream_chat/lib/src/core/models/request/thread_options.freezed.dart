// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thread_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThreadOptions {
  bool get watch;
  int get replyLimit;
  int get participantLimit;
  int get memberLimit;

  /// Create a copy of ThreadOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThreadOptionsCopyWith<ThreadOptions> get copyWith =>
      _$ThreadOptionsCopyWithImpl<ThreadOptions>(this as ThreadOptions, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThreadOptions &&
            (identical(other.watch, watch) || other.watch == watch) &&
            (identical(other.replyLimit, replyLimit) || other.replyLimit == replyLimit) &&
            (identical(other.participantLimit, participantLimit) || other.participantLimit == participantLimit) &&
            (identical(other.memberLimit, memberLimit) || other.memberLimit == memberLimit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, watch, replyLimit, participantLimit, memberLimit);

  @override
  String toString() {
    return 'ThreadOptions(watch: $watch, replyLimit: $replyLimit, participantLimit: $participantLimit, memberLimit: $memberLimit)';
  }
}

/// @nodoc
abstract mixin class $ThreadOptionsCopyWith<$Res> {
  factory $ThreadOptionsCopyWith(ThreadOptions value, $Res Function(ThreadOptions) _then) = _$ThreadOptionsCopyWithImpl;
  @useResult
  $Res call({bool watch, int replyLimit, int participantLimit, int memberLimit});
}

/// @nodoc
class _$ThreadOptionsCopyWithImpl<$Res> implements $ThreadOptionsCopyWith<$Res> {
  _$ThreadOptionsCopyWithImpl(this._self, this._then);

  final ThreadOptions _self;
  final $Res Function(ThreadOptions) _then;

  /// Create a copy of ThreadOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? watch = null,
    Object? replyLimit = null,
    Object? participantLimit = null,
    Object? memberLimit = null,
  }) {
    return _then(
      ThreadOptions(
        watch: null == watch
            ? _self.watch
            : watch // ignore: cast_nullable_to_non_nullable
                  as bool,
        replyLimit: null == replyLimit
            ? _self.replyLimit
            : replyLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        participantLimit: null == participantLimit
            ? _self.participantLimit
            : participantLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        memberLimit: null == memberLimit
            ? _self.memberLimit
            : memberLimit // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
