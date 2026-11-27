// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_channels_defaults.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryChannelsDefaults {
  int get limit;
  int get maxLimit;
  int get memberLimit;
  int get messageLimit;

  /// Create a copy of QueryChannelsDefaults
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryChannelsDefaultsCopyWith<QueryChannelsDefaults> get copyWith =>
      _$QueryChannelsDefaultsCopyWithImpl<QueryChannelsDefaults>(
        this as QueryChannelsDefaults,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryChannelsDefaults &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.maxLimit, maxLimit) || other.maxLimit == maxLimit) &&
            (identical(other.memberLimit, memberLimit) || other.memberLimit == memberLimit) &&
            (identical(other.messageLimit, messageLimit) || other.messageLimit == messageLimit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, limit, maxLimit, memberLimit, messageLimit);

  @override
  String toString() {
    return 'QueryChannelsDefaults(limit: $limit, maxLimit: $maxLimit, memberLimit: $memberLimit, messageLimit: $messageLimit)';
  }
}

/// @nodoc
abstract mixin class $QueryChannelsDefaultsCopyWith<$Res> {
  factory $QueryChannelsDefaultsCopyWith(
    QueryChannelsDefaults value,
    $Res Function(QueryChannelsDefaults) _then,
  ) = _$QueryChannelsDefaultsCopyWithImpl;
  @useResult
  $Res call({int limit, int maxLimit, int memberLimit, int messageLimit});
}

/// @nodoc
class _$QueryChannelsDefaultsCopyWithImpl<$Res> implements $QueryChannelsDefaultsCopyWith<$Res> {
  _$QueryChannelsDefaultsCopyWithImpl(this._self, this._then);

  final QueryChannelsDefaults _self;
  final $Res Function(QueryChannelsDefaults) _then;

  /// Create a copy of QueryChannelsDefaults
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? limit = null,
    Object? maxLimit = null,
    Object? memberLimit = null,
    Object? messageLimit = null,
  }) {
    return _then(
      QueryChannelsDefaults(
        limit: null == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        maxLimit: null == maxLimit
            ? _self.maxLimit
            : maxLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        memberLimit: null == memberLimit
            ? _self.memberLimit
            : memberLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        messageLimit: null == messageLimit
            ? _self.messageLimit
            : messageLimit // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
