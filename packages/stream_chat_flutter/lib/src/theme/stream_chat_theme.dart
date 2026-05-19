// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart' hide TextTheme;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamChatTheme}
/// Inherited widget providing the [StreamChatThemeData] to the widget tree
/// {@endtemplate}
class StreamChatTheme extends InheritedWidget {
  /// {@macro streamChatTheme}
  const StreamChatTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// {@macro streamChatThemeData}
  final StreamChatThemeData data;

  @override
  bool updateShouldNotify(StreamChatTheme oldWidget) => data != oldWidget.data;

  /// Use this method to get the current [StreamChatThemeData] instance
  static StreamChatThemeData of(BuildContext context) {
    final streamChatTheme = context.dependOnInheritedWidgetOfExactType<StreamChatTheme>();

    assert(
      streamChatTheme != null,
      'You must have a StreamChatTheme widget at the top of your widget tree',
    );

    return streamChatTheme!.data;
  }
}

/// {@template streamChatThemeData}
/// Theme data for Stream Chat
/// {@endtemplate}
class StreamChatThemeData {
  /// Creates a theme from scratch
  factory StreamChatThemeData({
    StreamAppBarThemeData? channelHeaderTheme,
    StreamAppBarThemeData? channelListHeaderTheme,
    StreamAppBarThemeData? threadHeaderTheme,
    IconThemeData? primaryIconTheme,
    StreamMessageListViewThemeData? messageListViewTheme,
    StreamPollCreatorThemeData? pollCreatorTheme,
    StreamPollInteractorThemeData? pollInteractorTheme,
    StreamPollOptionsSheetThemeData? pollOptionsSheetTheme,
    StreamPollResultsSheetThemeData? pollResultsSheetTheme,
    StreamPollCommentsSheetThemeData? pollCommentsSheetTheme,
    StreamPollOptionVotesSheetThemeData? pollOptionVotesSheetTheme,
    StreamThreadListTileThemeData? threadListTileTheme,
    StreamVoiceRecordingAttachmentThemeData? voiceRecordingAttachmentTheme,
    StreamQuotedMessageThemeData? quotedMessageTheme,
    StreamChannelListItemThemeData? channelListItemTheme,
  }) {
    return StreamChatThemeData.raw(
      channelHeaderTheme: channelHeaderTheme ?? const StreamAppBarThemeData(),
      channelListHeaderTheme: channelListHeaderTheme ?? const StreamAppBarThemeData(),
      threadHeaderTheme: threadHeaderTheme ?? const StreamAppBarThemeData(),
      primaryIconTheme: primaryIconTheme ?? const IconThemeData(),
      messageListViewTheme: messageListViewTheme ?? const StreamMessageListViewThemeData(),
      pollCreatorTheme: pollCreatorTheme ?? const StreamPollCreatorThemeData(),
      pollInteractorTheme: pollInteractorTheme ?? const StreamPollInteractorThemeData(),
      pollOptionsSheetTheme: pollOptionsSheetTheme ?? const StreamPollOptionsSheetThemeData(),
      pollResultsSheetTheme: pollResultsSheetTheme ?? const StreamPollResultsSheetThemeData(),
      pollCommentsSheetTheme: pollCommentsSheetTheme ?? const StreamPollCommentsSheetThemeData(),
      pollOptionVotesSheetTheme: pollOptionVotesSheetTheme ?? const StreamPollOptionVotesSheetThemeData(),
      threadListTileTheme: threadListTileTheme ?? const StreamThreadListTileThemeData(),
      voiceRecordingAttachmentTheme: voiceRecordingAttachmentTheme ?? const StreamVoiceRecordingAttachmentThemeData(),
      quotedMessageTheme: quotedMessageTheme ?? const StreamQuotedMessageThemeData(),
      channelListItemTheme: channelListItemTheme ?? const StreamChannelListItemThemeData(),
    );
  }

  /// Raw theme initialization
  const StreamChatThemeData.raw({
    required this.channelHeaderTheme,
    required this.channelListHeaderTheme,
    required this.threadHeaderTheme,
    required this.primaryIconTheme,
    required this.messageListViewTheme,
    required this.pollCreatorTheme,
    required this.pollInteractorTheme,
    required this.pollResultsSheetTheme,
    required this.pollOptionsSheetTheme,
    required this.pollCommentsSheetTheme,
    required this.pollOptionVotesSheetTheme,
    required this.threadListTileTheme,
    required this.voiceRecordingAttachmentTheme,
    required this.quotedMessageTheme,
    required this.channelListItemTheme,
  });

  /// The default [StreamAppBar] style applied to [StreamChannelHeader].
  final StreamAppBarThemeData channelHeaderTheme;

  /// The default [StreamAppBar] style applied to [StreamChannelListHeader].
  final StreamAppBarThemeData channelListHeaderTheme;

  /// The default [StreamAppBar] style applied to [StreamThreadHeader].
  final StreamAppBarThemeData threadHeaderTheme;

  /// Primary icon theme
  final IconThemeData primaryIconTheme;

  /// Theme configuration for the [StreamMessageListView] widget.
  final StreamMessageListViewThemeData messageListViewTheme;

  /// Theme configuration for the [StreamPollCreatorWidget] widget.
  final StreamPollCreatorThemeData pollCreatorTheme;

  /// Theme configuration for the [StreamPollInteractor] widget.
  final StreamPollInteractorThemeData pollInteractorTheme;

