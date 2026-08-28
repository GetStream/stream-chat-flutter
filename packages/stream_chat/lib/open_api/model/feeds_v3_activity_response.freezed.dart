// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feeds_v3_activity_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedsV3ActivityResponse {
  List<Attachment> get attachments;
  int get bookmarkCount;
  Map<String, FeedsEnrichedCollectionResponse> get collections;
  int get commentCount;
  List<FeedsV3CommentResponse> get comments;
  DateTime get createdAt;
  FeedsFeedResponse? get currentFeed;
  Map<String, Object?> get custom;
  DateTime? get deletedAt;
  DateTime? get editedAt;
  DateTime? get expiresAt;
  List<String> get feeds;
  List<String> get filterTags;
  int? get friendReactionCount;
  List<FeedsReactionResponse>? get friendReactions;
  bool get hidden;
  Map<String, String>? get i18n;
  String get id;
  List<String> get interestTags;
  bool? get isRead;
  bool? get isSeen;
  bool? get isWatched;
  List<FeedsReactionResponse> get latestReactions;
  List<FeedsShareResponse>? get latestShares;
  FeedsActivityLocation? get location;
  List<UserResponse> get mentionedUsers;
  Map<String, int>? get metrics;
  ModerationV2Response? get moderation;
  String? get moderationAction;
  FeedsNotificationContext? get notificationContext;
  List<FeedsBookmarkResponse> get ownBookmarks;
  List<FeedsReactionResponse> get ownReactions;
  FeedsV3ActivityResponse? get parent;
  PollResponseData? get poll;
  int get popularity;
  bool get preview;
  int get reactionCount;
  Map<String, FeedsReactionGroupResponse> get reactionGroups;
  String get restrictReplies;
  double get score;
  Map<String, Object?>? get scoreVars;
  Map<String, Object?> get searchData;
  String? get selectorSource;
  int get shareCount;
  String? get text;
  String get type;
  DateTime get updatedAt;
  UserResponse get user;
  String get visibility;
  String? get visibilityTag;

  /// Create a copy of FeedsV3ActivityResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedsV3ActivityResponseCopyWith<FeedsV3ActivityResponse> get copyWith =>
      _$FeedsV3ActivityResponseCopyWithImpl<FeedsV3ActivityResponse>(
        this as FeedsV3ActivityResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedsV3ActivityResponse &&
            const DeepCollectionEquality().equals(
              other.attachments,
              attachments,
            ) &&
            (identical(other.bookmarkCount, bookmarkCount) || other.bookmarkCount == bookmarkCount) &&
            const DeepCollectionEquality().equals(
              other.collections,
              collections,
            ) &&
            (identical(other.commentCount, commentCount) || other.commentCount == commentCount) &&
            const DeepCollectionEquality().equals(other.comments, comments) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.currentFeed, currentFeed) || other.currentFeed == currentFeed) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt) &&
            (identical(other.editedAt, editedAt) || other.editedAt == editedAt) &&
            (identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt) &&
            const DeepCollectionEquality().equals(other.feeds, feeds) &&
            const DeepCollectionEquality().equals(
              other.filterTags,
              filterTags,
            ) &&
            (identical(other.friendReactionCount, friendReactionCount) ||
                other.friendReactionCount == friendReactionCount) &&
            const DeepCollectionEquality().equals(
              other.friendReactions,
              friendReactions,
            ) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            const DeepCollectionEquality().equals(other.i18n, i18n) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other.interestTags,
              interestTags,
            ) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isSeen, isSeen) || other.isSeen == isSeen) &&
            (identical(other.isWatched, isWatched) || other.isWatched == isWatched) &&
            const DeepCollectionEquality().equals(
              other.latestReactions,
              latestReactions,
            ) &&
            const DeepCollectionEquality().equals(
              other.latestShares,
              latestShares,
            ) &&
            (identical(other.location, location) || other.location == location) &&
            const DeepCollectionEquality().equals(
              other.mentionedUsers,
              mentionedUsers,
            ) &&
            const DeepCollectionEquality().equals(other.metrics, metrics) &&
            (identical(other.moderation, moderation) || other.moderation == moderation) &&
            (identical(other.moderationAction, moderationAction) || other.moderationAction == moderationAction) &&
            (identical(other.notificationContext, notificationContext) ||
                other.notificationContext == notificationContext) &&
            const DeepCollectionEquality().equals(
              other.ownBookmarks,
              ownBookmarks,
            ) &&
            const DeepCollectionEquality().equals(
              other.ownReactions,
              ownReactions,
            ) &&
            (identical(other.parent, parent) || other.parent == parent) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.popularity, popularity) || other.popularity == popularity) &&
            (identical(other.preview, preview) || other.preview == preview) &&
            (identical(other.reactionCount, reactionCount) || other.reactionCount == reactionCount) &&
            const DeepCollectionEquality().equals(
              other.reactionGroups,
              reactionGroups,
            ) &&
            (identical(other.restrictReplies, restrictReplies) || other.restrictReplies == restrictReplies) &&
            (identical(other.score, score) || other.score == score) &&
            const DeepCollectionEquality().equals(other.scoreVars, scoreVars) &&
            const DeepCollectionEquality().equals(
              other.searchData,
              searchData,
            ) &&
            (identical(other.selectorSource, selectorSource) || other.selectorSource == selectorSource) &&
            (identical(other.shareCount, shareCount) || other.shareCount == shareCount) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.visibility, visibility) || other.visibility == visibility) &&
            (identical(other.visibilityTag, visibilityTag) || other.visibilityTag == visibilityTag));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    const DeepCollectionEquality().hash(attachments),
    bookmarkCount,
    const DeepCollectionEquality().hash(collections),
    commentCount,
    const DeepCollectionEquality().hash(comments),
    createdAt,
    currentFeed,
    const DeepCollectionEquality().hash(custom),
    deletedAt,
    editedAt,
    expiresAt,
    const DeepCollectionEquality().hash(feeds),
    const DeepCollectionEquality().hash(filterTags),
    friendReactionCount,
    const DeepCollectionEquality().hash(friendReactions),
    hidden,
    const DeepCollectionEquality().hash(i18n),
    id,
    const DeepCollectionEquality().hash(interestTags),
    isRead,
    isSeen,
    isWatched,
    const DeepCollectionEquality().hash(latestReactions),
    const DeepCollectionEquality().hash(latestShares),
    location,
    const DeepCollectionEquality().hash(mentionedUsers),
    const DeepCollectionEquality().hash(metrics),
    moderation,
    moderationAction,
    notificationContext,
    const DeepCollectionEquality().hash(ownBookmarks),
    const DeepCollectionEquality().hash(ownReactions),
    parent,
    poll,
    popularity,
    preview,
    reactionCount,
    const DeepCollectionEquality().hash(reactionGroups),
    restrictReplies,
    score,
    const DeepCollectionEquality().hash(scoreVars),
    const DeepCollectionEquality().hash(searchData),
    selectorSource,
    shareCount,
    text,
    type,
    updatedAt,
    user,
    visibility,
    visibilityTag,
  ]);

  @override
  String toString() {
    return 'FeedsV3ActivityResponse(attachments: $attachments, bookmarkCount: $bookmarkCount, collections: $collections, commentCount: $commentCount, comments: $comments, createdAt: $createdAt, currentFeed: $currentFeed, custom: $custom, deletedAt: $deletedAt, editedAt: $editedAt, expiresAt: $expiresAt, feeds: $feeds, filterTags: $filterTags, friendReactionCount: $friendReactionCount, friendReactions: $friendReactions, hidden: $hidden, i18n: $i18n, id: $id, interestTags: $interestTags, isRead: $isRead, isSeen: $isSeen, isWatched: $isWatched, latestReactions: $latestReactions, latestShares: $latestShares, location: $location, mentionedUsers: $mentionedUsers, metrics: $metrics, moderation: $moderation, moderationAction: $moderationAction, notificationContext: $notificationContext, ownBookmarks: $ownBookmarks, ownReactions: $ownReactions, parent: $parent, poll: $poll, popularity: $popularity, preview: $preview, reactionCount: $reactionCount, reactionGroups: $reactionGroups, restrictReplies: $restrictReplies, score: $score, scoreVars: $scoreVars, searchData: $searchData, selectorSource: $selectorSource, shareCount: $shareCount, text: $text, type: $type, updatedAt: $updatedAt, user: $user, visibility: $visibility, visibilityTag: $visibilityTag)';
  }
}

