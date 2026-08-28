// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_payload_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DraftPayloadResponse {
  List<Attachment>? get attachments;
  Map<String, Object?> get custom;
  String? get html;
  String get id;
  List<UserResponse>? get mentionedUsers;
  String? get mml;
  String? get parentId;
  String? get pollId;
  String? get quotedMessageId;
  bool? get showInChannel;
  bool? get silent;
  String get text;
  String? get type;

  /// Create a copy of DraftPayloadResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DraftPayloadResponseCopyWith<DraftPayloadResponse> get copyWith =>
      _$DraftPayloadResponseCopyWithImpl<DraftPayloadResponse>(
        this as DraftPayloadResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DraftPayloadResponse &&
            const DeepCollectionEquality().equals(
              other.attachments,
              attachments,
            ) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.html, html) || other.html == html) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other.mentionedUsers,
              mentionedUsers,
            ) &&
            (identical(other.mml, mml) || other.mml == mml) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.pollId, pollId) || other.pollId == pollId) &&
            (identical(other.quotedMessageId, quotedMessageId) ||
                other.quotedMessageId == quotedMessageId) &&
            (identical(other.showInChannel, showInChannel) ||
                other.showInChannel == showInChannel) &&
            (identical(other.silent, silent) || other.silent == silent) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(attachments),
    const DeepCollectionEquality().hash(custom),
    html,
    id,
    const DeepCollectionEquality().hash(mentionedUsers),
    mml,
    parentId,
    pollId,
    quotedMessageId,
    showInChannel,
    silent,
    text,
    type,
  );

  @override
  String toString() {
    return 'DraftPayloadResponse(attachments: $attachments, custom: $custom, html: $html, id: $id, mentionedUsers: $mentionedUsers, mml: $mml, parentId: $parentId, pollId: $pollId, quotedMessageId: $quotedMessageId, showInChannel: $showInChannel, silent: $silent, text: $text, type: $type)';
  }
}

/// @nodoc
abstract mixin class $DraftPayloadResponseCopyWith<$Res> {
  factory $DraftPayloadResponseCopyWith(
    DraftPayloadResponse value,
    $Res Function(DraftPayloadResponse) _then,
  ) = _$DraftPayloadResponseCopyWithImpl;
  @useResult
  $Res call({
    List<Attachment>? attachments,
    Map<String, Object?> custom,
    String? html,
    String id,
    List<UserResponse>? mentionedUsers,
    String? mml,
    String? parentId,
    String? pollId,
    String? quotedMessageId,
    bool? showInChannel,
    bool? silent,
    String text,
    String? type,
  });
}

/// @nodoc
class _$DraftPayloadResponseCopyWithImpl<$Res>
    implements $DraftPayloadResponseCopyWith<$Res> {
  _$DraftPayloadResponseCopyWithImpl(this._self, this._then);

  final DraftPayloadResponse _self;
  final $Res Function(DraftPayloadResponse) _then;

  /// Create a copy of DraftPayloadResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachments = freezed,
    Object? custom = null,
    Object? html = freezed,
    Object? id = null,
    Object? mentionedUsers = freezed,
    Object? mml = freezed,
    Object? parentId = freezed,
    Object? pollId = freezed,
    Object? quotedMessageId = freezed,
    Object? showInChannel = freezed,
    Object? silent = freezed,
    Object? text = null,
    Object? type = freezed,
  }) {
    return _then(
      DraftPayloadResponse(
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
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        mentionedUsers: freezed == mentionedUsers
            ? _self.mentionedUsers
            : mentionedUsers // ignore: cast_nullable_to_non_nullable
                  as List<UserResponse>?,
        mml: freezed == mml
            ? _self.mml
            : mml // ignore: cast_nullable_to_non_nullable
                  as String?,
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        pollId: freezed == pollId
            ? _self.pollId
            : pollId // ignore: cast_nullable_to_non_nullable
                  as String?,
        quotedMessageId: freezed == quotedMessageId
            ? _self.quotedMessageId
            : quotedMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
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
