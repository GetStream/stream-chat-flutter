// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feeds_feed_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedsFeedResponse {
  int get activityCount;
  DateTime get createdAt;
  UserResponse get createdBy;
  Map<String, Object?>? get custom;
  DateTime? get deletedAt;
  String get description;
  String get feed;
  List<String>? get filterTags;
  int get followerCount;
  int get followingCount;
  String get groupId;
  String get id;
  FeedsActivityLocation? get location;
  int get memberCount;
  String get name;
  int get pinCount;
  DateTime get updatedAt;
  String? get visibility;

  /// Create a copy of FeedsFeedResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedsFeedResponseCopyWith<FeedsFeedResponse> get copyWith =>
      _$FeedsFeedResponseCopyWithImpl<FeedsFeedResponse>(
        this as FeedsFeedResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedsFeedResponse &&
            (identical(other.activityCount, activityCount) ||
                other.activityCount == activityCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.feed, feed) || other.feed == feed) &&
            const DeepCollectionEquality().equals(
              other.filterTags,
              filterTags,
            ) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.pinCount, pinCount) ||
                other.pinCount == pinCount) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    activityCount,
    createdAt,
    createdBy,
    const DeepCollectionEquality().hash(custom),
    deletedAt,
    description,
    feed,
    const DeepCollectionEquality().hash(filterTags),
    followerCount,
    followingCount,
    groupId,
    id,
    location,
    memberCount,
    name,
    pinCount,
    updatedAt,
    visibility,
  );

  @override
  String toString() {
    return 'FeedsFeedResponse(activityCount: $activityCount, createdAt: $createdAt, createdBy: $createdBy, custom: $custom, deletedAt: $deletedAt, description: $description, feed: $feed, filterTags: $filterTags, followerCount: $followerCount, followingCount: $followingCount, groupId: $groupId, id: $id, location: $location, memberCount: $memberCount, name: $name, pinCount: $pinCount, updatedAt: $updatedAt, visibility: $visibility)';
  }
}

/// @nodoc
abstract mixin class $FeedsFeedResponseCopyWith<$Res> {
  factory $FeedsFeedResponseCopyWith(
    FeedsFeedResponse value,
    $Res Function(FeedsFeedResponse) _then,
  ) = _$FeedsFeedResponseCopyWithImpl;
  @useResult
  $Res call({
    int activityCount,
    DateTime createdAt,
    UserResponse createdBy,
    Map<String, Object?>? custom,
    DateTime? deletedAt,
    String description,
    String feed,
    List<String>? filterTags,
    int followerCount,
    int followingCount,
    String groupId,
    String id,
    FeedsActivityLocation? location,
    int memberCount,
    String name,
    int pinCount,
    DateTime updatedAt,
    String? visibility,
  });
}

/// @nodoc
class _$FeedsFeedResponseCopyWithImpl<$Res>
    implements $FeedsFeedResponseCopyWith<$Res> {
  _$FeedsFeedResponseCopyWithImpl(this._self, this._then);

  final FeedsFeedResponse _self;
  final $Res Function(FeedsFeedResponse) _then;

  /// Create a copy of FeedsFeedResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityCount = null,
    Object? createdAt = null,
    Object? createdBy = null,
    Object? custom = freezed,
    Object? deletedAt = freezed,
    Object? description = null,
    Object? feed = null,
    Object? filterTags = freezed,
    Object? followerCount = null,
    Object? followingCount = null,
    Object? groupId = null,
    Object? id = null,
    Object? location = freezed,
    Object? memberCount = null,
    Object? name = null,
    Object? pinCount = null,
    Object? updatedAt = null,
    Object? visibility = freezed,
  }) {
    return _then(
      FeedsFeedResponse(
        activityCount: null == activityCount
            ? _self.activityCount
            : activityCount // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: null == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserResponse,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        deletedAt: freezed == deletedAt
            ? _self.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        description: null == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        feed: null == feed
            ? _self.feed
            : feed // ignore: cast_nullable_to_non_nullable
                  as String,
        filterTags: freezed == filterTags
            ? _self.filterTags
            : filterTags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        followerCount: null == followerCount
            ? _self.followerCount
            : followerCount // ignore: cast_nullable_to_non_nullable
                  as int,
        followingCount: null == followingCount
            ? _self.followingCount
            : followingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        groupId: null == groupId
            ? _self.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        location: freezed == location
            ? _self.location
            : location // ignore: cast_nullable_to_non_nullable
                  as FeedsActivityLocation?,
        memberCount: null == memberCount
            ? _self.memberCount
            : memberCount // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        pinCount: null == pinCount
            ? _self.pinCount
            : pinCount // ignore: cast_nullable_to_non_nullable
                  as int,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        visibility: freezed == visibility
            ? _self.visibility
            : visibility // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
