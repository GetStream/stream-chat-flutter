// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_moderation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageModerationResult {
  String get action;
  ModerationResponse? get aiModerationResponse;
  String? get blockedWord;
  String? get blocklistName;
  DateTime get createdAt;
  String get messageId;
  String? get moderatedBy;
  Thresholds? get moderationThresholds;
  DateTime get updatedAt;
  bool get userBadKarma;
  double get userKarma;

  /// Create a copy of MessageModerationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageModerationResultCopyWith<MessageModerationResult> get copyWith =>
      _$MessageModerationResultCopyWithImpl<MessageModerationResult>(
        this as MessageModerationResult,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageModerationResult &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.aiModerationResponse, aiModerationResponse) ||
                other.aiModerationResponse == aiModerationResponse) &&
            (identical(other.blockedWord, blockedWord) ||
                other.blockedWord == blockedWord) &&
            (identical(other.blocklistName, blocklistName) ||
                other.blocklistName == blocklistName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.moderatedBy, moderatedBy) ||
                other.moderatedBy == moderatedBy) &&
            (identical(other.moderationThresholds, moderationThresholds) ||
                other.moderationThresholds == moderationThresholds) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userBadKarma, userBadKarma) ||
                other.userBadKarma == userBadKarma) &&
            (identical(other.userKarma, userKarma) ||
                other.userKarma == userKarma));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    action,
    aiModerationResponse,
    blockedWord,
    blocklistName,
    createdAt,
    messageId,
    moderatedBy,
    moderationThresholds,
    updatedAt,
    userBadKarma,
    userKarma,
  );

  @override
  String toString() {
    return 'MessageModerationResult(action: $action, aiModerationResponse: $aiModerationResponse, blockedWord: $blockedWord, blocklistName: $blocklistName, createdAt: $createdAt, messageId: $messageId, moderatedBy: $moderatedBy, moderationThresholds: $moderationThresholds, updatedAt: $updatedAt, userBadKarma: $userBadKarma, userKarma: $userKarma)';
  }
}

/// @nodoc
abstract mixin class $MessageModerationResultCopyWith<$Res> {
  factory $MessageModerationResultCopyWith(
    MessageModerationResult value,
    $Res Function(MessageModerationResult) _then,
  ) = _$MessageModerationResultCopyWithImpl;
  @useResult
  $Res call({
    String action,
    ModerationResponse? aiModerationResponse,
    String? blockedWord,
    String? blocklistName,
    DateTime createdAt,
    String messageId,
    String? moderatedBy,
    Thresholds? moderationThresholds,
    DateTime updatedAt,
    bool userBadKarma,
    double userKarma,
  });
}

/// @nodoc
class _$MessageModerationResultCopyWithImpl<$Res>
    implements $MessageModerationResultCopyWith<$Res> {
  _$MessageModerationResultCopyWithImpl(this._self, this._then);

  final MessageModerationResult _self;
  final $Res Function(MessageModerationResult) _then;

  /// Create a copy of MessageModerationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? aiModerationResponse = freezed,
    Object? blockedWord = freezed,
    Object? blocklistName = freezed,
    Object? createdAt = null,
    Object? messageId = null,
    Object? moderatedBy = freezed,
    Object? moderationThresholds = freezed,
    Object? updatedAt = null,
    Object? userBadKarma = null,
    Object? userKarma = null,
  }) {
    return _then(
      MessageModerationResult(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        aiModerationResponse: freezed == aiModerationResponse
            ? _self.aiModerationResponse
            : aiModerationResponse // ignore: cast_nullable_to_non_nullable
                  as ModerationResponse?,
        blockedWord: freezed == blockedWord
            ? _self.blockedWord
            : blockedWord // ignore: cast_nullable_to_non_nullable
                  as String?,
        blocklistName: freezed == blocklistName
            ? _self.blocklistName
            : blocklistName // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        moderatedBy: freezed == moderatedBy
            ? _self.moderatedBy
            : moderatedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        moderationThresholds: freezed == moderationThresholds
            ? _self.moderationThresholds
            : moderationThresholds // ignore: cast_nullable_to_non_nullable
                  as Thresholds?,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        userBadKarma: null == userBadKarma
            ? _self.userBadKarma
            : userBadKarma // ignore: cast_nullable_to_non_nullable
                  as bool,
        userKarma: null == userKarma
            ? _self.userKarma
            : userKarma // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}
