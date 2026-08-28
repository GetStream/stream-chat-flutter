// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModerationResponse {
  String get action;
  double get explicit;
  double get spam;
  double get toxic;

  /// Create a copy of ModerationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModerationResponseCopyWith<ModerationResponse> get copyWith =>
      _$ModerationResponseCopyWithImpl<ModerationResponse>(
        this as ModerationResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModerationResponse &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.explicit, explicit) ||
                other.explicit == explicit) &&
            (identical(other.spam, spam) || other.spam == spam) &&
            (identical(other.toxic, toxic) || other.toxic == toxic));
  }

  @override
  int get hashCode => Object.hash(runtimeType, action, explicit, spam, toxic);

  @override
  String toString() {
    return 'ModerationResponse(action: $action, explicit: $explicit, spam: $spam, toxic: $toxic)';
  }
}

/// @nodoc
abstract mixin class $ModerationResponseCopyWith<$Res> {
  factory $ModerationResponseCopyWith(
    ModerationResponse value,
    $Res Function(ModerationResponse) _then,
  ) = _$ModerationResponseCopyWithImpl;
  @useResult
  $Res call({String action, double explicit, double spam, double toxic});
}

/// @nodoc
class _$ModerationResponseCopyWithImpl<$Res>
    implements $ModerationResponseCopyWith<$Res> {
  _$ModerationResponseCopyWithImpl(this._self, this._then);

  final ModerationResponse _self;
  final $Res Function(ModerationResponse) _then;

  /// Create a copy of ModerationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? explicit = null,
    Object? spam = null,
    Object? toxic = null,
  }) {
    return _then(
      ModerationResponse(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        explicit: null == explicit
            ? _self.explicit
            : explicit // ignore: cast_nullable_to_non_nullable
                  as double,
        spam: null == spam
            ? _self.spam
            : spam // ignore: cast_nullable_to_non_nullable
                  as double,
        toxic: null == toxic
            ? _self.toxic
            : toxic // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}
