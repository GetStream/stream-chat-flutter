// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feeds_v3_comment_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedsV3CommentResponse {
  List<Attachment>? get attachments;
  int get bookmarkCount;
  double get confidenceScore;
  double? get controversyScore;
  DateTime get createdAt;
  Map<String, Object?>? get custom;
  DateTime? get deletedAt;
  int get downvoteCount;
  DateTime? get editedAt;
  Map<String, String>? get i18n;
  String get id;
  List<FeedsReactionResponse>? get latestReactions;
  List<UserResponse> get mentionedUsers;
  ModerationV2Response? get moderation;
  String get objectId;
  String get objectType;
  List<FeedsReactionResponse> get ownReactions;
  String? get parentId;
  int get reactionCount;
  Map<String, FeedsReactionGroupResponse>? get reactionGroups;
  int get replyCount;
  int get score;
  String get status;
  String? get text;
  DateTime get updatedAt;
  int get upvoteCount;
  UserResponse get user;

  /// Create a copy of FeedsV3CommentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedsV3CommentResponseCopyWith<FeedsV3CommentResponse> get copyWith =>
      _$FeedsV3CommentResponseCopyWithImpl<FeedsV3CommentResponse>(
        this as FeedsV3CommentResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedsV3CommentResponse &&
            const DeepCollectionEquality().equals(
              other.attachments,
              attachments,
            ) &&
            (identical(other.bookmarkCount, bookmarkCount) ||
                other.bookmarkCount == bookmarkCount) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            (identical(other.controversyScore, controversyScore) ||
                other.controversyScore == controversyScore) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.downvoteCount, downvoteCount) ||
                other.downvoteCount == downvoteCount) &&
            (identical(other.editedAt, editedAt) ||
                other.editedAt == editedAt) &&
            const DeepCollectionEquality().equals(other.i18n, i18n) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other.latestReactions,
              latestReactions,
            ) &&
            const DeepCollectionEquality().equals(
              other.mentionedUsers,
              mentionedUsers,
            ) &&
            (identical(other.moderation, moderation) ||
                other.moderation == moderation) &&
            (identical(other.objectId, objectId) ||
                other.objectId == objectId) &&
            (identical(other.objectType, objectType) ||
                other.objectType == objectType) &&
            const DeepCollectionEquality().equals(
              other.ownReactions,
              ownReactions,
            ) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.reactionCount, reactionCount) ||
                other.reactionCount == reactionCount) &&
            const DeepCollectionEquality().equals(
              other.reactionGroups,
              reactionGroups,
            ) &&
            (identical(other.replyCount, replyCount) ||
                other.replyCount == replyCount) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.upvoteCount, upvoteCount) ||
                other.upvoteCount == upvoteCount) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    const DeepCollectionEquality().hash(attachments),
    bookmarkCount,
    confidenceScore,
    controversyScore,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    deletedAt,
    downvoteCount,
    editedAt,
    const DeepCollectionEquality().hash(i18n),
    id,
    const DeepCollectionEquality().hash(latestReactions),
    const DeepCollectionEquality().hash(mentionedUsers),
    moderation,
    objectId,
    objectType,
    const DeepCollectionEquality().hash(ownReactions),
    parentId,
    reactionCount,
    const DeepCollectionEquality().hash(reactionGroups),
    replyCount,
    score,
    status,
    text,
    updatedAt,
    upvoteCount,
    user,
  ]);

  @override
  String toString() {
    return 'FeedsV3CommentResponse(attachments: $attachments, bookmarkCount: $bookmarkCount, confidenceScore: $confidenceScore, controversyScore: $controversyScore, createdAt: $createdAt, custom: $custom, deletedAt: $deletedAt, downvoteCount: $downvoteCount, editedAt: $editedAt, i18n: $i18n, id: $id, latestReactions: $latestReactions, mentionedUsers: $mentionedUsers, moderation: $moderation, objectId: $objectId, objectType: $objectType, ownReactions: $ownReactions, parentId: $parentId, reactionCount: $reactionCount, reactionGroups: $reactionGroups, replyCount: $replyCount, score: $score, status: $status, text: $text, updatedAt: $updatedAt, upvoteCount: $upvoteCount, user: $user)';
  }
}

