// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'stream_chat_analytics_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

StreamChatAnalyticsEvent _$StreamChatAnalyticsEventFromJson(
    Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'channelListView':
      return StreamChannelListViewEventModel.fromJson(json);
    case 'channelListTileClick':
      return StreamChannelListTileClickEventModel.fromJson(json);
    case 'channelListTileAvatarClick':
      return StreamChannelListTileAvatarClickEventModel.fromJson(json);
    case 'messageInputFocus':
      return StreamMessageInputFocusEventModel.fromJson(json);
    case 'messageInputTypingStarted':
      return StreamMessageInputTypingStartedEventModel.fromJson(json);
    case 'messageInputSendButtonClick':
      return StreamMessageInputSendButtonClickEventModel.fromJson(json);
    case 'messageInputAttachmentButtonClick':
      return StreamMessageInputAttachmentButtonClickEventModel.fromJson(json);
    case 'messageInputCommandButtonClick':
      return StreamMessageInputCommandButtonClickEventModel.fromJson(json);
    case 'messageInputAttachmentActionClick':
      return StreamMessageInputAttachmentActionClickEventModel.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json,
          'runtimeType',
          'StreamChatAnalyticsEvent',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$StreamChatAnalyticsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreamChatAnalyticsEventCopyWith<$Res> {
  factory $StreamChatAnalyticsEventCopyWith(StreamChatAnalyticsEvent value,
          $Res Function(StreamChatAnalyticsEvent) then) =
      _$StreamChatAnalyticsEventCopyWithImpl<$Res>;
}

/// @nodoc
class _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements $StreamChatAnalyticsEventCopyWith<$Res> {
  _$StreamChatAnalyticsEventCopyWithImpl(this._value, this._then);

  final StreamChatAnalyticsEvent _value;
  // ignore: unused_field
  final $Res Function(StreamChatAnalyticsEvent) _then;
}

/// @nodoc
abstract class _$$StreamChannelListViewEventModelCopyWith<$Res> {
  factory _$$StreamChannelListViewEventModelCopyWith(
          _$StreamChannelListViewEventModel value,
          $Res Function(_$StreamChannelListViewEventModel) then) =
      __$$StreamChannelListViewEventModelCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StreamChannelListViewEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamChannelListViewEventModelCopyWith<$Res> {
  __$$StreamChannelListViewEventModelCopyWithImpl(
      _$StreamChannelListViewEventModel _value,
      $Res Function(_$StreamChannelListViewEventModel) _then)
      : super(_value, (v) => _then(v as _$StreamChannelListViewEventModel));

  @override
  _$StreamChannelListViewEventModel get _value =>
      super._value as _$StreamChannelListViewEventModel;
}

/// @nodoc
@JsonSerializable()
class _$StreamChannelListViewEventModel
    implements StreamChannelListViewEventModel {
  const _$StreamChannelListViewEventModel({final String? $type})
      : $type = $type ?? 'channelListView';

  factory _$StreamChannelListViewEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamChannelListViewEventModelFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.channelListView()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamChannelListViewEventModel);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
  }) {
    return channelListView();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
  }) {
    return channelListView?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (channelListView != null) {
      return channelListView();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
  }) {
    return channelListView(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
  }) {
    return channelListView?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (channelListView != null) {
      return channelListView(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamChannelListViewEventModelToJson(this);
  }
}

abstract class StreamChannelListViewEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamChannelListViewEventModel() =
      _$StreamChannelListViewEventModel;

  factory StreamChannelListViewEventModel.fromJson(Map<String, dynamic> json) =
      _$StreamChannelListViewEventModel.fromJson;
}

/// @nodoc
abstract class _$$StreamChannelListTileClickEventModelCopyWith<$Res> {
  factory _$$StreamChannelListTileClickEventModelCopyWith(
          _$StreamChannelListTileClickEventModel value,
          $Res Function(_$StreamChannelListTileClickEventModel) then) =
      __$$StreamChannelListTileClickEventModelCopyWithImpl<$Res>;
  $Res call({String channelId, int unreadMessageCount});
}

