import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamMessageListBuilders}
/// Holds all custom slot builders for [StreamMessageListView].
///
/// Pass an instance directly to [StreamMessageListView.builders]:
///
/// ```dart
/// StreamMessageListView(
///   builders: StreamMessageListBuilders(
///     empty: (context) => const Center(child: Text('No messages')),
///     dateDivider: (dateTime) => MyDateDivider(date: dateTime),
///   ),
/// )
/// ```
/// {@endtemplate}
class StreamMessageListBuilders {
  /// {@macro streamMessageListBuilders}
  const StreamMessageListBuilders({
    this.empty,
    this.loading,
    this.error,
    this.header,
    this.footer,
    this.content,
    this.dateDivider,
    this.floatingDateDivider,
    this.threadSeparator,
    this.unreadMessagesSeparator,
    this.scrollToBottomButton,
    this.paginationLoadingIndicator,
    this.spacing,
    this.systemMessage,
    this.ephemeralMessage,
    this.moderatedMessage,
    this.parentMessage,
  });

  /// Custom builder for the empty state when there are no messages.
  final WidgetBuilder? empty;

  /// Custom builder for the loading state while initial messages are loading.
  final WidgetBuilder? loading;

  /// Custom builder for the error state when message loading fails.
  final ErrorBuilder? error;

  /// Custom builder for a header widget above the message list.
  ///
  /// In a reversed list (the default) this appears at the bottom of the
  /// viewport, above the newest message.
  final WidgetBuilder? header;

  /// Custom builder for a footer widget below the message list.
  ///
  /// In a reversed list (the default) this appears at the top of the
  /// viewport, above the oldest message.
  final WidgetBuilder? footer;

  /// Custom builder that replaces the entire scrollable list once messages
  /// have loaded.
  ///
  /// Receives the full list of (filtered) messages to display.
  final Widget Function(BuildContext context, List<Message> messages)? content;

  /// Custom builder for inline date dividers between messages on different
  /// days.
  final Widget Function(DateTime dateTime)? dateDivider;

  /// Custom builder for the floating date divider that stays pinned to the
  /// top of the viewport while scrolling.
  ///
  /// When null, falls back to [dateDivider] if set.
  final Widget Function(DateTime dateTime)? floatingDateDivider;

  /// Custom builder for the thread separator shown above the parent message
  /// in a thread view.
  final Widget Function(BuildContext context, Message parentMessage)? threadSeparator;

  /// Custom builder for the unread messages separator.
  ///
  /// Receives the number of unread messages below the separator.
  final Widget Function(BuildContext context, int unreadCount)? unreadMessagesSeparator;

  /// Custom builder for the scroll-to-bottom button.
  ///
  /// Receives the current unread count and the default tap action.
  final Widget Function(
    int unreadCount,
    Future<void> Function(int unreadCount) defaultTapAction,
  )?
  scrollToBottomButton;

  /// Custom builder for the pagination loading indicator shown while loading
  /// more messages.
  ///
  /// The same builder is used for both top (older) and bottom (newer) loading
  /// directions.
  final WidgetBuilder? paginationLoadingIndicator;

  /// Custom builder for the spacing widget inserted between adjacent messages.
  ///
  /// See [SpacingWidgetBuilder] and [SpacingType].
  final SpacingWidgetBuilder? spacing;

  /// Custom builder for system messages.
  final SystemMessageBuilder? systemMessage;

  /// Custom builder for ephemeral messages.
  final EphemeralMessageBuilder? ephemeralMessage;

  /// Custom builder for moderated (non-bounced error) messages.
  final ModeratedMessageBuilder? moderatedMessage;

  /// Custom builder for the parent message at the top of a thread view.
  ///
  /// Receives the [BuildContext], the parent [Message], and the
  /// pre-configured [StreamMessageItemProps] with all list-level callbacks
  /// wired in.
  final StreamMessageItemBuilder? parentMessage;

  /// Returns a copy of this object with the given fields replaced.
  StreamMessageListBuilders copyWith({
    WidgetBuilder? empty,
    WidgetBuilder? loading,
    ErrorBuilder? error,
    WidgetBuilder? header,
    WidgetBuilder? footer,
    Widget Function(BuildContext context, List<Message> messages)? content,
    Widget Function(DateTime dateTime)? dateDivider,
    Widget Function(DateTime dateTime)? floatingDateDivider,
    Widget Function(BuildContext context, Message parentMessage)? threadSeparator,
    Widget Function(BuildContext context, int unreadCount)? unreadMessagesSeparator,
    Widget Function(int unreadCount, Future<void> Function(int) defaultTapAction)? scrollToBottomButton,
    WidgetBuilder? paginationLoadingIndicator,
    SpacingWidgetBuilder? spacing,
    SystemMessageBuilder? systemMessage,
    EphemeralMessageBuilder? ephemeralMessage,
    ModeratedMessageBuilder? moderatedMessage,
    StreamMessageItemBuilder? parentMessage,
  }) {
    return StreamMessageListBuilders(
      empty: empty ?? this.empty,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      header: header ?? this.header,
      footer: footer ?? this.footer,
      content: content ?? this.content,
      dateDivider: dateDivider ?? this.dateDivider,
      floatingDateDivider: floatingDateDivider ?? this.floatingDateDivider,
      threadSeparator: threadSeparator ?? this.threadSeparator,
      unreadMessagesSeparator: unreadMessagesSeparator ?? this.unreadMessagesSeparator,
      scrollToBottomButton: scrollToBottomButton ?? this.scrollToBottomButton,
      paginationLoadingIndicator: paginationLoadingIndicator ?? this.paginationLoadingIndicator,
      spacing: spacing ?? this.spacing,
      systemMessage: systemMessage ?? this.systemMessage,
      ephemeralMessage: ephemeralMessage ?? this.ephemeralMessage,
      moderatedMessage: moderatedMessage ?? this.moderatedMessage,
      parentMessage: parentMessage ?? this.parentMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StreamMessageListBuilders &&
        other.empty == empty &&
        other.loading == loading &&
        other.error == error &&
        other.header == header &&
        other.footer == footer &&
        other.content == content &&
        other.dateDivider == dateDivider &&
        other.floatingDateDivider == floatingDateDivider &&
        other.threadSeparator == threadSeparator &&
        other.unreadMessagesSeparator == unreadMessagesSeparator &&
        other.scrollToBottomButton == scrollToBottomButton &&
        other.paginationLoadingIndicator == paginationLoadingIndicator &&
        other.spacing == spacing &&
        other.systemMessage == systemMessage &&
        other.ephemeralMessage == ephemeralMessage &&
        other.moderatedMessage == moderatedMessage &&
        other.parentMessage == parentMessage;
  }

  @override
  int get hashCode => Object.hash(
    empty,
    loading,
    error,
    header,
    footer,
    content,
    dateDivider,
    floatingDateDivider,
    threadSeparator,
    unreadMessagesSeparator,
    scrollToBottomButton,
    paginationLoadingIndicator,
    spacing,
    systemMessage,
    ephemeralMessage,
    moderatedMessage,
    parentMessage,
  );
}