/// @nodoc
abstract mixin class $FeedsV3ActivityResponseCopyWith<$Res> {
  factory $FeedsV3ActivityResponseCopyWith(
    FeedsV3ActivityResponse value,
    $Res Function(FeedsV3ActivityResponse) _then,
  ) = _$FeedsV3ActivityResponseCopyWithImpl;
  @useResult
  $Res call({
    List<Attachment> attachments,
    int bookmarkCount,
    Map<String, FeedsEnrichedCollectionResponse> collections,
    int commentCount,
    List<FeedsV3CommentResponse> comments,
    DateTime createdAt,
    FeedsFeedResponse? currentFeed,
    Map<String, Object?> custom,
    DateTime? deletedAt,
    DateTime? editedAt,
    DateTime? expiresAt,
    List<String> feeds,
    List<String> filterTags,
    int? friendReactionCount,
    List<FeedsReactionResponse>? friendReactions,
    bool hidden,
    Map<String, String>? i18n,
    String id,
    List<String> interestTags,
    bool? isRead,
    bool? isSeen,
    bool? isWatched,
    List<FeedsReactionResponse> latestReactions,
    List<FeedsShareResponse>? latestShares,
    FeedsActivityLocation? location,
    List<UserResponse> mentionedUsers,
    Map<String, int>? metrics,
    ModerationV2Response? moderation,
    String? moderationAction,
    FeedsNotificationContext? notificationContext,
    List<FeedsBookmarkResponse> ownBookmarks,
    List<FeedsReactionResponse> ownReactions,
    FeedsV3ActivityResponse? parent,
    PollResponseData? poll,
    int popularity,
    bool preview,
    int reactionCount,
    Map<String, FeedsReactionGroupResponse> reactionGroups,
    String restrictReplies,
    double score,
    Map<String, Object?>? scoreVars,
    Map<String, Object?> searchData,
    String? selectorSource,
    int shareCount,
    String? text,
    String type,
    DateTime updatedAt,
    UserResponse user,
    String visibility,
    String? visibilityTag,
  });
}

