// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_change_set.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageChangeSet {
  bool get attachments;
  bool get custom;
  bool get html;
  bool get mentionedUserIds;
  bool get mml;
  bool get pin;
  bool get quotedMessageId;
  bool get silent;
  bool get text;

  /// Create a copy of MessageChangeSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageChangeSetCopyWith<MessageChangeSet> get copyWith =>
      _$MessageChangeSetCopyWithImpl<MessageChangeSet>(
        this as MessageChangeSet,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageChangeSet &&
            (identical(other.attachments, attachments) ||
                other.attachments == attachments) &&
            (identical(other.custom, custom) || other.custom == custom) &&
            (identical(other.html, html) || other.html == html) &&
            (identical(other.mentionedUserIds, mentionedUserIds) ||
                other.mentionedUserIds == mentionedUserIds) &&
            (identical(other.mml, mml) || other.mml == mml) &&
            (identical(other.pin, pin) || other.pin == pin) &&
            (identical(other.quotedMessageId, quotedMessageId) ||
                other.quotedMessageId == quotedMessageId) &&
            (identical(other.silent, silent) || other.silent == silent) &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    attachments,
    custom,
    html,
    mentionedUserIds,
    mml,
    pin,
    quotedMessageId,
    silent,
    text,
  );

  @override
  String toString() {
    return 'MessageChangeSet(attachments: $attachments, custom: $custom, html: $html, mentionedUserIds: $mentionedUserIds, mml: $mml, pin: $pin, quotedMessageId: $quotedMessageId, silent: $silent, text: $text)';
  }
}

/// @nodoc
abstract mixin class $MessageChangeSetCopyWith<$Res> {
  factory $MessageChangeSetCopyWith(
    MessageChangeSet value,
    $Res Function(MessageChangeSet) _then,
  ) = _$MessageChangeSetCopyWithImpl;
  @useResult
  $Res call({
    bool attachments,
    bool custom,
    bool html,
    bool mentionedUserIds,
    bool mml,
    bool pin,
    bool quotedMessageId,
    bool silent,
    bool text,
  });
}

/// @nodoc
class _$MessageChangeSetCopyWithImpl<$Res>
    implements $MessageChangeSetCopyWith<$Res> {
  _$MessageChangeSetCopyWithImpl(this._self, this._then);

  final MessageChangeSet _self;
  final $Res Function(MessageChangeSet) _then;

  /// Create a copy of MessageChangeSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachments = null,
    Object? custom = null,
    Object? html = null,
    Object? mentionedUserIds = null,
    Object? mml = null,
    Object? pin = null,
    Object? quotedMessageId = null,
    Object? silent = null,
    Object? text = null,
  }) {
    return _then(
      MessageChangeSet(
        attachments: null == attachments
            ? _self.attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as bool,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as bool,
        html: null == html
            ? _self.html
            : html // ignore: cast_nullable_to_non_nullable
                  as bool,
        mentionedUserIds: null == mentionedUserIds
            ? _self.mentionedUserIds
            : mentionedUserIds // ignore: cast_nullable_to_non_nullable
                  as bool,
        mml: null == mml
            ? _self.mml
            : mml // ignore: cast_nullable_to_non_nullable
                  as bool,
        pin: null == pin
            ? _self.pin
            : pin // ignore: cast_nullable_to_non_nullable
                  as bool,
        quotedMessageId: null == quotedMessageId
            ? _self.quotedMessageId
            : quotedMessageId // ignore: cast_nullable_to_non_nullable
                  as bool,
        silent: null == silent
            ? _self.silent
            : silent // ignore: cast_nullable_to_non_nullable
                  as bool,
        text: null == text
            ? _self.text
            : text // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
