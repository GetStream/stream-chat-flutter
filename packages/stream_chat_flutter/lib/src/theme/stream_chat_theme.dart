import 'package:flutter/material.dart' hide TextTheme;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'stream_chat_theme.g.theme.dart';

/// Applies a Stream Chat theme to descendant widgets.
///
/// Wrap a subtree with [StreamChatTheme] to override the styling of all
/// Stream Chat components. Access the resolved theme using [StreamChatTheme.of].
///
/// {@tool snippet}
///
/// Override chat styling for a subtree:
///
/// ```dart
/// StreamChatTheme(
///   data: StreamChatThemeData(
///     messageListViewTheme: const StreamMessageListViewThemeData(
///       backgroundColor: Colors.grey,
///     ),
///   ),
///   child: const ChannelPage(),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamChatThemeData], which describes the actual theme configuration.
///  * [StreamChat], which provides this theme to the chat widget tree.
class StreamChatTheme extends InheritedTheme {
  /// Creates a [StreamChatTheme] that provides [data] to descendant widgets.
  const StreamChatTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The chat theme configuration for descendant widgets.
  final StreamChatThemeData data;

  /// Returns the [StreamChatThemeData] from the closest [StreamChatTheme]
  /// ancestor.
  ///
  /// If no [StreamChatTheme] is found in the widget tree, a default
  /// [StreamChatThemeData] is returned.
  ///
  /// {@tool snippet}
  ///
  /// Access the theme in a widget:
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   final theme = StreamChatTheme.of(context);
  ///   return Container(
  ///     color: theme.messageListViewTheme.backgroundColor,
  ///     child: const Text('Hello'),
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  static StreamChatThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<StreamChatTheme>();
    return theme?.data ?? StreamChatThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamChatTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamChatTheme oldWidget) => data != oldWidget.data;
}

