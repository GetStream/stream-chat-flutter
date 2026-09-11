// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageRequest {
  List<Attachment>? get attachments;
  Map<String, Object?>? get custom;
  String? get id;
  bool? get mentionedChannel;
  List<String>? get mentionedGroupIds;
  bool? get mentionedHere;
  List<String>? get mentionedRoles;
  List<String>? get mentionedUsers;
  String? get mml;
  String? get parentId;
  DateTime? get pinExpires;
  bool? get pinned;
  DateTime? get pinnedAt;
  String? get pollId;
  String? get quotedMessageId;
  List<String>? get restrictedVisibility;
  SharedLocation? get sharedLocation;
  bool? get showInChannel;
  bool? get silent;
  String? get text;
  MessageRequestType? get type;

  /// Create a copy of MessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageRequestCopyWith<MessageRequest> get copyWith => _$MessageRequestCopyWithImpl<MessageRequest>(
    this as MessageRequest,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageRequest &&
            const DeepCollectionEquality().equals(
              other.attachments,
              attachments,
            ) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mentionedChannel, mentionedChannel) || other.mentionedChannel == mentionedChannel) &&
            const DeepCollectionEquality().equals(
              other.mentionedGroupIds,
              mentionedGroupIds,
            ) &&
            (identical(other.mentionedHere, mentionedHere) || other.mentionedHere == mentionedHere) &&
            const DeepCollectionEquality().equals(
              other.mentionedRoles,
              mentionedRoles,
            ) &&
            const DeepCollectionEquality().equals(
              other.mentionedUsers,
              mentionedUsers,
            ) &&
            (identical(other.mml, mml) || other.mml == mml) &&
            (identical(other.parentId, parentId) || other.parentId == parentId) &&
            (identical(other.pinExpires, pinExpires) || other.pinExpires == pinExpires) &&
            (identical(other.pinned, pinned) || other.pinned == pinned) &&
            (identical(other.pinnedAt, pinnedAt) || other.pinnedAt == pinnedAt) &&
            (identical(other.pollId, pollId) || other.pollId == pollId) &&
            (identical(other.quotedMessageId, quotedMessageId) || other.quotedMessageId == quotedMessageId) &&
            const DeepCollectionEquality().equals(
              other.restrictedVisibility,
              restrictedVisibility,
            ) &&
            (identical(other.sharedLocation, sharedLocation) || other.sharedLocation == sharedLocation) &&
            (identical(other.showInChannel, showInChannel) || other.showInChannel == showInChannel) &&
            (identical(other.silent, silent) || other.silent == silent) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    const DeepCollectionEquality().hash(attachments),
    const DeepCollectionEquality().hash(custom),
    id,
    mentionedChannel,
    const DeepCollectionEquality().hash(mentionedGroupIds),
    mentionedHere,
    const DeepCollectionEquality().hash(mentionedRoles),
    const DeepCollectionEquality().hash(mentionedUsers),
    mml,
    parentId,
    pinExpires,
    pinned,
    pinnedAt,
    pollId,
    quotedMessageId,
    const DeepCollectionEquality().hash(restrictedVisibility),
    sharedLocation,
    showInChannel,
    silent,
    text,
    type,
  ]);

  @override
  String toString() {
    return 'MessageRequest(attachments: $attachments, custom: $custom, id: $id, mentionedChannel: $mentionedChannel, mentionedGroupIds: $mentionedGroupIds, mentionedHere: $mentionedHere, mentionedRoles: $mentionedRoles, mentionedUsers: $mentionedUsers, mml: $mml, parentId: $parentId, pinExpires: $pinExpires, pinned: $pinned, pinnedAt: $pinnedAt, pollId: $pollId, quotedMessageId: $quotedMessageId, restrictedVisibility: $restrictedVisibility, sharedLocation: $sharedLocation, showInChannel: $showInChannel, silent: $silent, text: $text, type: $type)';
  }
}