  /// Theme configuration for the [StreamPollResultsSheet] widget.
  final StreamPollResultsSheetThemeData pollResultsSheetTheme;

  /// Theme configuration for the [StreamPollOptionsSheet] widget.
  final StreamPollOptionsSheetThemeData pollOptionsSheetTheme;

  /// Theme configuration for the [StreamPollCommentsSheet] widget.
  final StreamPollCommentsSheetThemeData pollCommentsSheetTheme;

  /// Theme configuration for the [StreamPollOptionVotesSheet] widget.
  final StreamPollOptionVotesSheetThemeData pollOptionVotesSheetTheme;

  /// Theme configuration for the [StreamThreadListTile] widget.
  final StreamThreadListTileThemeData threadListTileTheme;

  /// Theme configuration for the [StreamVoiceRecordingAttachment] widget.
  final StreamVoiceRecordingAttachmentThemeData voiceRecordingAttachmentTheme;

  /// Theme configuration for the [StreamQuotedMessage] widget.
  final StreamQuotedMessageThemeData quotedMessageTheme;

  /// Theme configuration for the [StreamChannelListItem] widget.
  final StreamChannelListItemThemeData channelListItemTheme;

  /// Creates a copy of [StreamChatThemeData] with specified attributes
  /// overridden.
  StreamChatThemeData copyWith({
    StreamAppBarThemeData? channelHeaderTheme,
    StreamAppBarThemeData? channelListHeaderTheme,
    StreamAppBarThemeData? threadHeaderTheme,
    IconThemeData? primaryIconTheme,
    StreamMessageListViewThemeData? messageListViewTheme,
    StreamPollCreatorThemeData? pollCreatorTheme,
    StreamPollInteractorThemeData? pollInteractorTheme,
    StreamPollResultsSheetThemeData? pollResultsSheetTheme,
    StreamPollOptionsSheetThemeData? pollOptionsSheetTheme,
    StreamPollCommentsSheetThemeData? pollCommentsSheetTheme,
    StreamPollOptionVotesSheetThemeData? pollOptionVotesSheetTheme,
    StreamThreadListTileThemeData? threadListTileTheme,
    StreamVoiceRecordingAttachmentThemeData? voiceRecordingAttachmentTheme,
    StreamQuotedMessageThemeData? quotedMessageTheme,
    StreamChannelListItemThemeData? channelListItemTheme,
  }) => StreamChatThemeData.raw(
    channelHeaderTheme: this.channelHeaderTheme.merge(channelHeaderTheme),
    channelListHeaderTheme: this.channelListHeaderTheme.merge(channelListHeaderTheme),
    threadHeaderTheme: this.threadHeaderTheme.merge(threadHeaderTheme),
    primaryIconTheme: this.primaryIconTheme.merge(primaryIconTheme),
    messageListViewTheme: messageListViewTheme ?? this.messageListViewTheme,
    pollCreatorTheme: pollCreatorTheme ?? this.pollCreatorTheme,
    pollInteractorTheme: pollInteractorTheme ?? this.pollInteractorTheme,
    pollResultsSheetTheme: pollResultsSheetTheme ?? this.pollResultsSheetTheme,
    pollOptionsSheetTheme: pollOptionsSheetTheme ?? this.pollOptionsSheetTheme,
    pollCommentsSheetTheme: pollCommentsSheetTheme ?? this.pollCommentsSheetTheme,
    pollOptionVotesSheetTheme: pollOptionVotesSheetTheme ?? this.pollOptionVotesSheetTheme,
    threadListTileTheme: threadListTileTheme ?? this.threadListTileTheme,
    voiceRecordingAttachmentTheme: voiceRecordingAttachmentTheme ?? this.voiceRecordingAttachmentTheme,
    quotedMessageTheme: quotedMessageTheme ?? this.quotedMessageTheme,
    channelListItemTheme: channelListItemTheme ?? this.channelListItemTheme,
  );

  /// Merge themes
  StreamChatThemeData merge(StreamChatThemeData? other) {
    if (other == null) return this;
    return copyWith(
      channelHeaderTheme: channelHeaderTheme.merge(other.channelHeaderTheme),
      channelListHeaderTheme: channelListHeaderTheme.merge(other.channelListHeaderTheme),
      threadHeaderTheme: threadHeaderTheme.merge(other.threadHeaderTheme),
      primaryIconTheme: other.primaryIconTheme,
      messageListViewTheme: messageListViewTheme.merge(other.messageListViewTheme),
      pollCreatorTheme: pollCreatorTheme.merge(other.pollCreatorTheme),
      pollInteractorTheme: pollInteractorTheme.merge(other.pollInteractorTheme),
      pollResultsSheetTheme: pollResultsSheetTheme.merge(other.pollResultsSheetTheme),
      pollOptionsSheetTheme: pollOptionsSheetTheme.merge(other.pollOptionsSheetTheme),
      pollCommentsSheetTheme: pollCommentsSheetTheme.merge(other.pollCommentsSheetTheme),
      pollOptionVotesSheetTheme: pollOptionVotesSheetTheme.merge(other.pollOptionVotesSheetTheme),
      threadListTileTheme: threadListTileTheme.merge(other.threadListTileTheme),
      voiceRecordingAttachmentTheme: voiceRecordingAttachmentTheme.merge(other.voiceRecordingAttachmentTheme),
      quotedMessageTheme: quotedMessageTheme.merge(other.quotedMessageTheme),
      channelListItemTheme: channelListItemTheme.merge(other.channelListItemTheme),
    );
  }
}
