import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/src/message_list_view/floating_date_divider.dart';
import 'package:stream_chat_flutter/src/message_list_view/loading_indicator.dart';
import 'package:stream_chat_flutter/src/message_list_view/mlv_utils.dart';
import 'package:stream_chat_flutter/src/message_list_view/stream_message_list_empty_state.dart';
import 'package:stream_chat_flutter/src/message_list_view/stream_message_list_skeleton_loading.dart';
import 'package:stream_chat_flutter/src/message_list_view/thread_separator.dart';
import 'package:stream_chat_flutter/src/message_list_view/unread_messages_separator.dart';
import 'package:stream_chat_flutter/src/message_widget/stream_ephemeral_message.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// Spacing Types (These are properties of a message to help inform the decision
/// of how much space / which widget to build after it)
enum SpacingType {
  /// Message is a thread
  thread,

  /// There is a >1s time diff between current and last message
  timeDiff,

  /// Next message is by a different user
  otherUser,

  /// Message is deleted
  deleted,

  /// No other conditions are valid, default spacing (This will likely be the
  /// only rule in the list provided)
  defaultSpacing,
}

/// Signature for a function that builds a message widget from its
/// [StreamMessageItemProps].
///
/// Receives the [BuildContext], the [Message] data, and the pre-configured
/// [StreamMessageItemProps] with all list-level callbacks already wired in.
///
/// Use [DefaultStreamMessageItem] to build the default UI, optionally modifying
/// the props via [StreamMessageItemProps.copyWith] first.
typedef StreamMessageItemBuilder =
    Widget Function(
      BuildContext context,
      Message message,
      StreamMessageItemProps defaultProps,
    );

/// {@template streamMessageListView}
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_listview.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_listview_paint.png)
///
/// Shows the list of messages in the current channel.
///
/// ```dart
/// class ChannelPage extends StatelessWidget {
///   const ChannelPage({
///     Key? key,
///   }) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: StreamChannelHeader(),
///       body: Column(
///         children: <Widget>[
///           Expanded(
///             child: StreamMessageListView(
///               threadBuilder: (_, parentMessage) {
///                 return ThreadPage(
///                   parent: parentMessage,
///                 );
///               },
///             ),
///           ),
///           StreamMessageComposer(),
///         ],
///       ),
///     );
///   }
/// }
/// ```
///
/// A [StreamChannel] ancestor widget is required in order to provide the
/// information about the channels.
///
/// Uses a [ScrollablePositionedList] to render the list of channels.
///
/// The UI is rendered based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget's appearance.
/// {@endtemplate}
class StreamMessageListView extends StatefulWidget {
  /// {@macro streamMessageListView}
  const StreamMessageListView({
    super.key,
    this.messageFilter,
    this.messageBuilder,
    this.parentMessage,
    this.initialScrollIndex,
    this.initialAlignment,
    this.messageListController,
    this.scrollController,
    this.itemPositionListener,
    this.threadBuilder,
    this.onThreadTap,
    this.onMessageTap,
    this.onViewInChannelTap,
    this.onEditMessageTap,
    this.onReplyTap,
    this.onUserAvatarTap,
    this.onReactionsTap,
    this.onQuotedMessageTap,
    this.onMessageLinkTap,
    this.onUserMentionTap,
    this.onSystemMessageTap,
    this.onEphemeralMessageTap,
    this.onModeratedMessageTap,
    this.onMessageLongPress,
    this.config = const StreamMessageListViewConfiguration(),
    this.builders = const StreamMessageListViewBuilders(),
  });

  /// Predicate used to filter messages.
  final bool Function(Message)? messageFilter;

  /// Optional builder for per-instance message customization.
  ///
  /// When set, this builder is called for each regular message with
  /// pre-configured [StreamMessageItemProps] that have all list-level
  /// callbacks already wired in. Use [StreamMessageItemProps.copyWith]
  /// to modify properties, and [DefaultStreamMessageItem] to build the default
  /// widget.
  final StreamMessageItemBuilder? messageBuilder;

  /// Parent message in case of a thread.
  final Message? parentMessage;

  /// {@macro threadBuilder}
  final ThreadBuilder? threadBuilder;

  /// {@macro threadTapCallback}
  ///
  /// By default it calls [Navigator.push] using the widget
  /// built using [threadBuilder]
  final ThreadTapCallback? onThreadTap;

  /// Called when the "View" button on the "Also sent in channel" annotation
  /// is tapped inside a thread view.
  ///
  /// Use this to navigate to the channel screen and scroll to / highlight
  /// the given [Message].
  ///
  /// When null and the thread was opened via the default [threadBuilder]
  /// navigation, the thread screen is automatically popped and the channel
  /// list scrolls to the message. Provide this callback to override that
  /// behaviour — for example when the thread is opened from a thread list
  /// or deep link where popping would not land on the channel screen.
  final void Function(Message message)? onViewInChannelTap;

  /// {@macro onEditMessageTap}
  ///
  /// If provided, the inline edit flow is used instead of the edit bottom sheet.
  final void Function(Message)? onEditMessageTap;

  /// Called when the reply action is triggered on a message.
  ///
  /// Forwarded to each [StreamMessageItem] in the list.
  final void Function(Message)? onReplyTap;

  /// Called when a user avatar is tapped.
  ///
  /// Forwarded to each [StreamMessageItem] in the list.
  final void Function(User)? onUserAvatarTap;

  /// Called when the message reactions are tapped.
  ///
  /// Forwarded to each [StreamMessageItem] in the list.
  final void Function(Message)? onReactionsTap;