/// @nodoc
class __$$StreamChannelListTileClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamChannelListTileClickEventModelCopyWith<$Res> {
  __$$StreamChannelListTileClickEventModelCopyWithImpl(
      _$StreamChannelListTileClickEventModel _value,
      $Res Function(_$StreamChannelListTileClickEventModel) _then)
      : super(
            _value, (v) => _then(v as _$StreamChannelListTileClickEventModel));

  @override
  _$StreamChannelListTileClickEventModel get _value =>
      super._value as _$StreamChannelListTileClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? unreadMessageCount = freezed,
  }) {
    return _then(_$StreamChannelListTileClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      unreadMessageCount: unreadMessageCount == freezed
          ? _value.unreadMessageCount
          : unreadMessageCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamChannelListTileClickEventModel
    implements StreamChannelListTileClickEventModel {
  const _$StreamChannelListTileClickEventModel(
      {required this.channelId,
      required this.unreadMessageCount,
      final String? $type})
      : $type = $type ?? 'channelListTileClick';

  factory _$StreamChannelListTileClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamChannelListTileClickEventModelFromJson(json);

  /// The id of the channel that was clicked
  @override
  final String channelId;

  /// The number of unread messages at the moment
  @override
  final int unreadMessageCount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.channelListTileClick(channelId: $channelId, unreadMessageCount: $unreadMessageCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamChannelListTileClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality()
                .equals(other.unreadMessageCount, unreadMessageCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(unreadMessageCount));

  @JsonKey(ignore: true)
  @override
  _$$StreamChannelListTileClickEventModelCopyWith<
          _$StreamChannelListTileClickEventModel>
      get copyWith => __$$StreamChannelListTileClickEventModelCopyWithImpl<
          _$StreamChannelListTileClickEventModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
  }) {
    return channelListTileClick(channelId, unreadMessageCount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
  }) {
    return channelListTileClick?.call(channelId, unreadMessageCount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (channelListTileClick != null) {
      return channelListTileClick(channelId, unreadMessageCount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
  }) {
    return channelListTileClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
  }) {
    return channelListTileClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (channelListTileClick != null) {
      return channelListTileClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamChannelListTileClickEventModelToJson(this);
  }
}

abstract class StreamChannelListTileClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamChannelListTileClickEventModel(
          {required final String channelId,
          required final int unreadMessageCount}) =
      _$StreamChannelListTileClickEventModel;

  factory StreamChannelListTileClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamChannelListTileClickEventModel.fromJson;

  /// The id of the channel that was clicked
  String get channelId => throw _privateConstructorUsedError;

  /// The number of unread messages at the moment
  int get unreadMessageCount => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$$StreamChannelListTileClickEventModelCopyWith<
          _$StreamChannelListTileClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamChannelListTileAvatarClickEventModelCopyWith<$Res> {
  factory _$$StreamChannelListTileAvatarClickEventModelCopyWith(
          _$StreamChannelListTileAvatarClickEventModel value,
          $Res Function(_$StreamChannelListTileAvatarClickEventModel) then) =
      __$$StreamChannelListTileAvatarClickEventModelCopyWithImpl<$Res>;
  $Res call({String channelId, int unreadMessageCount});
}

/// @nodoc
class __$$StreamChannelListTileAvatarClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamChannelListTileAvatarClickEventModelCopyWith<$Res> {
  __$$StreamChannelListTileAvatarClickEventModelCopyWithImpl(
      _$StreamChannelListTileAvatarClickEventModel _value,
      $Res Function(_$StreamChannelListTileAvatarClickEventModel) _then)
      : super(_value,
            (v) => _then(v as _$StreamChannelListTileAvatarClickEventModel));

  @override
  _$StreamChannelListTileAvatarClickEventModel get _value =>
      super._value as _$StreamChannelListTileAvatarClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? unreadMessageCount = freezed,
  }) {
    return _then(_$StreamChannelListTileAvatarClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      unreadMessageCount: unreadMessageCount == freezed
          ? _value.unreadMessageCount
          : unreadMessageCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamChannelListTileAvatarClickEventModel
    implements StreamChannelListTileAvatarClickEventModel {
  const _$StreamChannelListTileAvatarClickEventModel(
      {required this.channelId,
      required this.unreadMessageCount,
      final String? $type})
      : $type = $type ?? 'channelListTileAvatarClick';

  factory _$StreamChannelListTileAvatarClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamChannelListTileAvatarClickEventModelFromJson(json);

  /// The id of the channel that was clicked
  @override
  final String channelId;

  /// The number of unread messages at the moment
  @override
  final int unreadMessageCount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.channelListTileAvatarClick(channelId: $channelId, unreadMessageCount: $unreadMessageCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamChannelListTileAvatarClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality()
                .equals(other.unreadMessageCount, unreadMessageCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(unreadMessageCount));

  @JsonKey(ignore: true)
  @override
  _$$StreamChannelListTileAvatarClickEventModelCopyWith<
          _$StreamChannelListTileAvatarClickEventModel>
      get copyWith =>
          __$$StreamChannelListTileAvatarClickEventModelCopyWithImpl<
              _$StreamChannelListTileAvatarClickEventModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
  }) {
    return channelListTileAvatarClick(channelId, unreadMessageCount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
  }) {
    return channelListTileAvatarClick?.call(channelId, unreadMessageCount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (channelListTileAvatarClick != null) {
      return channelListTileAvatarClick(channelId, unreadMessageCount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
  }) {
    return channelListTileAvatarClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
  }) {
    return channelListTileAvatarClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (channelListTileAvatarClick != null) {
      return channelListTileAvatarClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamChannelListTileAvatarClickEventModelToJson(this);
  }
}

abstract class StreamChannelListTileAvatarClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamChannelListTileAvatarClickEventModel(
          {required final String channelId,
          required final int unreadMessageCount}) =
      _$StreamChannelListTileAvatarClickEventModel;

  factory StreamChannelListTileAvatarClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamChannelListTileAvatarClickEventModel.fromJson;

  /// The id of the channel that was clicked
  String get channelId => throw _privateConstructorUsedError;

  /// The number of unread messages at the moment
  int get unreadMessageCount => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$$StreamChannelListTileAvatarClickEventModelCopyWith<
          _$StreamChannelListTileAvatarClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamMessageInputFocusEventModelCopyWith<$Res> {
  factory _$$StreamMessageInputFocusEventModelCopyWith(
          _$StreamMessageInputFocusEventModel value,
          $Res Function(_$StreamMessageInputFocusEventModel) then) =
      __$$StreamMessageInputFocusEventModelCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StreamMessageInputFocusEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamMessageInputFocusEventModelCopyWith<$Res> {
  __$$StreamMessageInputFocusEventModelCopyWithImpl(
      _$StreamMessageInputFocusEventModel _value,
      $Res Function(_$StreamMessageInputFocusEventModel) _then)
      : super(_value, (v) => _then(v as _$StreamMessageInputFocusEventModel));

  @override
  _$StreamMessageInputFocusEventModel get _value =>
      super._value as _$StreamMessageInputFocusEventModel;
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageInputFocusEventModel
    implements StreamMessageInputFocusEventModel {
  const _$StreamMessageInputFocusEventModel({final String? $type})
      : $type = $type ?? 'messageInputFocus';

  factory _$StreamMessageInputFocusEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageInputFocusEventModelFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageInputFocus()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageInputFocusEventModel);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
  }) {
    return messageInputFocus();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
  }) {
    return messageInputFocus?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (messageInputFocus != null) {
      return messageInputFocus();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
  }) {
    return messageInputFocus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
  }) {
    return messageInputFocus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (messageInputFocus != null) {
      return messageInputFocus(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageInputFocusEventModelToJson(this);
  }
}

abstract class StreamMessageInputFocusEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageInputFocusEventModel() =
      _$StreamMessageInputFocusEventModel;

  factory StreamMessageInputFocusEventModel.fromJson(
      Map<String, dynamic> json) = _$StreamMessageInputFocusEventModel.fromJson;
}

/// @nodoc
abstract class _$$StreamMessageInputTypingStartedEventModelCopyWith<$Res> {
  factory _$$StreamMessageInputTypingStartedEventModelCopyWith(
          _$StreamMessageInputTypingStartedEventModel value,
          $Res Function(_$StreamMessageInputTypingStartedEventModel) then) =
      __$$StreamMessageInputTypingStartedEventModelCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StreamMessageInputTypingStartedEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamMessageInputTypingStartedEventModelCopyWith<$Res> {
  __$$StreamMessageInputTypingStartedEventModelCopyWithImpl(
      _$StreamMessageInputTypingStartedEventModel _value,
      $Res Function(_$StreamMessageInputTypingStartedEventModel) _then)
      : super(_value,
            (v) => _then(v as _$StreamMessageInputTypingStartedEventModel));

  @override
  _$StreamMessageInputTypingStartedEventModel get _value =>
      super._value as _$StreamMessageInputTypingStartedEventModel;
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageInputTypingStartedEventModel
    implements StreamMessageInputTypingStartedEventModel {
  const _$StreamMessageInputTypingStartedEventModel({final String? $type})
      : $type = $type ?? 'messageInputTypingStarted';

  factory _$StreamMessageInputTypingStartedEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageInputTypingStartedEventModelFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageInputTypingStarted()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageInputTypingStartedEventModel);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
  }) {
    return messageInputTypingStarted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
  }) {
    return messageInputTypingStarted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (messageInputTypingStarted != null) {
      return messageInputTypingStarted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
  }) {
    return messageInputTypingStarted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
  }) {
    return messageInputTypingStarted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (messageInputTypingStarted != null) {
      return messageInputTypingStarted(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageInputTypingStartedEventModelToJson(this);
  }
}

abstract class StreamMessageInputTypingStartedEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageInputTypingStartedEventModel() =
      _$StreamMessageInputTypingStartedEventModel;

  factory StreamMessageInputTypingStartedEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamMessageInputTypingStartedEventModel.fromJson;
}

/// @nodoc
abstract class _$$StreamMessageInputSendButtonClickEventModelCopyWith<$Res> {
  factory _$$StreamMessageInputSendButtonClickEventModelCopyWith(
          _$StreamMessageInputSendButtonClickEventModel value,
          $Res Function(_$StreamMessageInputSendButtonClickEventModel) then) =
      __$$StreamMessageInputSendButtonClickEventModelCopyWithImpl<$Res>;
  $Res call(
      {bool hasText,
      bool hasAttachments,
      bool hasMentions,
      bool hasCustomCommands});
}

/// @nodoc
class __$$StreamMessageInputSendButtonClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamMessageInputSendButtonClickEventModelCopyWith<$Res> {
  __$$StreamMessageInputSendButtonClickEventModelCopyWithImpl(
      _$StreamMessageInputSendButtonClickEventModel _value,
      $Res Function(_$StreamMessageInputSendButtonClickEventModel) _then)
      : super(_value,
            (v) => _then(v as _$StreamMessageInputSendButtonClickEventModel));

  @override
  _$StreamMessageInputSendButtonClickEventModel get _value =>
      super._value as _$StreamMessageInputSendButtonClickEventModel;

  @override
  $Res call({
    Object? hasText = freezed,
    Object? hasAttachments = freezed,
    Object? hasMentions = freezed,
    Object? hasCustomCommands = freezed,
  }) {
    return _then(_$StreamMessageInputSendButtonClickEventModel(
      hasText: hasText == freezed
          ? _value.hasText
          : hasText // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAttachments: hasAttachments == freezed
          ? _value.hasAttachments
          : hasAttachments // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMentions: hasMentions == freezed
          ? _value.hasMentions
          : hasMentions // ignore: cast_nullable_to_non_nullable
              as bool,
      hasCustomCommands: hasCustomCommands == freezed
          ? _value.hasCustomCommands
          : hasCustomCommands // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageInputSendButtonClickEventModel
    implements StreamMessageInputSendButtonClickEventModel {
  const _$StreamMessageInputSendButtonClickEventModel(
      {required this.hasText,
      required this.hasAttachments,
      required this.hasMentions,
      required this.hasCustomCommands,
      final String? $type})
      : $type = $type ?? 'messageInputSendButtonClick';

  factory _$StreamMessageInputSendButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageInputSendButtonClickEventModelFromJson(json);

  /// Does the message being sent have text?
  @override
  final bool hasText;

  /// Does the message being sent have attachments?
  @override
  final bool hasAttachments;

  /// Does the message being sent have user mentions?
  @override
  final bool hasMentions;

  /// Does the message being sent have custom commands?
  @override
  final bool hasCustomCommands;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageInputSendButtonClick(hasText: $hasText, hasAttachments: $hasAttachments, hasMentions: $hasMentions, hasCustomCommands: $hasCustomCommands)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageInputSendButtonClickEventModel &&
            const DeepCollectionEquality().equals(other.hasText, hasText) &&
            const DeepCollectionEquality()
                .equals(other.hasAttachments, hasAttachments) &&
            const DeepCollectionEquality()
                .equals(other.hasMentions, hasMentions) &&
            const DeepCollectionEquality()
                .equals(other.hasCustomCommands, hasCustomCommands));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(hasText),
      const DeepCollectionEquality().hash(hasAttachments),
      const DeepCollectionEquality().hash(hasMentions),
      const DeepCollectionEquality().hash(hasCustomCommands));

  @JsonKey(ignore: true)
  @override
  _$$StreamMessageInputSendButtonClickEventModelCopyWith<
          _$StreamMessageInputSendButtonClickEventModel>
      get copyWith =>
          __$$StreamMessageInputSendButtonClickEventModelCopyWithImpl<
              _$StreamMessageInputSendButtonClickEventModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
  }) {
    return messageInputSendButtonClick(
        hasText, hasAttachments, hasMentions, hasCustomCommands);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
  }) {
    return messageInputSendButtonClick?.call(
        hasText, hasAttachments, hasMentions, hasCustomCommands);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (messageInputSendButtonClick != null) {
      return messageInputSendButtonClick(
          hasText, hasAttachments, hasMentions, hasCustomCommands);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
  }) {
    return messageInputSendButtonClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
  }) {
    return messageInputSendButtonClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (messageInputSendButtonClick != null) {
      return messageInputSendButtonClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageInputSendButtonClickEventModelToJson(this);
  }
}

abstract class StreamMessageInputSendButtonClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageInputSendButtonClickEventModel(
          {required final bool hasText,
          required final bool hasAttachments,
          required final bool hasMentions,
          required final bool hasCustomCommands}) =
      _$StreamMessageInputSendButtonClickEventModel;

  factory StreamMessageInputSendButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamMessageInputSendButtonClickEventModel.fromJson;

  /// Does the message being sent have text?
  bool get hasText => throw _privateConstructorUsedError;

  /// Does the message being sent have attachments?
  bool get hasAttachments => throw _privateConstructorUsedError;

  /// Does the message being sent have user mentions?
  bool get hasMentions => throw _privateConstructorUsedError;

  /// Does the message being sent have custom commands?
  bool get hasCustomCommands => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$$StreamMessageInputSendButtonClickEventModelCopyWith<
          _$StreamMessageInputSendButtonClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamMessageInputAttachmentButtonClickEventModelCopyWith<
    $Res> {
  factory _$$StreamMessageInputAttachmentButtonClickEventModelCopyWith(
          _$StreamMessageInputAttachmentButtonClickEventModel value,
          $Res Function(_$StreamMessageInputAttachmentButtonClickEventModel)
              then) =
      __$$StreamMessageInputAttachmentButtonClickEventModelCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StreamMessageInputAttachmentButtonClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements
        _$$StreamMessageInputAttachmentButtonClickEventModelCopyWith<$Res> {
  __$$StreamMessageInputAttachmentButtonClickEventModelCopyWithImpl(
      _$StreamMessageInputAttachmentButtonClickEventModel _value,
      $Res Function(_$StreamMessageInputAttachmentButtonClickEventModel) _then)
      : super(
            _value,
            (v) => _then(
                v as _$StreamMessageInputAttachmentButtonClickEventModel));

  @override
  _$StreamMessageInputAttachmentButtonClickEventModel get _value =>
      super._value as _$StreamMessageInputAttachmentButtonClickEventModel;
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageInputAttachmentButtonClickEventModel
    implements StreamMessageInputAttachmentButtonClickEventModel {
  const _$StreamMessageInputAttachmentButtonClickEventModel(
      {final String? $type})
      : $type = $type ?? 'messageInputAttachmentButtonClick';

  factory _$StreamMessageInputAttachmentButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageInputAttachmentButtonClickEventModelFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageInputAttachmentButtonClick()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageInputAttachmentButtonClickEventModel);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
  }) {
    return messageInputAttachmentButtonClick();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
  }) {
    return messageInputAttachmentButtonClick?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (messageInputAttachmentButtonClick != null) {
      return messageInputAttachmentButtonClick();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
  }) {
    return messageInputAttachmentButtonClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
  }) {
    return messageInputAttachmentButtonClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (messageInputAttachmentButtonClick != null) {
      return messageInputAttachmentButtonClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageInputAttachmentButtonClickEventModelToJson(this);
  }
}

abstract class StreamMessageInputAttachmentButtonClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageInputAttachmentButtonClickEventModel() =
      _$StreamMessageInputAttachmentButtonClickEventModel;

  factory StreamMessageInputAttachmentButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamMessageInputAttachmentButtonClickEventModel.fromJson;
}

/// @nodoc
abstract class _$$StreamMessageInputCommandButtonClickEventModelCopyWith<$Res> {
  factory _$$StreamMessageInputCommandButtonClickEventModelCopyWith(
          _$StreamMessageInputCommandButtonClickEventModel value,
          $Res Function(_$StreamMessageInputCommandButtonClickEventModel)
              then) =
      __$$StreamMessageInputCommandButtonClickEventModelCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StreamMessageInputCommandButtonClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamMessageInputCommandButtonClickEventModelCopyWith<$Res> {
  __$$StreamMessageInputCommandButtonClickEventModelCopyWithImpl(
      _$StreamMessageInputCommandButtonClickEventModel _value,
      $Res Function(_$StreamMessageInputCommandButtonClickEventModel) _then)
      : super(
            _value,
            (v) =>
                _then(v as _$StreamMessageInputCommandButtonClickEventModel));

  @override
  _$StreamMessageInputCommandButtonClickEventModel get _value =>
      super._value as _$StreamMessageInputCommandButtonClickEventModel;
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageInputCommandButtonClickEventModel
    implements StreamMessageInputCommandButtonClickEventModel {
  const _$StreamMessageInputCommandButtonClickEventModel({final String? $type})
      : $type = $type ?? 'messageInputCommandButtonClick';

  factory _$StreamMessageInputCommandButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageInputCommandButtonClickEventModelFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageInputCommandButtonClick()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageInputCommandButtonClickEventModel);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
  }) {
    return messageInputCommandButtonClick();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
  }) {
    return messageInputCommandButtonClick?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (messageInputCommandButtonClick != null) {
      return messageInputCommandButtonClick();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
  }) {
    return messageInputCommandButtonClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
  }) {
    return messageInputCommandButtonClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (messageInputCommandButtonClick != null) {
      return messageInputCommandButtonClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageInputCommandButtonClickEventModelToJson(this);
  }
}

abstract class StreamMessageInputCommandButtonClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageInputCommandButtonClickEventModel() =
      _$StreamMessageInputCommandButtonClickEventModel;

  factory StreamMessageInputCommandButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamMessageInputCommandButtonClickEventModel.fromJson;
}

/// @nodoc
abstract class _$$StreamMessageInputAttachmentActionClickEventModelCopyWith<
    $Res> {
  factory _$$StreamMessageInputAttachmentActionClickEventModelCopyWith(
          _$StreamMessageInputAttachmentActionClickEventModel value,
          $Res Function(_$StreamMessageInputAttachmentActionClickEventModel)
              then) =
      __$$StreamMessageInputAttachmentActionClickEventModelCopyWithImpl<$Res>;
  $Res call({StreamMessageInputAttachmentActionType targetActionType});
}

/// @nodoc
class __$$StreamMessageInputAttachmentActionClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements
        _$$StreamMessageInputAttachmentActionClickEventModelCopyWith<$Res> {
  __$$StreamMessageInputAttachmentActionClickEventModelCopyWithImpl(
      _$StreamMessageInputAttachmentActionClickEventModel _value,
      $Res Function(_$StreamMessageInputAttachmentActionClickEventModel) _then)
      : super(
            _value,
            (v) => _then(
                v as _$StreamMessageInputAttachmentActionClickEventModel));

  @override
  _$StreamMessageInputAttachmentActionClickEventModel get _value =>
      super._value as _$StreamMessageInputAttachmentActionClickEventModel;

  @override
  $Res call({
    Object? targetActionType = freezed,
  }) {
    return _then(_$StreamMessageInputAttachmentActionClickEventModel(
      targetActionType: targetActionType == freezed
          ? _value.targetActionType
          : targetActionType // ignore: cast_nullable_to_non_nullable
              as StreamMessageInputAttachmentActionType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageInputAttachmentActionClickEventModel
    implements StreamMessageInputAttachmentActionClickEventModel {
  const _$StreamMessageInputAttachmentActionClickEventModel(
      {required this.targetActionType, final String? $type})
      : $type = $type ?? 'messageInputAttachmentActionClick';

  factory _$StreamMessageInputAttachmentActionClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageInputAttachmentActionClickEventModelFromJson(json);

  @override
  final StreamMessageInputAttachmentActionType targetActionType;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageInputAttachmentActionClick(targetActionType: $targetActionType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageInputAttachmentActionClickEventModel &&
            const DeepCollectionEquality()
                .equals(other.targetActionType, targetActionType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(targetActionType));

  @JsonKey(ignore: true)
  @override
  _$$StreamMessageInputAttachmentActionClickEventModelCopyWith<
          _$StreamMessageInputAttachmentActionClickEventModel>
      get copyWith =>
          __$$StreamMessageInputAttachmentActionClickEventModelCopyWithImpl<
                  _$StreamMessageInputAttachmentActionClickEventModel>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
  }) {
    return messageInputAttachmentActionClick(targetActionType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
  }) {
    return messageInputAttachmentActionClick?.call(targetActionType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (messageInputAttachmentActionClick != null) {
      return messageInputAttachmentActionClick(targetActionType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
  }) {
    return messageInputAttachmentActionClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
  }) {
    return messageInputAttachmentActionClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    required TResult orElse(),
  }) {
    if (messageInputAttachmentActionClick != null) {
      return messageInputAttachmentActionClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageInputAttachmentActionClickEventModelToJson(this);
  }
}

abstract class StreamMessageInputAttachmentActionClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageInputAttachmentActionClickEventModel(
          {required final StreamMessageInputAttachmentActionType
              targetActionType}) =
      _$StreamMessageInputAttachmentActionClickEventModel;

  factory StreamMessageInputAttachmentActionClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamMessageInputAttachmentActionClickEventModel.fromJson;

  StreamMessageInputAttachmentActionType get targetActionType =>
      throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$$StreamMessageInputAttachmentActionClickEventModelCopyWith<
          _$StreamMessageInputAttachmentActionClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}