/// @nodoc
abstract mixin class $FeedsV3CommentResponseCopyWith<$Res> {
  factory $FeedsV3CommentResponseCopyWith(
    FeedsV3CommentResponse value,
    $Res Function(FeedsV3CommentResponse) _then,
  ) = _$FeedsV3CommentResponseCopyWithImpl;
  @useResult
  $Res call({
    List<Attachment>? attachments,
    int bookmarkCount,
    double confidenceScore,
    double? controversyScore,
    DateTime createdAt,
    Map<String, Object?>? custom,
    DateTime? deletedAt,
    int downvoteCount,
    DateTime? editedAt,
    Map<String, String>? i18n,
    String id,
    List<FeedsReactionResponse>? latestReactions,
    List<UserResponse> mentionedUsers,
    ModerationV2Response? moderation,
    String objectId,
    String objectType,
    List<FeedsReactionResponse> ownReactions,
    String? parentId,
    int reactionCount,
    Map<String, FeedsReactionGroupResponse>? reactionGroups,
    int replyCount,
    int score,
    String status,
    String? text,
    DateTime updatedAt,
    int upvoteCount,
    UserResponse user,
  });
}

/// @nodoc
class _$FeedsV3CommentResponseCopyWithImpl<$Res>
    implements $FeedsV3CommentResponseCopyWith<$Res> {
  _$FeedsV3CommentResponseCopyWithImpl(this._self, this._then);

  final FeedsV3CommentResponse _self;
  final $Res Function(FeedsV3CommentResponse) _then;

  /// Create a copy of FeedsV3CommentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachments = freezed,
    Object? bookmarkCount = null,
    Object? confidenceScore = null,
    Object? controversyScore = freezed,
    Object? createdAt = null,
    Object? custom = freezed,
    Object? deletedAt = freezed,
    Object? downvoteCount = null,
    Object? editedAt = freezed,
    Object? i18n = freezed,
    Object? id = null,
    Object? latestReactions = freezed,
    Object? mentionedUsers = null,
    Object? moderation = freezed,
    Object? objectId = null,
    Object? objectType = null,
    Object? ownReactions = null,
    Object? parentId = freezed,
    Object? reactionCount = null,
    Object? reactionGroups = freezed,
    Object? replyCount = null,
    Object? score = null,
    Object? status = null,
    Object? text = freezed,
    Object? updatedAt = null,
    Object? upvoteCount = null,
    Object? user = null,
  }) {
    return _then(
      FeedsV3CommentResponse(
        attachments: freezed == attachments
            ? _self.attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<Attachment>?,
        bookmarkCount: null == bookmarkCount
            ? _self.bookmarkCount
            : bookmarkCount // ignore: cast_nullable_to_non_nullable
                  as int,
        confidenceScore: null == confidenceScore
            ? _self.confidenceScore
            : confidenceScore // ignore: cast_nullable_to_non_nullable
                  as double,
        controversyScore: freezed == controversyScore
            ? _self.controversyScore
            : controversyScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        deletedAt: freezed == deletedAt
            ? _self.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        downvoteCount: null == downvoteCount
            ? _self.downvoteCount
            : downvoteCount // ignore: cast_nullable_to_non_nullable
                  as int,
        editedAt: freezed == editedAt
            ? _self.editedAt
            : editedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        i18n: freezed == i18n
            ? _self.i18n
            : i18n // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        latestReactions: freezed == latestReactions
            ? _self.latestReactions
            : latestReactions // ignore: cast_nullable_to_non_nullable
                  as List<FeedsReactionResponse>?,
        mentionedUsers: null == mentionedUsers
            ? _self.mentionedUsers
            : mentionedUsers // ignore: cast_nullable_to_non_nullable
                  as List<UserResponse>,
        moderation: freezed == moderation
            ? _self.moderation
            : moderation // ignore: cast_nullable_to_non_nullable
                  as ModerationV2Response?,
        objectId: null == objectId
            ? _self.objectId
            : objectId // ignore: cast_nullable_to_non_nullable
                  as String,
        objectType: null == objectType
            ? _self.objectType
            : objectType // ignore: cast_nullable_to_non_nullable
                  as String,
        ownReactions: null == ownReactions
            ? _self.ownReactions
            : ownReactions // ignore: cast_nullable_to_non_nullable
                  as List<FeedsReactionResponse>,
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        reactionCount: null == reactionCount
            ? _self.reactionCount
            : reactionCount // ignore: cast_nullable_to_non_nullable
                  as int,
        reactionGroups: freezed == reactionGroups
            ? _self.reactionGroups
            : reactionGroups // ignore: cast_nullable_to_non_nullable
                  as Map<String, FeedsReactionGroupResponse>?,
        replyCount: null == replyCount
            ? _self.replyCount
            : replyCount // ignore: cast_nullable_to_non_nullable
                  as int,
        score: null == score
            ? _self.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        text: freezed == text
            ? _self.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        upvoteCount: null == upvoteCount
            ? _self.upvoteCount
            : upvoteCount // ignore: cast_nullable_to_non_nullable
                  as int,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse,
      ),
    );
  }
}