  /// Called when a quoted message is tapped.
  ///
  /// When provided, this callback is forwarded to each
  /// [StreamMessageItem] in the list.
  ///
  /// When null (the default), tapping a quoted message scrolls to it in
  /// the list, loading it if necessary.
  final void Function(Message quotedMessage)? onQuotedMessageTap;

  /// Called when a link is tapped in message text.
  ///
  /// Receives the [Message] containing the link and the tapped URL.
  /// Forwarded to each [StreamMessageItem] in the list.
  final void Function(Message message, String url)? onMessageLinkTap;

  /// Called when a user mention is tapped in message text.
  ///
  /// Forwarded to each [StreamMessageItem] in the list.
  final void Function(User user)? onUserMentionTap;

  /// Index of an item to initially align within the viewport.
  final int? initialScrollIndex;

  /// Determines where the leading edge of the item at [initialScrollIndex]
  /// should be placed.
  final double? initialAlignment;

  /// Controller for jumping or scrolling to an item.
  final ItemScrollController? scrollController;

  /// Provides a listenable iterable of [itemPositions] of items that are on
  /// screen and their locations.
  final ItemPositionsListener? itemPositionListener;

  /// Called when a regular message is tapped.
  ///
  /// For system, ephemeral, and moderated messages, use [onSystemMessageTap],
  /// [onEphemeralMessageTap], and [onModeratedMessageTap] respectively.
  final OnMessageTap? onMessageTap;

  /// Called when system message is tapped.
  final OnMessageTap? onSystemMessageTap;

  /// Called when ephemeral message is tapped.
  final OnMessageTap? onEphemeralMessageTap;

  /// Called when moderated message is tapped.
  final OnMessageTap? onModeratedMessageTap;

  /// Called when a regular message is long pressed.
  final OnMessageLongPress? onMessageLongPress;

  /// A [MessageListController] allows pagination.
  ///
  /// Use [ChannelListController.paginateData] pagination.
  final MessageListController? messageListController;

  /// Behavior flags for this message list view.
  ///
  /// Controls things like [StreamMessageListViewConfiguration.swipeToReply],
  /// [StreamMessageListViewConfiguration.markReadWhenAtTheBottom], scroll
  /// physics, and other non-builder, non-theme settings.
  ///
  /// Defaults to [StreamMessageListViewConfiguration] with all defaults.
  final StreamMessageListViewConfiguration config;

  /// Custom slot builders for this message list view.
  ///
  /// Use these to replace individual parts of the list UI (loading state,
  /// empty state, date dividers, scroll-to-bottom button, etc.).
  ///
  /// Defaults to [StreamMessageListViewBuilders] with no overrides.
  final StreamMessageListViewBuilders builders;

  @override
  _StreamMessageListViewState createState() => _StreamMessageListViewState();
}

class _StreamMessageListViewState extends State<StreamMessageListView> {
  ItemScrollController? _scrollController;
  void Function(Message parentMessage, Message? threadMessage)? _onThreadTap;
  final ValueNotifier<bool> _showScrollToBottom = ValueNotifier(false);
  late final ItemPositionsListener _itemPositionListener;
  int? _messageListLength;
  StreamChannelState? streamChannel;
  late StreamChatThemeData _streamTheme;
  late int unreadCount;

  double get _initialAlignment {
    final initialAlignment = widget.initialAlignment;
    if (initialAlignment != null) return initialAlignment;
    return initialIndex == 0 ? 0 : 0.5;
  }

  bool get _upToDate => streamChannel!.channel.state!.isUpToDate;

  bool get _isThreadConversation => widget.parentMessage != null;

  bool _bottomPaginationActive = false;

  int initialIndex = 0;
  double initialAlignment = 0;

  List<Message> messages = <Message>[];
  Map<String, int> messagesIndex = {};

  String? _highlightedMessageId;
  int _highlightGeneration = 0;

  bool _inBetweenList = false;

  late final _defaultController = MessageListController();

  MessageListController get _messageListController => widget.messageListController ?? _defaultController;

  StreamSubscription? _messageNewListener;
  StreamSubscription? _userReadListener;

  Message? _firstUnreadMessage;

  @override
  void initState() {
    super.initState();

    _scrollController = widget.scrollController ?? ItemScrollController();
    _itemPositionListener = widget.itemPositionListener ?? ItemPositionsListener.create();
    _itemPositionListener.itemPositions.addListener(_handleItemPositionsChanged);

    _getOnThreadTap();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newStreamChannel = StreamChannel.of(context);
    _streamTheme = StreamChatTheme.of(context);

    if (newStreamChannel != streamChannel) {
      streamChannel = newStreamChannel;

      debouncedMarkRead.cancel();
      debouncedMarkThreadRead.cancel();

      _messageNewListener?.cancel();
      _userReadListener?.cancel();

      unreadCount = streamChannel?.channel.state?.unreadCount ?? 0;
      _firstUnreadMessage = streamChannel?.getFirstUnreadMessage();

      final highlightMessageId = widget.config.highlightInitialMessage
          ? (streamChannel?.initialMessageId ?? _ThreadHighlightScope.of(context))
          : null;

      if (highlightMessageId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _moveToAndHighlight(
            messages: messages,
            messageId: highlightMessageId,
            initialScrollIndex: widget.initialScrollIndex,
            scrollTo: false,
          );
        });
      } else {
        initialIndex = getInitialIndex(
          widget.initialScrollIndex,
          streamChannel!,
          widget.messageFilter,
        );
        initialAlignment = _initialAlignment;
      }

      if (_scrollController?.isAttached == true) {
        _scrollController?.jumpTo(
          index: initialIndex,
          alignment: initialAlignment,
        );
      }

