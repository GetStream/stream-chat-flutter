// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_message_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchMessageResult {
  Message get message;
  ChannelModel? get channel;

  /// Create a copy of SearchMessageResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchMessageResultCopyWith<SearchMessageResult> get copyWith =>
      _$SearchMessageResultCopyWithImpl<SearchMessageResult>(this as SearchMessageResult, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchMessageResult &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.channel, channel) || other.channel == channel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, channel);

  @override
  String toString() {
    return 'SearchMessageResult(message: $message, channel: $channel)';
  }
}

/// @nodoc
abstract mixin class $SearchMessageResultCopyWith<$Res> {
  factory $SearchMessageResultCopyWith(SearchMessageResult value, $Res Function(SearchMessageResult) _then) =
      _$SearchMessageResultCopyWithImpl;
  @useResult
  $Res call({Message message, ChannelModel? channel});
}

/// @nodoc
class _$SearchMessageResultCopyWithImpl<$Res> implements $SearchMessageResultCopyWith<$Res> {
  _$SearchMessageResultCopyWithImpl(this._self, this._then);

  final SearchMessageResult _self;
  final $Res Function(SearchMessageResult) _then;

  /// Create a copy of SearchMessageResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? channel = freezed}) {
    return _then(
      SearchMessageResult(
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as Message,
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelModel?,
      ),
    );
  }
}
