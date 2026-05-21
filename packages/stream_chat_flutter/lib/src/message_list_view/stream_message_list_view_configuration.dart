import 'package:flutter/widgets.dart';

/// {@template streamMessageListConfiguration}
/// Holds all behavior flags and non-theme, non-builder configuration for
/// [StreamMessageListView].
///
/// Pass an instance directly to [StreamMessageListView.config]:
///
/// ```dart
/// StreamMessageListView(
///   config: StreamMessageListConfiguration(
///     swipeToReply: true,
///     markReadWhenAtTheBottom: false,
///   ),
/// )
/// ```
/// {@endtemplate}
class StreamMessageListViewConfiguration {
  /// {@macro streamMessageListConfiguration}
  const StreamMessageListViewConfiguration({
    this.markReadWhenAtTheBottom = true,
    this.swipeToReply = false,
    this.showScrollToBottom = true,
    this.showUnreadCountOnScrollToBottom = true,
    this.showUnreadIndicator = true,
    this.highlightInitialMessage = false,
    this.showConnectionStateTile = false,
    this.showFloatingDateDivider = true,
    this.fadeFloatingDateDividerNearInline = true,
    this.reverse = true,
    this.shrinkWrap = false,
    this.paginationLimit = 25,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.scrollPhysics = const ClampingScrollPhysics(),
  });

  /// Whether to mark the channel as read when the user scrolls to the bottom.
  ///
  /// Defaults to true.
  final bool markReadWhenAtTheBottom;

  /// Whether swiping a message triggers a quoted-reply action.
  ///
  /// Defaults to false.
  final bool swipeToReply;

  /// Whether to show a scroll-to-bottom button when scrolled away from the
  /// bottom.
  ///
  /// Defaults to true.
  final bool showScrollToBottom;

  /// Whether to show the unread message count on the scroll-to-bottom button.
  ///
  /// Defaults to true.
  final bool showUnreadCountOnScrollToBottom;

  /// Whether to show the jump-to-unread indicator when there are unread
  /// messages.
  ///
  /// Defaults to true.
  final bool showUnreadIndicator;

  /// Whether to highlight the initial message when the list first loads.
  ///
  /// Defaults to false.
  final bool highlightInitialMessage;

  /// Whether to show a connection state tile on the header when the client is
  /// connecting or disconnected.
  ///
  /// Defaults to false.
  final bool showConnectionStateTile;

  /// Whether to show the floating date divider while scrolling.
  ///
  /// Defaults to true.
  final bool showFloatingDateDivider;

  /// Whether the floating date divider fades out when an inline date divider
  /// for the same date is near the top of the viewport.
  ///
  /// Only has an effect when [showFloatingDateDivider] is true.
  ///
  /// Defaults to true.
  final bool fadeFloatingDateDividerNearInline;

  /// Whether the list scrolls in the reverse reading direction (newest message
  /// at the bottom).
  ///
  /// Defaults to true.
  ///
  /// See [ScrollView.reverse].
  final bool reverse;

  /// Whether the extent of the scroll view should be determined by its
  /// contents.
  ///
  /// Defaults to false.
  ///
  /// See [ScrollView.shrinkWrap].
  final bool shrinkWrap;

  /// The number of messages fetched per pagination request.
  ///
  /// Defaults to 25.
  final int paginationLimit;

  /// Defines how the list dismisses the keyboard automatically.
  ///
  /// Defaults to [ScrollViewKeyboardDismissBehavior.onDrag].
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// The [ScrollPhysics] used by the list.
  ///
  /// Defaults to [ClampingScrollPhysics].
  final ScrollPhysics scrollPhysics;

  /// Returns a copy of this configuration with the given fields replaced.
  StreamMessageListViewConfiguration copyWith({
    bool? markReadWhenAtTheBottom,
    bool? swipeToReply,
    bool? showScrollToBottom,
    bool? showUnreadCountOnScrollToBottom,
    bool? showUnreadIndicator,
    bool? highlightInitialMessage,
    bool? showConnectionStateTile,
    bool? showFloatingDateDivider,
    bool? fadeFloatingDateDividerNearInline,
    bool? reverse,
    bool? shrinkWrap,
    int? paginationLimit,
    ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior,
    ScrollPhysics? scrollPhysics,
  }) {
    return StreamMessageListViewConfiguration(
      markReadWhenAtTheBottom: markReadWhenAtTheBottom ?? this.markReadWhenAtTheBottom,
      swipeToReply: swipeToReply ?? this.swipeToReply,
      showScrollToBottom: showScrollToBottom ?? this.showScrollToBottom,
      showUnreadCountOnScrollToBottom: showUnreadCountOnScrollToBottom ?? this.showUnreadCountOnScrollToBottom,
      showUnreadIndicator: showUnreadIndicator ?? this.showUnreadIndicator,
      highlightInitialMessage: highlightInitialMessage ?? this.highlightInitialMessage,
      showConnectionStateTile: showConnectionStateTile ?? this.showConnectionStateTile,
      showFloatingDateDivider: showFloatingDateDivider ?? this.showFloatingDateDivider,
      fadeFloatingDateDividerNearInline: fadeFloatingDateDividerNearInline ?? this.fadeFloatingDateDividerNearInline,
      reverse: reverse ?? this.reverse,
      shrinkWrap: shrinkWrap ?? this.shrinkWrap,
      paginationLimit: paginationLimit ?? this.paginationLimit,
      keyboardDismissBehavior: keyboardDismissBehavior ?? this.keyboardDismissBehavior,
      scrollPhysics: scrollPhysics ?? this.scrollPhysics,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StreamMessageListViewConfiguration &&
        other.markReadWhenAtTheBottom == markReadWhenAtTheBottom &&
        other.swipeToReply == swipeToReply &&
        other.showScrollToBottom == showScrollToBottom &&
        other.showUnreadCountOnScrollToBottom == showUnreadCountOnScrollToBottom &&
        other.showUnreadIndicator == showUnreadIndicator &&
        other.highlightInitialMessage == highlightInitialMessage &&
        other.showConnectionStateTile == showConnectionStateTile &&
        other.showFloatingDateDivider == showFloatingDateDivider &&
        other.fadeFloatingDateDividerNearInline == fadeFloatingDateDividerNearInline &&
        other.reverse == reverse &&
        other.shrinkWrap == shrinkWrap &&
        other.paginationLimit == paginationLimit &&
        other.keyboardDismissBehavior == keyboardDismissBehavior &&
        other.scrollPhysics == scrollPhysics;
  }

  @override
  int get hashCode => Object.hash(
    markReadWhenAtTheBottom,
    swipeToReply,
    showScrollToBottom,
    showUnreadCountOnScrollToBottom,
    showUnreadIndicator,
    highlightInitialMessage,
    showConnectionStateTile,
    showFloatingDateDivider,
    fadeFloatingDateDividerNearInline,
    reverse,
    shrinkWrap,
    paginationLimit,
    keyboardDismissBehavior,
    scrollPhysics,
  );
}