/// @nodoc
class _$FeedsV3ActivityResponseCopyWithImpl<$Res> implements $FeedsV3ActivityResponseCopyWith<$Res> {
  _$FeedsV3ActivityResponseCopyWithImpl(this._self, this._then);

  final FeedsV3ActivityResponse _self;
  final $Res Function(FeedsV3ActivityResponse) _then;

  /// Create a copy of FeedsV3ActivityResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachments = null,
    Object? bookmarkCount = null,
    Object? collections = null,
    Object? commentCount = null,
    Object? comments = null,
    Object? createdAt = null,
    Object? currentFeed = freezed,
    Object? custom = null,
    Object? deletedAt = freezed,
    Object? editedAt = freezed,
    Object? expiresAt = freezed,
    Object? feeds = null,
    Object? filterTags = null,
    Object? friendReactionCount = freezed,
    Object? friendReactions = freezed,
    Object? hidden = null,
    Object? i18n = freezed,
    Object? id = null,
    Object? interestTags = null,
    Object? isRead = freezed,
    Object? isSeen = freezed,
    Object? isWatched = freezed,
    Object? latestReactions = null,
    Object? latestShares = freezed,
    Object? location = freezed,
    Object? mentionedUsers = null,
    Object? metrics = freezed,
    Object? moderation = freezed,
    Object? moderationAction = freezed,
    Object? notificationContext = freezed,
    Object? ownBookmarks = null,
    Object? ownReactions = null,
    Object? parent = freezed,
    Object? poll = freezed,
    Object? popularity = null,
    Object? preview = null,
    Object? reactionCount = null,
    Object? reactionGroups = null,
    Object? restrictReplies = null,
    Object? score = null,
    Object? scoreVars = freezed,
    Object? searchData = null,
    Object? selectorSource = freezed,
    Object? shareCount = null,
    Object? text = freezed,
    Object? type = null,
    Object? updatedAt = null,
    Object? user = null,
    Object? visibility = null,
    Object? visibilityTag = freezed,
  }) {
    return _then(
      FeedsV3ActivityResponse(
        attachments: null == attachments
            ? _self.attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<Attachment>,
        bookmarkCount: null == bookmarkCount
            ? _self.bookmarkCount
            : bookmarkCount // ignore: cast_nullable_to_non_nullable
                  as int,
        collections: null == collections
            ? _self.collections
            : collections // ignore: cast_nullable_to_non_nullable
                  as Map<String, FeedsEnrichedCollectionResponse>,
        commentCount: null == commentCount
            ? _self.commentCount
            : commentCount // ignore: cast_nullable_to_non_nullable
                  as int,
        comments: null == comments
            ? _self.comments
            : comments // ignore: cast_nullable_to_non_nullable
                  as List<FeedsV3CommentResponse>,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        currentFeed: freezed == currentFeed
            ? _self.currentFeed
            : currentFeed // ignore: cast_nullable_to_non_nullable
                  as FeedsFeedResponse?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        deletedAt: freezed == deletedAt
            ? _self.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        editedAt: freezed == editedAt
            ? _self.editedAt
            : editedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        expiresAt: freezed == expiresAt
            ? _self.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        feeds: null == feeds
            ? _self.feeds
            : feeds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        filterTags: null == filterTags
            ? _self.filterTags
            : filterTags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        friendReactionCount: freezed == friendReactionCount
            ? _self.friendReactionCount
            : friendReactionCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        friendReactions: freezed == friendReactions
            ? _self.friendReactions
            : friendReactions // ignore: cast_nullable_to_non_nullable
                  as List<FeedsReactionResponse>?,
        hidden: null == hidden
            ? _self.hidden
            : hidden // ignore: cast_nullable_to_non_nullable
                  as bool,
        i18n: freezed == i18n
            ? _self.i18n
            : i18n // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        interestTags: null == interestTags
            ? _self.interestTags
            : interestTags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isRead: freezed == isRead
            ? _self.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isSeen: freezed == isSeen
            ? _self.isSeen
            : isSeen // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isWatched: freezed == isWatched
            ? _self.isWatched
            : isWatched // ignore: cast_nullable_to_non_nullable
                  as bool?,
        latestReactions: null == latestReactions
            ? _self.latestReactions
            : latestReactions // ignore: cast_nullable_to_non_nullable
                  as List<FeedsReactionResponse>,
        latestShares: freezed == latestShares
            ? _self.latestShares
            : latestShares // ignore: cast_nullable_to_non_nullable
                  as List<FeedsShareResponse>?,
        location: freezed == location
            ? _self.location
            : location // ignore: cast_nullable_to_non_nullable
                  as FeedsActivityLocation?,
        mentionedUsers: null == mentionedUsers
            ? _self.mentionedUsers
            : mentionedUsers // ignore: cast_nullable_to_non_nullable
                  as List<UserResponse>,
        metrics: freezed == metrics
            ? _self.metrics
            : metrics // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
        moderation: freezed == moderation
            ? _self.moderation
            : moderation // ignore: cast_nullable_to_non_nullable
                  as ModerationV2Response?,
        moderationAction: freezed == moderationAction
            ? _self.moderationAction
            : moderationAction // ignore: cast_nullable_to_non_nullable
                  as String?,
        notificationContext: freezed == notificationContext
            ? _self.notificationContext
            : notificationContext // ignore: cast_nullable_to_non_nullable
                  as FeedsNotificationContext?,
        ownBookmarks: null == ownBookmarks
            ? _self.ownBookmarks
            : ownBookmarks // ignore: cast_nullable_to_non_nullable
                  as List<FeedsBookmarkResponse>,
        ownReactions: null == ownReactions
            ? _self.ownReactions
            : ownReactions // ignore: cast_nullable_to_non_nullable
                  as List<FeedsReactionResponse>,
        parent: freezed == parent
            ? _self.parent
            : parent // ignore: cast_nullable_to_non_nullable
                  as FeedsV3ActivityResponse?,
        poll: freezed == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as PollResponseData?,
        popularity: null == popularity
            ? _self.popularity
            : popularity // ignore: cast_nullable_to_non_nullable
                  as int,
        preview: null == preview
            ? _self.preview
            : preview // ignore: cast_nullable_to_non_nullable
                  as bool,
        reactionCount: null == reactionCount
            ? _self.reactionCount
            : reactionCount // ignore: cast_nullable_to_non_nullable
                  as int,
        reactionGroups: null == reactionGroups
            ? _self.reactionGroups
            : reactionGroups // ignore: cast_nullable_to_non_nullable
                  as Map<String, FeedsReactionGroupResponse>,
        restrictReplies: null == restrictReplies
            ? _self.restrictReplies
            : restrictReplies // ignore: cast_nullable_to_non_nullable
                  as String,
        score: null == score
            ? _self.score
            : score // ignore: cast_nullable_to_non_nullable
                  as double,
        scoreVars: freezed == scoreVars
            ? _self.scoreVars
            : scoreVars // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        searchData: null == searchData
            ? _self.searchData
            : searchData // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        selectorSource: freezed == selectorSource
            ? _self.selectorSource
            : selectorSource // ignore: cast_nullable_to_non_nullable
                  as String?,
        shareCount: null == shareCount
            ? _self.shareCount
            : shareCount // ignore: cast_nullable_to_non_nullable
                  as int,
        text: freezed == text
            ? _self.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse,
        visibility: null == visibility
            ? _self.visibility
            : visibility // ignore: cast_nullable_to_non_nullable
                  as String,
        visibilityTag: freezed == visibilityTag
            ? _self.visibilityTag
            : visibilityTag // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
