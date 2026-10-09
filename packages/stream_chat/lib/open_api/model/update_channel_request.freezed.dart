// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_channel_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateChannelRequest {
  bool? get acceptInvite;
  List<String>? get addFilterTags;
  List<ChannelMemberRequest>? get addMembers;
  int? get cooldown;
  ChannelInputRequest? get data;
  bool? get hideHistory;
  DateTime? get hideHistoryBefore;
  List<ChannelMemberRequest>? get invites;
  MessageRequest? get message;
  bool? get rejectInvite;
  List<String>? get removeFilterTags;
  List<String>? get removeMembers;
  bool? get skipPush;

  /// Create a copy of UpdateChannelRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateChannelRequestCopyWith<UpdateChannelRequest> get copyWith =>
      _$UpdateChannelRequestCopyWithImpl<UpdateChannelRequest>(
        this as UpdateChannelRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateChannelRequest &&
            (identical(other.acceptInvite, acceptInvite) || other.acceptInvite == acceptInvite) &&
            const DeepCollectionEquality().equals(
              other.addFilterTags,
              addFilterTags,
            ) &&
            const DeepCollectionEquality().equals(
              other.addMembers,
              addMembers,
            ) &&
            (identical(other.cooldown, cooldown) || other.cooldown == cooldown) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.hideHistory, hideHistory) || other.hideHistory == hideHistory) &&
            (identical(other.hideHistoryBefore, hideHistoryBefore) || other.hideHistoryBefore == hideHistoryBefore) &&
            const DeepCollectionEquality().equals(other.invites, invites) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.rejectInvite, rejectInvite) || other.rejectInvite == rejectInvite) &&
            const DeepCollectionEquality().equals(
              other.removeFilterTags,
              removeFilterTags,
            ) &&
            const DeepCollectionEquality().equals(
              other.removeMembers,
              removeMembers,
            ) &&
            (identical(other.skipPush, skipPush) || other.skipPush == skipPush));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    acceptInvite,
    const DeepCollectionEquality().hash(addFilterTags),
    const DeepCollectionEquality().hash(addMembers),
    cooldown,
    data,
    hideHistory,
    hideHistoryBefore,
    const DeepCollectionEquality().hash(invites),
    message,
    rejectInvite,
    const DeepCollectionEquality().hash(removeFilterTags),
    const DeepCollectionEquality().hash(removeMembers),
    skipPush,
  );

  @override
  String toString() {
    return 'UpdateChannelRequest(acceptInvite: $acceptInvite, addFilterTags: $addFilterTags, addMembers: $addMembers, cooldown: $cooldown, data: $data, hideHistory: $hideHistory, hideHistoryBefore: $hideHistoryBefore, invites: $invites, message: $message, rejectInvite: $rejectInvite, removeFilterTags: $removeFilterTags, removeMembers: $removeMembers, skipPush: $skipPush)';
  }
}

/// @nodoc
abstract mixin class $UpdateChannelRequestCopyWith<$Res> {
  factory $UpdateChannelRequestCopyWith(
    UpdateChannelRequest value,
    $Res Function(UpdateChannelRequest) _then,
  ) = _$UpdateChannelRequestCopyWithImpl;
  @useResult
  $Res call({
    bool? acceptInvite,
    List<String>? addFilterTags,
    List<ChannelMemberRequest>? addMembers,
    int? cooldown,
    ChannelInputRequest? data,
    bool? hideHistory,
    DateTime? hideHistoryBefore,
    List<ChannelMemberRequest>? invites,
    MessageRequest? message,
    bool? rejectInvite,
    List<String>? removeFilterTags,
    List<String>? removeMembers,
    bool? skipPush,
  });
}

/// @nodoc
class _$UpdateChannelRequestCopyWithImpl<$Res> implements $UpdateChannelRequestCopyWith<$Res> {
  _$UpdateChannelRequestCopyWithImpl(this._self, this._then);

  final UpdateChannelRequest _self;
  final $Res Function(UpdateChannelRequest) _then;

  /// Create a copy of UpdateChannelRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acceptInvite = freezed,
    Object? addFilterTags = freezed,
    Object? addMembers = freezed,
    Object? cooldown = freezed,
    Object? data = freezed,
    Object? hideHistory = freezed,
    Object? hideHistoryBefore = freezed,
    Object? invites = freezed,
    Object? message = freezed,
    Object? rejectInvite = freezed,
    Object? removeFilterTags = freezed,
    Object? removeMembers = freezed,
    Object? skipPush = freezed,
  }) {
    return _then(
      UpdateChannelRequest(
        acceptInvite: freezed == acceptInvite
            ? _self.acceptInvite
            : acceptInvite // ignore: cast_nullable_to_non_nullable
                  as bool?,
        addFilterTags: freezed == addFilterTags
            ? _self.addFilterTags
            : addFilterTags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        addMembers: freezed == addMembers
            ? _self.addMembers
            : addMembers // ignore: cast_nullable_to_non_nullable
                  as List<ChannelMemberRequest>?,
        cooldown: freezed == cooldown
            ? _self.cooldown
            : cooldown // ignore: cast_nullable_to_non_nullable
                  as int?,
        data: freezed == data
            ? _self.data
            : data // ignore: cast_nullable_to_non_nullable
                  as ChannelInputRequest?,
        hideHistory: freezed == hideHistory
            ? _self.hideHistory
            : hideHistory // ignore: cast_nullable_to_non_nullable
                  as bool?,
        hideHistoryBefore: freezed == hideHistoryBefore
            ? _self.hideHistoryBefore
            : hideHistoryBefore // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        invites: freezed == invites
            ? _self.invites
            : invites // ignore: cast_nullable_to_non_nullable
                  as List<ChannelMemberRequest>?,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageRequest?,
        rejectInvite: freezed == rejectInvite
            ? _self.rejectInvite
            : rejectInvite // ignore: cast_nullable_to_non_nullable
                  as bool?,
        removeFilterTags: freezed == removeFilterTags
            ? _self.removeFilterTags
            : removeFilterTags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        removeMembers: freezed == removeMembers
            ? _self.removeMembers
            : removeMembers // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        skipPush: freezed == skipPush
            ? _self.skipPush
            : skipPush // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
