// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_get_or_create_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelGetOrCreateRequest {
  ChannelInput? get data;
  bool? get hideForCreator;
  List<String>? get memberCustomInclude;
  PaginationParams? get members;
  MessagePaginationParams? get messages;
  bool? get presence;
  bool? get state;
  bool? get threadUnreadCounts;
  bool? get watch;
  PaginationParams? get watchers;

  /// Create a copy of ChannelGetOrCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelGetOrCreateRequestCopyWith<ChannelGetOrCreateRequest> get copyWith =>
      _$ChannelGetOrCreateRequestCopyWithImpl<ChannelGetOrCreateRequest>(
        this as ChannelGetOrCreateRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelGetOrCreateRequest &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.hideForCreator, hideForCreator) ||
                other.hideForCreator == hideForCreator) &&
            const DeepCollectionEquality().equals(
              other.memberCustomInclude,
              memberCustomInclude,
            ) &&
            (identical(other.members, members) || other.members == members) &&
            (identical(other.messages, messages) ||
                other.messages == messages) &&
            (identical(other.presence, presence) ||
                other.presence == presence) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.threadUnreadCounts, threadUnreadCounts) ||
                other.threadUnreadCounts == threadUnreadCounts) &&
            (identical(other.watch, watch) || other.watch == watch) &&
            (identical(other.watchers, watchers) ||
                other.watchers == watchers));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    data,
    hideForCreator,
    const DeepCollectionEquality().hash(memberCustomInclude),
    members,
    messages,
    presence,
    state,
    threadUnreadCounts,
    watch,
    watchers,
  );

  @override
  String toString() {
    return 'ChannelGetOrCreateRequest(data: $data, hideForCreator: $hideForCreator, memberCustomInclude: $memberCustomInclude, members: $members, messages: $messages, presence: $presence, state: $state, threadUnreadCounts: $threadUnreadCounts, watch: $watch, watchers: $watchers)';
  }
}

/// @nodoc
abstract mixin class $ChannelGetOrCreateRequestCopyWith<$Res> {
  factory $ChannelGetOrCreateRequestCopyWith(
    ChannelGetOrCreateRequest value,
    $Res Function(ChannelGetOrCreateRequest) _then,
  ) = _$ChannelGetOrCreateRequestCopyWithImpl;
  @useResult
  $Res call({
    ChannelInput? data,
    bool? hideForCreator,
    List<String>? memberCustomInclude,
    PaginationParams? members,
    MessagePaginationParams? messages,
    bool? presence,
    bool? state,
    bool? threadUnreadCounts,
    bool? watch,
    PaginationParams? watchers,
  });
}

/// @nodoc
class _$ChannelGetOrCreateRequestCopyWithImpl<$Res>
    implements $ChannelGetOrCreateRequestCopyWith<$Res> {
  _$ChannelGetOrCreateRequestCopyWithImpl(this._self, this._then);

  final ChannelGetOrCreateRequest _self;
  final $Res Function(ChannelGetOrCreateRequest) _then;

  /// Create a copy of ChannelGetOrCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? hideForCreator = freezed,
    Object? memberCustomInclude = freezed,
    Object? members = freezed,
    Object? messages = freezed,
    Object? presence = freezed,
    Object? state = freezed,
    Object? threadUnreadCounts = freezed,
    Object? watch = freezed,
    Object? watchers = freezed,
  }) {
    return _then(
      ChannelGetOrCreateRequest(
        data: freezed == data
            ? _self.data
            : data // ignore: cast_nullable_to_non_nullable
                  as ChannelInput?,
        hideForCreator: freezed == hideForCreator
            ? _self.hideForCreator
            : hideForCreator // ignore: cast_nullable_to_non_nullable
                  as bool?,
        memberCustomInclude: freezed == memberCustomInclude
            ? _self.memberCustomInclude
            : memberCustomInclude // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        members: freezed == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as PaginationParams?,
        messages: freezed == messages
            ? _self.messages
            : messages // ignore: cast_nullable_to_non_nullable
                  as MessagePaginationParams?,
        presence: freezed == presence
            ? _self.presence
            : presence // ignore: cast_nullable_to_non_nullable
                  as bool?,
        state: freezed == state
            ? _self.state
            : state // ignore: cast_nullable_to_non_nullable
                  as bool?,
        threadUnreadCounts: freezed == threadUnreadCounts
            ? _self.threadUnreadCounts
            : threadUnreadCounts // ignore: cast_nullable_to_non_nullable
                  as bool?,
        watch: freezed == watch
            ? _self.watch
            : watch // ignore: cast_nullable_to_non_nullable
                  as bool?,
        watchers: freezed == watchers
            ? _self.watchers
            : watchers // ignore: cast_nullable_to_non_nullable
                  as PaginationParams?,
      ),
    );
  }
}
