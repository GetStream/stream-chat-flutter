// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduled_message_content_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduledMessageContentResponse {
  List<Attachment>? get attachments;
  Map<String, Object?> get custom;
  String? get html;
  bool? get mentionedChannel;
  List<String>? get mentionedGroupIds;
  bool? get mentionedHere;
  List<String>? get mentionedRoles;
  List<String>? get mentionedUsers;
  String? get mml;
  String? get parentId;
  DateTime? get pinExpires;
  bool? get pinned;
  String? get pollId;
  String? get quotedMessageId;
  List<String>? get restrictedVisibility;
  ScheduledMessageLocation? get sharedLocation;
  bool? get showInChannel;
  bool? get silent;
  String get text;
  String? get type;

  /// Create a copy of ScheduledMessageContentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduledMessageContentResponseCopyWith<ScheduledMessageContentResponse> get copyWith =>
      _$ScheduledMessageContentResponseCopyWithImpl<ScheduledMessageContentResponse>(
        this as ScheduledMessageContentResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScheduledMessageContentResponse &&
            const DeepCollectionEquality().equals(
              other.attachments,
              attachments,
            ) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.html, html) || other.html == html) &&
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
    html,
    mentionedChannel,
    const DeepCollectionEquality().hash(mentionedGroupIds),
    mentionedHere,
    const DeepCollectionEquality().hash(mentionedRoles),
    const DeepCollectionEquality().hash(mentionedUsers),
    mml,
    parentId,
    pinExpires,
    pinned,
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
    return 'ScheduledMessageContentResponse(attachments: $attachments, custom: $custom, html: $html, mentionedChannel: $mentionedChannel, mentionedGroupIds: $mentionedGroupIds, mentionedHere: $mentionedHere, mentionedRoles: $mentionedRoles, mentionedUsers: $mentionedUsers, mml: $mml, parentId: $parentId, pinExpires: $pinExpires, pinned: $pinned, pollId: $pollId, quotedMessageId: $quotedMessageId, restrictedVisibility: $restrictedVisibility, sharedLocation: $sharedLocation, showInChannel: $showInChannel, silent: $silent, text: $text, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ScheduledMessageContentResponseCopyWith<$Res> {
  factory $ScheduledMessageContentResponseCopyWith(
    ScheduledMessageContentResponse value,
    $Res Function(ScheduledMessageContentResponse) _then,
  ) = _$ScheduledMessageContentResponseCopyWithImpl;
  @useResult
  $Res call({
    List<Attachment>? attachments,
    Map<String, Object?> custom,
    String? html,
    bool? mentionedChannel,
    List<String>? mentionedGroupIds,
    bool? mentionedHere,
    List<String>? mentionedRoles,
    List<String>? mentionedUsers,
    String? mml,
    String? parentId,
    DateTime? pinExpires,
    bool? pinned,
    String? pollId,
    String? quotedMessageId,
    List<String>? restrictedVisibility,
    ScheduledMessageLocation? sharedLocation,
    bool? showInChannel,
    bool? silent,
    String text,
    String? type,
  });
}

/// @nodoc
class _$ScheduledMessageContentResponseCopyWithImpl<$Res> implements $ScheduledMessageContentResponseCopyWith<$Res> {
  _$ScheduledMessageContentResponseCopyWithImpl(this._self, this._then);

  final ScheduledMessageContentResponse _self;
  final $Res Function(ScheduledMessageContentResponse) _then;

  /// Create a copy of ScheduledMessageContentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachments = freezed,
    Object? custom = null,
    Object? html = freezed,
    Object? mentionedChannel = freezed,
    Object? mentionedGroupIds = freezed,
    Object? mentionedHere = freezed,
    Object? mentionedRoles = freezed,
    Object? mentionedUsers = freezed,
    Object? mml = freezed,
    Object? parentId = freezed,
    Object? pinExpires = freezed,
    Object? pinned = freezed,
    Object? pollId = freezed,
    Object? quotedMessageId = freezed,
    Object? restrictedVisibility = freezed,
    Object? sharedLocation = freezed,
    Object? showInChannel = freezed,
    Object? silent = freezed,
    Object? text = null,
    Object? type = freezed,
  }) {
    return _then(
      ScheduledMessageContentResponse(
        attachments: freezed == attachments
            ? _self.attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<Attachment>?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        html: freezed == html
            ? _self.html
            : html // ignore: cast_nullable_to_non_nullable
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
                  as ScheduledMessageLocation?,
        showInChannel: freezed == showInChannel
            ? _self.showInChannel
            : showInChannel // ignore: cast_nullable_to_non_nullable
                  as bool?,
        silent: freezed == silent
            ? _self.silent
            : silent // ignore: cast_nullable_to_non_nullable
                  as bool?,
        text: null == text
            ? _self.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        type: freezed == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