/// @nodoc
abstract mixin class $MessageRequestCopyWith<$Res> {
  factory $MessageRequestCopyWith(
    MessageRequest value,
    $Res Function(MessageRequest) _then,
  ) = _$MessageRequestCopyWithImpl;
  @useResult
  $Res call({
    List<Attachment>? attachments,
    Map<String, Object?>? custom,
    String? id,
    bool? mentionedChannel,
    List<String>? mentionedGroupIds,
    bool? mentionedHere,
    List<String>? mentionedRoles,
    List<String>? mentionedUsers,
    String? mml,
    String? parentId,
    DateTime? pinExpires,
    bool? pinned,
    DateTime? pinnedAt,
    String? pollId,
    String? quotedMessageId,
    List<String>? restrictedVisibility,
    SharedLocation? sharedLocation,
    bool? showInChannel,
    bool? silent,
    String? text,
    MessageRequestType? type,
  });
}

/// @nodoc
class _$MessageRequestCopyWithImpl<$Res> implements $MessageRequestCopyWith<$Res> {
  _$MessageRequestCopyWithImpl(this._self, this._then);

  final MessageRequest _self;
  final $Res Function(MessageRequest) _then;

  /// Create a copy of MessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachments = freezed,
    Object? custom = freezed,
    Object? id = freezed,
    Object? mentionedChannel = freezed,
    Object? mentionedGroupIds = freezed,
    Object? mentionedHere = freezed,
    Object? mentionedRoles = freezed,
    Object? mentionedUsers = freezed,
    Object? mml = freezed,
    Object? parentId = freezed,
    Object? pinExpires = freezed,
    Object? pinned = freezed,
    Object? pinnedAt = freezed,
    Object? pollId = freezed,
    Object? quotedMessageId = freezed,
    Object? restrictedVisibility = freezed,
    Object? sharedLocation = freezed,
    Object? showInChannel = freezed,
    Object? silent = freezed,
    Object? text = freezed,
    Object? type = freezed,
  }) {
    return _then(
      MessageRequest(
        attachments: freezed == attachments
            ? _self.attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<Attachment>?,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        id: freezed == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        mentionedChannel: freezed == mentionedChannel
            ? _self.mentionedChannel
            : mentionedChannel // ignore: cast_nullable_to_non_nullable
                  as bool?,
        mentionedGroupIds: freezed == mentionedGroupIds
            ? _self.mentionedGroupIds
            : mentionedGroupIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        mentionedHere: freezed == mentionedHere
            ? _self.mentionedHere
            : mentionedHere // ignore: cast_nullable_to_non_nullable
                  as bool?,
        mentionedRoles: freezed == mentionedRoles
            ? _self.mentionedRoles
            : mentionedRoles // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        mentionedUsers: freezed == mentionedUsers
            ? _self.mentionedUsers
            : mentionedUsers // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        mml: freezed == mml
            ? _self.mml
            : mml // ignore: cast_nullable_to_non_nullable
                  as String?,
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        pinExpires: freezed == pinExpires
            ? _self.pinExpires
            : pinExpires // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        pinned: freezed == pinned
            ? _self.pinned
            : pinned // ignore: cast_nullable_to_non_nullable
                  as bool?,
        pinnedAt: freezed == pinnedAt
            ? _self.pinnedAt
            : pinnedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        pollId: freezed == pollId
            ? _self.pollId
            : pollId // ignore: cast_nullable_to_non_nullable
                  as String?,
        quotedMessageId: freezed == quotedMessageId
            ? _self.quotedMessageId
            : quotedMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        restrictedVisibility: freezed == restrictedVisibility
            ? _self.restrictedVisibility
            : restrictedVisibility // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        sharedLocation: freezed == sharedLocation
            ? _self.sharedLocation
            : sharedLocation // ignore: cast_nullable_to_non_nullable
                  as SharedLocation?,
        showInChannel: freezed == showInChannel
            ? _self.showInChannel
            : showInChannel // ignore: cast_nullable_to_non_nullable
                  as bool?,
        silent: freezed == silent
            ? _self.silent
            : silent // ignore: cast_nullable_to_non_nullable
                  as bool?,
        text: freezed == text
            ? _self.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as MessageRequestType?,
      ),
    );
  }
}