      _messageNewListener = streamChannel!.channel.on(EventType.messageNew).listen((event) {
        if (_upToDate) {
          _bottomPaginationActive = false;
        }
        if (event.message?.parentId == widget.parentMessage?.id &&
            event.message!.user!.id == streamChannel!.channel.client.state.currentUser!.id) {
          setState(() => unreadCount = 0);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController?.jumpTo(
              index: 0,
            );
          });
        }
      });

      _userReadListener = streamChannel!.channel.state?.readStream.listen(
        (event) => setState(() {
          unreadCount = streamChannel!.channel.state?.unreadCount ?? 0;
          _firstUnreadMessage = streamChannel?.getFirstUnreadMessage();
        }),
      );
    }
  }

  @override
  void dispose() {
    debouncedMarkRead.cancel();
    debouncedMarkThreadRead.cancel();
    _messageNewListener?.cancel();
    _userReadListener?.cancel();
    _itemPositionListener.itemPositions.removeListener(_handleItemPositionsChanged);
    super.dispose();
  }

  // Duration of the programmatic scroll triggered by [_moveToAndHighlight].
  static const _kScrollToDuration = Duration(seconds: 1);

  // The highlight pulses on the target message after a jump: it stays at full
  // color for [_kHighlightHoldDuration], then fades to transparent over
  // [_kHighlightFadeDuration]. Tuned to feel like Slack's permalink jump —
  // a clearly visible hold so the user can confirm "this is the message",
  // followed by a graceful fade.
  static const _kHighlightHoldDuration = Duration(seconds: 1);
  static const _kHighlightFadeDuration = Duration(seconds: 1);

  void _highlightMessage(String messageId) {
    setState(() {
      _highlightedMessageId = messageId;
      _highlightGeneration++;
    });
  }

  Future<void> _moveToAndHighlight({
    required List<Message> messages,
    String? messageId,
    int? initialScrollIndex,
    bool scrollTo = true,
  }) async {
    if (messageId != null) {
      // In a thread the parent message lives outside the `messages` list and
      // is rendered as the very last item, so search for it explicitly when a
      // thread reply quotes it.
      final isThreadParent = _isThreadConversation && messageId == widget.parentMessage?.id;
      final index = isThreadParent ? messages.length + 2 : messages.indexWhere((m) => m.id == messageId);

      if (index >= 0) {
        // Wait for the scroll to settle before flagging the message as
        // highlighted; otherwise the highlight tween fires while the list is
        // still animating (or before the target item is even mounted) and the
        // user only sees the tail end of the fade.
        if (scrollTo) {
          await _scrollController?.scrollTo(
            index: index + 2, // +2 to account for loader and footer
            duration: _kScrollToDuration,
            curve: Curves.easeInOut,
            alignment: 0.1,
          );
        } else {
          _scrollController?.jumpTo(
            index: index + 2, // +2 to account for loader and footer
            alignment: 0.1,
          );
        }
      } else {
        await streamChannel!.loadChannelAtMessage(messageId).then((_) async {
          initialIndex = getInitialIndex(
            initialScrollIndex,
            streamChannel!,
            widget.messageFilter,
            messageId: messageId,
          );
          initialAlignment = 0.1;
        });
      }
    } else if (initialScrollIndex != null) {
      _scrollController?.jumpTo(
        index: initialScrollIndex,
        alignment: initialAlignment,
      );
    }

    if (messageId != null && mounted) {
      _highlightMessage(messageId);
    }
  }

  // Wraps [child] in the highlight pulse if [message] is the currently
  // highlighted message. Holds at full color for [_kHighlightHoldDuration],
  // then fades to transparent over [_kHighlightFadeDuration].
  Widget _maybeWrapWithHighlight({required Message message, required Widget child}) {
    if (_highlightedMessageId != message.id) return child;

    final colorScheme = context.streamColorScheme;
    final highlightColor =
        StreamMessageListViewTheme.of(context).messageHighlightColor ?? colorScheme.backgroundHighlight;

    // Drive the whole sequence (hold + fade) with a single tween whose curve is
    // clamped to the trailing fade window — this gives us the hold for free.
    final totalMs = _kHighlightHoldDuration.inMilliseconds + _kHighlightFadeDuration.inMilliseconds;
    final fadeStart = _kHighlightHoldDuration.inMilliseconds / totalMs;

    return TweenAnimationBuilder<Color?>(
      key: ValueKey('highlight-$_highlightGeneration'),
      tween: ColorTween(begin: highlightColor, end: highlightColor.withValues(alpha: 0)),
      duration: Duration(milliseconds: totalMs),
      curve: Interval(fadeStart, 1, curve: Curves.easeOut),
      onEnd: () {
        if (_highlightedMessageId == message.id) {
          setState(() => _highlightedMessageId = null);
        }
      },
      builder: (_, color, child) => ColoredBox(color: color!, child: child),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget defaultLoadingBuilder(BuildContext context) {
      if (widget.builders.loading != null) return widget.builders.loading!(context);
      return const StreamMessageListSkeletonLoading();
    }

    Widget defaultEmptyBuilder(BuildContext context) {
      if (widget.builders.empty != null) return widget.builders.empty!(context);
      return const StreamMessageListEmptyState();
    }

    Widget defaultErrorBuilder(BuildContext context, Object error) {
      if (widget.builders.error != null) return widget.builders.error!(context, error);
      return Center(
        child: Text(
          context.translations.genericErrorText,
          style: context.streamTextTheme.captionDefault.copyWith(
            color: context.streamColorScheme.textPrimary
                // ignore: deprecated_member_use
                .withOpacity(0.5),
          ),
        ),
      );
    }

    Widget defaultMessageListBuilder(BuildContext context, List<Message> list) {
      if (widget.builders.content != null) return widget.builders.content!(context, list);
      return _buildListView(list);
    }

    // TODO: Revisit this nested Portal setup during desktop reactions refactor
    // and remove the extra layer if a dedicated message-list portal label is
    // no longer required.
    return Portal(
      labels: const [kPortalMessageListViewLabel],
      child: Portal(
        child: ScaffoldMessenger(
          child: MessageListCore(
            paginationLimit: widget.config.paginationLimit,
            messageFilter: widget.messageFilter,
            loadingBuilder: defaultLoadingBuilder,
            emptyBuilder: defaultEmptyBuilder,
            messageListBuilder: defaultMessageListBuilder,
            messageListController: _messageListController,
            parentMessage: widget.parentMessage,
            errorBuilder: defaultErrorBuilder,
          ),
        ),
      ),
    );
  }

  Widget _buildListView(List<Message> data) {
    messages = data;

    for (var index = 0; index < messages.length; index++) {
      messagesIndex[messages[index].id] = index;
    }
    final newMessagesListLength = messages.length;

    if (_messageListLength != null) {
      if (_bottomPaginationActive || (_inBetweenList && _upToDate)) {
        if (_itemPositionListener.itemPositions.value.isNotEmpty) {
          final first = _itemPositionListener.itemPositions.value.first;
          final diff = newMessagesListLength - _messageListLength!;
          if (diff > 0) {
            if (messages[0].user?.id != streamChannel!.channel.client.state.currentUser?.id) {
              initialIndex = first.index + diff;
              initialAlignment = first.itemLeadingEdge;
            }
          }
        }
      }
    }

    _messageListLength = newMessagesListLength;

    final hasHeader = widget.builders.header != null;
    final hasFooter = widget.builders.footer != null;

    final itemCount =
        messages.length + // total messages
        2 + // top + bottom loading indicator
        2 + // header + footer
        1 // parent message
        ;

    final child = Stack(
      alignment: Alignment.center,
      children: [
        StreamConnectionStatusBuilder(
          statusBuilder: (context, status) {
            var statusString = '';
            var showStatus = true;
            switch (status) {
              case ConnectionStatus.connected:
                statusString = context.translations.connectedLabel;
                showStatus = false;
                break;
              case ConnectionStatus.connecting:
                statusString = context.translations.reconnectingLabel;
                break;
              case ConnectionStatus.disconnected:
                statusString = context.translations.disconnectedLabel;
                break;
            }

            return StreamInfoTile(
              showMessage: widget.config.showConnectionStateTile && showStatus,
              tileAnchor: Alignment.topCenter,
              childAnchor: Alignment.topCenter,
              message: statusString,
              child: LazyLoadScrollView(
                onStartOfPage: () async {
                  _inBetweenList = false;
                  if (!_upToDate) {
                    _bottomPaginationActive = true;
                    return _paginateData(
                      streamChannel,
                      QueryDirection.bottom,
                    );
                  }
                },
                onEndOfPage: () async {
                  _inBetweenList = false;
                  _bottomPaginationActive = false;
                  return _paginateData(
                    streamChannel,
                    QueryDirection.top,
                  );
                },
                onInBetweenOfPage: () {
                  _inBetweenList = true;
                },
                child: ScrollablePositionedList.separated(
                  key: (initialIndex != 0 && initialAlignment != 0)
                      ? ValueKey('$initialIndex-$initialAlignment')
                      : null,
                  padding: .symmetric(vertical: context.streamSpacing.sm),
                  keyboardDismissBehavior: widget.config.keyboardDismissBehavior,
                  itemPositionsListener: _itemPositionListener,
                  initialScrollIndex: initialIndex,
                  initialAlignment: initialAlignment,
                  physics: widget.config.scrollPhysics,
                  itemScrollController: _scrollController,
                  reverse: widget.config.reverse,
                  shrinkWrap: widget.config.shrinkWrap,
                  itemCount: itemCount,

                  // Commented out as it is not working as expected.
                  // The list view gets broken in the following case:
                  // * The list view is loaded at a particular message (eg: Last Read, or a quoted message)
                  //   and a new message is added to the list view.
                  //
                  // Issues faced:
                  // * https://github.com/GetStream/stream-chat-flutter/issues/1576
                  // * https://github.com/GetStream/stream-chat-flutter/issues/1414
                  //
                  // Related issues: https://github.com/flutter/flutter/issues/107123
                  //
                  // findChildIndexCallback: (Key key) {
                  //   final indexedKey = key as IndexedKey;
                  //   final valueKey = indexedKey.key as ValueKey<String>?;
                  //   if (valueKey != null) {
                  //     final index = messagesIndex[valueKey.value];
                  //     if (index != null) {
                  //       // The calculation is as follows:
                  //       // * Add 2 to the index retrieved to account for the footer and the bottom loader.
                  //       // * Multiply the result by 2 to account for the separators between each pair of items.
                  //       // * Subtract 1 to adjust for the 0-based indexing of the list view.
                  //       return ((index + 2) * 2) - 1;
                  //     }
                  //   }
                  //   return null;
                  // },

                  // Item Count -> 8 (1 parent, 2 header+footer, 2 top+bottom, 3 messages)
                  // eg:     |Type|         rev(|Index(item)|)     rev(|Index(separator)|)    |Index(item)|    |Index(separator)|
                  //     ParentMessage  ->        7                                             (count-1)
                  //        Separator(ThreadSeparator)          ->           6                                      (count-2)
                  //     Header         ->        6                                             (count-2)
                  //        Separator(Header -> 8??T -> 0||52)  ->           5                                      (count-3)
                  //     TopLoader      ->        5                                             (count-3)
                  //        Separator(0)                        ->           4                                      (count-4)
                  //     Message        ->        4                                             (count-4)
                  //        Separator(2||8)                     ->           3                                      (count-5)
                  //     Message        ->        3                                             (count-5)
                  //        Separator(2||8)                     ->           2                                      (count-6)
                  //     Message        ->        2                                             (count-6)
                  //        Separator(0)                        ->           1                                      (count-7)
                  //     BottomLoader   ->        1                                             (count-7)
                  //        Separator(Footer -> 8??30)          ->           0                                      (count-8)
                  //     Footer         ->        0                                             (count-8)
                  separatorBuilder: (context, i) {
                    Widget maybeBuildWithUnreadMessagesSeparator({
                      required Message message,
                      required Widget separator,
                    }) {
                      if (unreadCount == 0) return separator;
                      if (_isThreadConversation) return separator;
                      if (_firstUnreadMessage?.id != message.id) return separator;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          separator,
                          _buildUnreadMessagesSeparator(unreadCount),
                        ],
                      );
                    }

                    if (i == itemCount - 2) {
                      if (widget.parentMessage == null) {
                        return const Empty();
                      }

                      if (widget.builders.threadSeparator != null) {
                        return widget.builders.threadSeparator!(context, widget.parentMessage!);
                      }

                      return ThreadSeparator(parentMessage: widget.parentMessage!);
                    }
                    if (i == itemCount - 3) {
                      if (widget.config.reverse ? !hasHeader : !hasFooter) {
                        if (messages.isNotEmpty) {
                          final message = messages.last;
                          return maybeBuildWithUnreadMessagesSeparator(
                            message: message,
                            separator: _buildDateDivider(message),
                          );
                        }

                        return const Empty();
                      }
                      return const SizedBox(height: 8);
                    }
                    if (i == 0) {
                      if (widget.config.reverse ? !hasFooter : !hasHeader) {
                        return const Empty();
                      }
                      return const SizedBox(height: 8);
                    }

                    if (i == 1 || i == itemCount - 4) return const Empty();

                    late final Message message, nextMessage;
                    if (widget.config.reverse) {
                      message = messages[i - 1];
                      nextMessage = messages[i - 2];
                    } else {
                      message = messages[i - 2];
                      nextMessage = messages[i - 1];
                    }

                    Widget separator;

                    final spacingRules = _resolveSpacingRules(
                      message: message,
                      nextMessage: nextMessage,
                    );

                    if (spacingRules == null) {
                      separator = _buildDateDivider(nextMessage);
                    } else {
                      separator =
                          widget.builders.spacing?.call(context, spacingRules) ??
                          _defaultSpacingWidget(context, spacingRules);
                    }

                    return maybeBuildWithUnreadMessagesSeparator(
                      message: nextMessage,
                      separator: separator,
                    );
                  },
                  itemBuilder: (context, i) {
                    if (i == itemCount - 1) {
                      if (widget.parentMessage == null) {
                        return const Empty();
                      }
                      return buildParentMessage(widget.parentMessage!);
                    }

                    if (i == itemCount - 2) {
                      if (widget.config.reverse) {
                        return widget.builders.header?.call(context) ?? const Empty();
                      } else {
                        return widget.builders.footer?.call(context) ?? const Empty();
                      }
                    }

                    if (i == itemCount - 3) {
                      return _buildPaginationLoadingIndicator(
                        context: context,
                        direction: QueryDirection.top,
                      );
                    }

                    if (i == 1) {
                      return _buildPaginationLoadingIndicator(
                        context: context,
                        direction: QueryDirection.bottom,
                      );
                    }

                    if (i == 0) {
                      if (widget.config.reverse) {
                        return widget.builders.footer?.call(context) ?? const Empty();
                      } else {
                        return widget.builders.header?.call(context) ?? const Empty();
                      }
                    }

                    // Offset the index to account for two extra items
                    // (loader and footer) at the bottom of the ListView.
                    final messageIndex = i - 2;
                    final message = messages[messageIndex];

                    return KeyedSubtree(
                      key: ValueKey(message.id),
                      child: buildMessage(message, messages, messageIndex),
                    );
                  },
                ),
              ),
            );
          },
        ),
        if (widget.config.showFloatingDateDivider)
          Positioned(
            top: context.streamSpacing.sm,
            child: FloatingDateDivider(
              itemCount: itemCount,
              reverse: widget.config.reverse,
              fadeNearInlineDivider: widget.config.fadeFloatingDateDividerNearInline,
              itemPositionListener: _itemPositionListener.itemPositions,
              messages: messages,
              dateDividerBuilder: _resolveFloatingDateDividerBuilder(),
            ),
          ),
        if (widget.config.showScrollToBottom)
          BetterStreamBuilder<bool>(
            stream: streamChannel!.channel.state!.isUpToDateStream,
            initialData: streamChannel!.channel.state!.isUpToDate,
            builder: (context, snapshot) => ValueListenableBuilder<bool>(
              valueListenable: _showScrollToBottom,
              child: _buildScrollToBottom(),
              builder: (context, value, child) {
                if (!snapshot || value) return child!;
                return const Empty();
              },
            ),
          ),
        if (widget.config.showUnreadIndicator && !_isThreadConversation)
          Positioned(
            top: context.streamSpacing.sm,
            child: UnreadIndicatorButton(
              onJumpTap: scrollToUnreadDefaultTapAction,
              onDismissTap: _markMessagesAsRead,
            ),
          ),
      ],
    );

    final backgroundColor = StreamMessageListViewTheme.of(context).backgroundColor;
    final backgroundImage = StreamMessageListViewTheme.of(context).backgroundImage;

    if (backgroundColor != null || backgroundImage != null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          image: backgroundImage,
        ),
        child: child,
      );
    }

    return child;
  }

  // Default spacing widget between adjacent messages — mirrors the old
  // _defaultSpacingWidgetBuilder static method.
  Widget _defaultSpacingWidget(BuildContext context, List<SpacingType> spacingTypes) {
    final spacing = context.streamSpacing;
    if (spacingTypes.contains(SpacingType.otherUser)) return SizedBox(height: spacing.md);
    if (spacingTypes.contains(SpacingType.timeDiff)) return SizedBox(height: spacing.xs);
    return SizedBox(height: spacing.xxs);
  }

  // Resolves the builder for the floating date divider.
  // Falls back to the inline date divider builder if no floating-specific one is set.
  Widget Function(DateTime)? _resolveFloatingDateDividerBuilder() {
    return widget.builders.floatingDateDivider ?? widget.builders.dateDivider;
  }

  Widget _buildPaginationLoadingIndicator({
    required BuildContext context,
    required QueryDirection direction,
  }) {
    return LoadingIndicator(
      direction: direction,
      streamTheme: _streamTheme,
      streamChannelState: streamChannel!,
      isThreadConversation: _isThreadConversation,
      indicatorBuilder: widget.builders.paginationLoadingIndicator,
    );
  }

  Widget _buildUnreadMessagesSeparator(int unreadCount) {
    if (widget.builders.unreadMessagesSeparator != null) {
      return widget.builders.unreadMessagesSeparator!(context, unreadCount);
    }
    return UnreadMessagesSeparator(unreadCount: unreadCount);
  }

  Future<void> _paginateData(
    StreamChannelState? channel,
    QueryDirection direction,
  ) => _messageListController.paginateData!(direction: direction);

  Future<void> scrollToBottomDefaultTapAction(int unreadCount) async {
    // If the channel is not up to date, we need to reload it before scrolling
    // to the end of the list.
    if (!_upToDate) {
      // Reset the pagination variables.
      initialIndex = 0;
      initialAlignment = 0;
      _bottomPaginationActive = false;

      // Reload the channel to get the latest messages.
      await streamChannel!.reloadChannel();

      // Wait for the frame to be rendered with the updated channel state.
      await WidgetsBinding.instance.endOfFrame;
    }

    // Scroll to the end of the list.
    if (_scrollController?.isAttached == true) {
      return _scrollController!.scrollTo(
        index: 0,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> scrollToUnreadDefaultTapAction(String? lastReadMessageId) async {
    // Scroll to the first unread message in the list.
    final firstUnreadMessageIndex = messages.indexWhere((it) {
      return it.id == _firstUnreadMessage?.id;
    });

    if (firstUnreadMessageIndex == -1) return;

    if (_scrollController?.isAttached == true) {
      return _scrollController!.scrollTo(
        index: max(firstUnreadMessageIndex + 2, 0),
        alignment: 0.5, // center the message in the viewport
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  late final debouncedMarkRead = debounce(
    ([String? id]) => streamChannel?.channel.markRead(messageId: id),
    const Duration(seconds: 1),
  );

  late final debouncedMarkThreadRead = debounce(
    (String parentId) => streamChannel?.channel.markThreadRead(parentId),
    const Duration(seconds: 1),
  );

  Future<void> _markMessagesAsRead() async {
    if (widget.parentMessage case final parent?) {
      // If we are in a thread, mark the thread as read.
      debouncedMarkThreadRead.call([parent.id]);
    } else {
      // Otherwise, mark the channel as read.
      debouncedMarkRead.call();
    }
  }

  // Determines the applicable [SpacingType]s between two adjacent messages.
  //
  // Returns `null` when the messages fall on different days, indicating a
  // date divider should be shown instead of spacing.
  //
  // Otherwise, evaluates multiple conditions and returns the list of spacing
  // rules that apply. If no specific rule matches, [SpacingType.defaultSpacing]
  // is returned.
  //
  // The rules are evaluated in the following order:
  // - [SpacingType.timeDiff] — messages are more than a minute apart.
  // - [SpacingType.otherUser] — messages belong to different groups. A group
  //   boundary is forced when either message is a system or moderated message.
  // - [SpacingType.thread] — the current message is part of a thread.
  // - [SpacingType.deleted] — the current message has been deleted.
  List<SpacingType>? _resolveSpacingRules({
    required Message message,
    required Message nextMessage,
  }) {
    final createdAt = Jiffy.parseFromDateTime(message.createdAt.toLocal());
    final nextCreatedAt = Jiffy.parseFromDateTime(nextMessage.createdAt.toLocal());

    // Different days — a date divider is needed instead of spacing.
    if (!createdAt.isSame(nextCreatedAt, unit: Unit.day)) return null;

    // Time-based: messages are more than a minute apart.
    final hasTimeDiff = !createdAt.isSame(nextCreatedAt, unit: Unit.minute);

    // System messages always form their own group.
    final isSystem = message.isSystem || nextMessage.isSystem;
    // Moderated (non-bounced error) messages always form their own group.
    final isModerated = (message.isError && !message.isBounced) || (nextMessage.isError && !nextMessage.isBounced);

    // Two messages are from the same user group only if neither is system/moderated and they share the same sender.
    final isNextUserSame = !isSystem && !isModerated && message.user!.id == nextMessage.user?.id;

    // Thread messages shown in channel are part of a thread.
    final isPartOfThread = message.replyCount! > 0 || message.showInChannel == true;

    final rules = [
      if (hasTimeDiff) SpacingType.timeDiff,
      if (!isNextUserSame) SpacingType.otherUser,
      if (isPartOfThread) SpacingType.thread,
      if (message.isDeleted) SpacingType.deleted,
    ];

    return rules.isEmpty ? [SpacingType.defaultSpacing] : rules;
  }

  Widget _buildDateDivider(Message message) {
    final createdAt = message.createdAt.toLocal();
    if (widget.builders.dateDivider != null) return widget.builders.dateDivider!(createdAt);
    return StreamDateDivider(dateTime: createdAt);
  }

  Widget buildParentMessage(Message message) {
    final parentMessageProps = StreamMessageItemProps(
      message: message,
      swipeToReply: widget.config.swipeToReply,
      onThreadTap: _onThreadTap,
      onMessageTap: widget.onMessageTap,
      onMessageLongPress: widget.onMessageLongPress,
      onEditMessageTap: widget.onEditMessageTap,
      onReplyTap: widget.onReplyTap,
      onUserAvatarTap: widget.onUserAvatarTap,
      onReactionsTap: widget.onReactionsTap,
      onQuotedMessageTap: widget.onQuotedMessageTap,
      onMessageLinkTap: widget.onMessageLinkTap,
      onUserMentionTap: widget.onUserMentionTap,
    );

    final userId = StreamChat.of(context).currentUser!.id;
    final isMyMessage = message.user?.id == userId;

    final contentKind = resolveContentKind(message);
    final isInThread = widget.parentMessage != null;

    final layout = StreamMessageLayout(
      data: StreamMessageLayoutData(
        stackPosition: .single,
        alignment: isMyMessage ? .end : .start,
        listKind: isInThread ? .thread : .channel,
        contentKind: contentKind,
      ),
      child: Builder(
        builder: (context) {
          if (widget.builders.parentMessage != null) {
            return widget.builders.parentMessage!(context, message, parentMessageProps);
          }
          return StreamMessageItem.fromProps(props: parentMessageProps);
        },
      ),
    );

    return _maybeWrapWithHighlight(message: message, child: layout);
  }

  Widget _buildScrollToBottom() {
    return StreamBuilder<int>(
      stream: streamChannel!.channel.state!.unreadCountStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Empty();
        } else if (!snapshot.hasData) {
          return const Empty();
        }
        final unreadCount = snapshot.data!;

        if (widget.builders.scrollToBottomButton != null) {
          return widget.builders.scrollToBottomButton!(
            unreadCount,
            scrollToBottomDefaultTapAction,
          );
        }

        final showUnreadCount =
            unreadCount > 0 &&
            streamChannel!.channel.state!.members.any(
              (e) => e.userId == streamChannel!.channel.client.state.currentUser!.id,
            );

        Widget button = StreamButton.icon(
          style: .secondary,
          type: .outline,
          size: .medium,
          isFloating: true,
          icon: switch (widget.config.reverse) {
            true => Icon(context.streamIcons.arrowDown),
            false => Icon(context.streamIcons.arrowUp),
          },
          onPressed: () => scrollToBottomDefaultTapAction(unreadCount),
        );

        if (showUnreadCount && widget.config.showUnreadCountOnScrollToBottom) {
          button = StreamBadgeNotification(
            label: '${unreadCount > 99 ? '99+' : unreadCount}',
            child: button,
          );
        }

        return PositionedDirectional(
          bottom: 16,
          end: 16,
          child: button,
        );
      },
    );
  }

  Widget buildSystemMessage(Message message) {
    if (widget.builders.systemMessage != null) {
      return widget.builders.systemMessage!(context, message);
    }
    return StreamSystemMessage(
      message: message,
      onMessageTap: widget.onSystemMessageTap,
    );
  }

  Widget buildModeratedMessage(Message message) {
    if (widget.builders.moderatedMessage != null) {
      return widget.builders.moderatedMessage!(context, message);
    }
    return StreamModeratedMessage(
      message: message,
      onMessageTap: widget.onModeratedMessageTap,
    );
  }

  Widget buildEphemeralMessage(Message message) {
    if (widget.builders.ephemeralMessage != null) {
      return widget.builders.ephemeralMessage!(context, message);
    }
    return StreamEphemeralMessage(
      message: message,
      onMessageTap: widget.onEphemeralMessageTap,
    );
  }

  Widget buildMessage(Message message, List<Message> messages, int index) {
    if (message.isSystem) {
      return buildSystemMessage(message);
    }

    if (message.isEphemeral) {
      return buildEphemeralMessage(message);
    }

    if (message.isError && !message.isBounced) {
      return buildModeratedMessage(message);
    }

    final messageItemProps = StreamMessageItemProps(
      message: message,
      swipeToReply: widget.config.swipeToReply,
      onThreadTap: _onThreadTap,
      onViewInChannelTap: _isThreadConversation
          ? widget.onViewInChannelTap ?? (message) => Navigator.of(context).pop(message.id)
          : null,
      onMessageTap: widget.onMessageTap,
      onMessageLongPress: widget.onMessageLongPress,
      onEditMessageTap: widget.onEditMessageTap,
      onReplyTap: widget.onReplyTap,
      onUserAvatarTap: widget.onUserAvatarTap,
      onReactionsTap: widget.onReactionsTap,
      onMessageLinkTap: widget.onMessageLinkTap,
      onUserMentionTap: widget.onUserMentionTap,
      onQuotedMessageTap: switch (widget.onQuotedMessageTap) {
        final onTap? => onTap,
        _ => (quotedMessage) => _moveToAndHighlight(
          messageId: quotedMessage.id,
          messages: messages,
        ),
      },
    );

    final userId = StreamChat.of(context).currentUser!.id;
    final isMyMessage = message.user?.id == userId;
    final nextMessage = index - 1 >= 0 ? messages[index - 1] : null;
    final prevMessage = index + 1 < messages.length ? messages[index + 1] : null;

    final contentKind = resolveContentKind(message);
    final isInThread = widget.parentMessage != null;
    final stackPosition = computeStackPosition(message: message, previous: prevMessage, next: nextMessage);

    final layout = StreamMessageLayout(
      data: StreamMessageLayoutData(
        stackPosition: stackPosition,
        alignment: isMyMessage ? .end : .start,
        listKind: isInThread ? .thread : .channel,
        contentKind: contentKind,
      ),
      child: Builder(
        builder: (context) {
          if (widget.messageBuilder != null) {
            return widget.messageBuilder!(context, message, messageItemProps);
          }
          return StreamMessageItem.fromProps(props: messageItemProps);
        },
      ),
    );

    return _maybeWrapWithHighlight(message: message, child: layout);
  }

  void _handleItemPositionsChanged() {
    final itemPositions = _itemPositionListener.itemPositions.value.toList();
    if (itemPositions.isEmpty) return;

    // Index of the last item in the list view is 2 as 1 is the progress
    // indicator and 0 is the footer.
    const lastItemIndex = 2;
    final lastItemPosition = itemPositions.firstWhereOrNull(
      (position) => position.index == lastItemIndex,
    );

    var isLastItemFullyVisible = false;
    if (lastItemPosition != null) {
      // We consider the last item fully visible if its leading edge (reversed)
      // is greater than or equal to 0.
      isLastItemFullyVisible = lastItemPosition.itemLeadingEdge >= 0;
    }

    if (mounted) _showScrollToBottom.value = !isLastItemFullyVisible;
    if (isLastItemFullyVisible) return _handleLastItemFullyVisible();
  }

  Message? _lastFullyVisibleMessage;
  void _handleLastItemFullyVisible() {
    // We are using the first message as the last fully visible message
    // because the messages are reversed in the list view.
    final newLastFullyVisibleMessage = messages.firstOrNull;

    final lastFullyVisibleMessageChanged = switch (_lastFullyVisibleMessage) {
      final message? => message.id != newLastFullyVisibleMessage?.id,
      null => true, // Allows setting the initial value.
    };

    // If the last fully visible message has been changed, we need to update the
    // value and maybe mark messages as read if needed.
    if (lastFullyVisibleMessageChanged) {
      _lastFullyVisibleMessage = newLastFullyVisibleMessage;

      // Mark messages as read if needed.
      if (widget.config.markReadWhenAtTheBottom) {
        _maybeMarkMessagesAsRead().ignore();
      }
    }
  }

  // Marks messages as read if the conditions are met.
  //
  // The conditions are:
  // 1. The channel is up to date or we are in a thread conversation.
  // 2. There are unread messages or we are in a thread conversation.
  //
  // If any of the conditions are not met, the function returns early.
  // Otherwise, it calls the _markMessagesAsRead function to mark the messages
  // as read.
  Future<void> _maybeMarkMessagesAsRead() async {
    final channel = streamChannel?.channel;
    if (channel == null) return;

    final isInThread = widget.parentMessage != null;

    final isUpToDate = channel.state?.isUpToDate ?? false;
    if (!isInThread && !isUpToDate) return;

    final hasUnread = (channel.state?.unreadCount ?? 0) > 0;
    if (!isInThread && !hasUnread) return;

    // Mark messages as read if it's allowed.
    return _markMessagesAsRead();
  }

  void _getOnThreadTap() {
    _onThreadTap = switch ((widget.onThreadTap, widget.threadBuilder)) {
      // Case 1: widget.onThreadTap is provided.
      // The created callback will use widget.onThreadTap, passing the result
      // of widget.threadBuilder (if provided) as the second argument.
      (final onThreadTap?, final threadBuilder) => (Message parentMessage, Message? threadMessage) {
        onThreadTap(
          parentMessage,
          threadBuilder?.call(context, parentMessage),
        );
      },
      // Case 2: widget.onThreadTap is null, but widget.threadBuilder is provided.
      // The created callback will perform the default navigation action,
      // using widget.threadBuilder to build the thread page.
      (null, final threadBuilder?) => (Message parentMessage, Message? threadMessage) async {
        Widget threadPage = StreamChatConfiguration(
          // This is needed to provide the nearest reaction icons to the
          // StreamMessageReactionsModal.
          data: StreamChatConfiguration.of(context),
          child: StreamChannel(
            channel: streamChannel!.channel,
            child: BetterStreamBuilder<Message>(
              initialData: parentMessage,
              stream: streamChannel!.channel.state?.messagesStream.map(
                (it) => it.firstWhere((m) => m.id == parentMessage.id),
              ),
              builder: (_, data) => threadBuilder(context, data),
            ),
          ),
        );

        if (threadMessage != null) {
          threadPage = _ThreadHighlightScope(
            messageId: threadMessage.id,
            child: threadPage,
          );
        }

        final result = await Navigator.of(context).push<String>(
          MaterialPageRoute(builder: (_) => threadPage),
        );

        if (result != null && mounted) {
          _moveToAndHighlight(messageId: result, messages: messages);
        }
      },
      _ => null,
    };
  }
}

class _ThreadHighlightScope extends InheritedWidget {
  const _ThreadHighlightScope({
    required this.messageId,
    required super.child,
  });

  final String messageId;

  static String? of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<_ThreadHighlightScope>()?.messageId;
  }

  @override
  bool updateShouldNotify(_ThreadHighlightScope oldWidget) => messageId != oldWidget.messageId;
}
