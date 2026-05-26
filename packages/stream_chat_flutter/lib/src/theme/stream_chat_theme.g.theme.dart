// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'stream_chat_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$StreamChatThemeData on ThemeExtension<StreamChatThemeData> {
  @override
  ThemeExtension<StreamChatThemeData> copyWith({
    StreamAppBarThemeData? channelHeaderTheme,
    StreamAppBarThemeData? channelListHeaderTheme,
    StreamAppBarThemeData? threadHeaderTheme,
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
  }) {
    final _this = (this as StreamChatThemeData);

    return StreamChatThemeData.raw(
      channelHeaderTheme: channelHeaderTheme ?? _this.channelHeaderTheme,
      channelListHeaderTheme:
          channelListHeaderTheme ?? _this.channelListHeaderTheme,
      threadHeaderTheme: threadHeaderTheme ?? _this.threadHeaderTheme,
      messageListViewTheme: messageListViewTheme ?? _this.messageListViewTheme,
      pollCreatorTheme: pollCreatorTheme ?? _this.pollCreatorTheme,
      pollInteractorTheme: pollInteractorTheme ?? _this.pollInteractorTheme,
      pollResultsSheetTheme:
          pollResultsSheetTheme ?? _this.pollResultsSheetTheme,
      pollOptionsSheetTheme:
          pollOptionsSheetTheme ?? _this.pollOptionsSheetTheme,
      pollCommentsSheetTheme:
          pollCommentsSheetTheme ?? _this.pollCommentsSheetTheme,
      pollOptionVotesSheetTheme:
          pollOptionVotesSheetTheme ?? _this.pollOptionVotesSheetTheme,
      threadListTileTheme: threadListTileTheme ?? _this.threadListTileTheme,
      voiceRecordingAttachmentTheme:
          voiceRecordingAttachmentTheme ?? _this.voiceRecordingAttachmentTheme,
      quotedMessageTheme: quotedMessageTheme ?? _this.quotedMessageTheme,
      channelListItemTheme: channelListItemTheme ?? _this.channelListItemTheme,
    );
  }

  @override
  ThemeExtension<StreamChatThemeData> lerp(
    ThemeExtension<StreamChatThemeData>? other,
    double t,
  ) {
    if (other is! StreamChatThemeData) {
      return this;
    }

    final _this = (this as StreamChatThemeData);

    return StreamChatThemeData.raw(
      channelHeaderTheme: StreamAppBarThemeData.lerp(
        _this.channelHeaderTheme,
        other.channelHeaderTheme,
        t,
      )!,
      channelListHeaderTheme: StreamAppBarThemeData.lerp(
        _this.channelListHeaderTheme,
        other.channelListHeaderTheme,
        t,
      )!,
      threadHeaderTheme: StreamAppBarThemeData.lerp(
        _this.threadHeaderTheme,
        other.threadHeaderTheme,
        t,
      )!,
      messageListViewTheme: StreamMessageListViewThemeData.lerp(
        _this.messageListViewTheme,
        other.messageListViewTheme,
        t,
      )!,
      pollCreatorTheme: StreamPollCreatorThemeData.lerp(
        _this.pollCreatorTheme,
        other.pollCreatorTheme,
        t,
      )!,
      pollInteractorTheme: StreamPollInteractorThemeData.lerp(
        _this.pollInteractorTheme,
        other.pollInteractorTheme,
        t,
      )!,
      pollResultsSheetTheme: StreamPollResultsSheetThemeData.lerp(
        _this.pollResultsSheetTheme,
        other.pollResultsSheetTheme,
        t,
      )!,
      pollOptionsSheetTheme: StreamPollOptionsSheetThemeData.lerp(
        _this.pollOptionsSheetTheme,
        other.pollOptionsSheetTheme,
        t,
      )!,
      pollCommentsSheetTheme: StreamPollCommentsSheetThemeData.lerp(
        _this.pollCommentsSheetTheme,
        other.pollCommentsSheetTheme,
        t,
      )!,
      pollOptionVotesSheetTheme: StreamPollOptionVotesSheetThemeData.lerp(
        _this.pollOptionVotesSheetTheme,
        other.pollOptionVotesSheetTheme,
        t,
      )!,
      threadListTileTheme: StreamThreadListTileThemeData.lerp(
        _this.threadListTileTheme,
        other.threadListTileTheme,
        t,
      )!,
      voiceRecordingAttachmentTheme:
          StreamVoiceRecordingAttachmentThemeData.lerp(
            _this.voiceRecordingAttachmentTheme,
            other.voiceRecordingAttachmentTheme,
            t,
          )!,
      quotedMessageTheme: StreamQuotedMessageThemeData.lerp(
        _this.quotedMessageTheme,
        other.quotedMessageTheme,
        t,
      )!,
      channelListItemTheme: StreamChannelListItemThemeData.lerp(
        _this.channelListItemTheme,
        other.channelListItemTheme,
        t,
      )!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as StreamChatThemeData);
    final _other = (other as StreamChatThemeData);

    return _other.channelHeaderTheme == _this.channelHeaderTheme &&
        _other.channelListHeaderTheme == _this.channelListHeaderTheme &&
        _other.threadHeaderTheme == _this.threadHeaderTheme &&
        _other.messageListViewTheme == _this.messageListViewTheme &&
        _other.pollCreatorTheme == _this.pollCreatorTheme &&
        _other.pollInteractorTheme == _this.pollInteractorTheme &&
        _other.pollResultsSheetTheme == _this.pollResultsSheetTheme &&
        _other.pollOptionsSheetTheme == _this.pollOptionsSheetTheme &&
        _other.pollCommentsSheetTheme == _this.pollCommentsSheetTheme &&
        _other.pollOptionVotesSheetTheme == _this.pollOptionVotesSheetTheme &&
        _other.threadListTileTheme == _this.threadListTileTheme &&
        _other.voiceRecordingAttachmentTheme ==
            _this.voiceRecordingAttachmentTheme &&
        _other.quotedMessageTheme == _this.quotedMessageTheme &&
        _other.channelListItemTheme == _this.channelListItemTheme;
  }

  @override
  int get hashCode {
    final _this = (this as StreamChatThemeData);

    return Object.hash(
      runtimeType,
      _this.channelHeaderTheme,
      _this.channelListHeaderTheme,
      _this.threadHeaderTheme,
      _this.messageListViewTheme,
      _this.pollCreatorTheme,
      _this.pollInteractorTheme,
      _this.pollResultsSheetTheme,
      _this.pollOptionsSheetTheme,
      _this.pollCommentsSheetTheme,
      _this.pollOptionVotesSheetTheme,
      _this.threadListTileTheme,
      _this.voiceRecordingAttachmentTheme,
      _this.quotedMessageTheme,
      _this.channelListItemTheme,
    );
  }
}