/// The main theme configuration for Stream Chat.
///
/// [StreamChatThemeData] aggregates all chat component themes into a single
/// theme object. It is provided to the widget tree via [StreamChatTheme] or
/// [StreamChat], and accessed by descendants through [StreamChatTheme.of].
///
/// {@tool snippet}
///
/// Create a default theme:
///
/// ```dart
/// final theme = StreamChatThemeData();
/// ```
/// {@end-tool}
/// {@tool snippet}
///
/// Customize a single component:
///
/// ```dart
/// final theme = StreamChatThemeData(
///   messageListViewTheme: const StreamMessageListViewThemeData(
///     backgroundColor: Colors.grey,
///   ),
/// );
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamAppBarThemeData], which defines chat app bar styles.
///  * [StreamMessageListViewThemeData], which defines message list styles.
///  * [StreamChannelListItemThemeData], which defines channel list item styles.
///  * [StreamQuotedMessageThemeData], which defines quoted message styles.
///  * [StreamThreadListTileThemeData], which defines thread list tile styles.
///  * [StreamVoiceRecordingAttachmentThemeData], which defines voice recording attachment styles.
///  * [StreamPollCreatorThemeData], which defines poll creator styles.
///  * [StreamPollInteractorThemeData], which defines poll interactor styles.
///  * [StreamPollOptionsSheetThemeData], which defines poll options sheet styles.
///  * [StreamPollResultsSheetThemeData], which defines poll results sheet styles.
///  * [StreamPollCommentsSheetThemeData], which defines poll comments sheet styles.
///  * [StreamPollOptionVotesSheetThemeData], which defines poll option votes sheet styles.
@immutable
@ThemeExtensions(constructor: 'raw', buildContextExtension: false)
class StreamChatThemeData extends ThemeExtension<StreamChatThemeData> with _$StreamChatThemeData {
  /// Creates a chat theme configuration.
  ///
  /// Any component theme that is not provided falls back to its default
  /// `const` instance, so callers only need to supply the overrides they
  /// care about.
  ///
  /// See also:
  ///
  ///  * [StreamChatThemeData.raw], which requires every component theme to be supplied explicitly.
  factory StreamChatThemeData({
    StreamAppBarThemeData? channelHeaderTheme,
    StreamAppBarThemeData? channelListHeaderTheme,
    StreamAppBarThemeData? threadHeaderTheme,
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
    // App bars
    channelHeaderTheme ??= const StreamAppBarThemeData();
    channelListHeaderTheme ??= const StreamAppBarThemeData();
    threadHeaderTheme ??= const StreamAppBarThemeData();

    // Message list
    messageListViewTheme ??= const StreamMessageListViewThemeData();

    // Polls
    pollCreatorTheme ??= const StreamPollCreatorThemeData();
    pollInteractorTheme ??= const StreamPollInteractorThemeData();
    pollOptionsSheetTheme ??= const StreamPollOptionsSheetThemeData();
    pollResultsSheetTheme ??= const StreamPollResultsSheetThemeData();
    pollCommentsSheetTheme ??= const StreamPollCommentsSheetThemeData();
    pollOptionVotesSheetTheme ??= const StreamPollOptionVotesSheetThemeData();

    // Threads, attachments, quoted messages, channel list
    threadListTileTheme ??= const StreamThreadListTileThemeData();
    voiceRecordingAttachmentTheme ??= const StreamVoiceRecordingAttachmentThemeData();
    quotedMessageTheme ??= const StreamQuotedMessageThemeData();
    channelListItemTheme ??= const StreamChannelListItemThemeData();

    return StreamChatThemeData.raw(
      channelHeaderTheme: channelHeaderTheme,
      channelListHeaderTheme: channelListHeaderTheme,
      threadHeaderTheme: threadHeaderTheme,
      messageListViewTheme: messageListViewTheme,
      pollCreatorTheme: pollCreatorTheme,
      pollInteractorTheme: pollInteractorTheme,
      pollOptionsSheetTheme: pollOptionsSheetTheme,
      pollResultsSheetTheme: pollResultsSheetTheme,
      pollCommentsSheetTheme: pollCommentsSheetTheme,
      pollOptionVotesSheetTheme: pollOptionVotesSheetTheme,
      threadListTileTheme: threadListTileTheme,
      voiceRecordingAttachmentTheme: voiceRecordingAttachmentTheme,
      quotedMessageTheme: quotedMessageTheme,
      channelListItemTheme: channelListItemTheme,
    );
  }

  /// Creates a theme configuration with every component theme supplied.
  const StreamChatThemeData.raw({
    required this.channelHeaderTheme,
    required this.channelListHeaderTheme,
    required this.threadHeaderTheme,
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

  /// The channel header app bar theme for this theme.
  final StreamAppBarThemeData channelHeaderTheme;

  /// The channel list header app bar theme for this theme.
  final StreamAppBarThemeData channelListHeaderTheme;

  /// The thread header app bar theme for this theme.
  final StreamAppBarThemeData threadHeaderTheme;

  /// The message list view theme for this theme.
  final StreamMessageListViewThemeData messageListViewTheme;

  /// The poll creator theme for this theme.
  final StreamPollCreatorThemeData pollCreatorTheme;

  /// The poll interactor theme for this theme.
  final StreamPollInteractorThemeData pollInteractorTheme;

  /// The poll results sheet theme for this theme.
  final StreamPollResultsSheetThemeData pollResultsSheetTheme;

  /// The poll options sheet theme for this theme.
  final StreamPollOptionsSheetThemeData pollOptionsSheetTheme;

  /// The poll comments sheet theme for this theme.
  final StreamPollCommentsSheetThemeData pollCommentsSheetTheme;

  /// The poll option votes sheet theme for this theme.
  final StreamPollOptionVotesSheetThemeData pollOptionVotesSheetTheme;

  /// The thread list tile theme for this theme.
  final StreamThreadListTileThemeData threadListTileTheme;

  /// The voice recording attachment theme for this theme.
  final StreamVoiceRecordingAttachmentThemeData voiceRecordingAttachmentTheme;

  /// The quoted message theme for this theme.
  final StreamQuotedMessageThemeData quotedMessageTheme;

  /// The channel list item theme for this theme.
  final StreamChannelListItemThemeData channelListItemTheme;
}
