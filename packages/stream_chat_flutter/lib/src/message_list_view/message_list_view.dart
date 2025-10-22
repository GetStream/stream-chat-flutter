// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/src/message_list_view/floating_date_divider.dart';
import 'package:stream_chat_flutter/src/message_list_view/loading_indicator.dart';
import 'package:stream_chat_flutter/src/message_list_view/mlv_utils.dart';
import 'package:stream_chat_flutter/src/message_list_view/thread_separator.dart';
import 'package:stream_chat_flutter/src/message_list_view/unread_indicator_button.dart';
import 'package:stream_chat_flutter/src/message_list_view/unread_messages_separator.dart';
import 'package:stream_chat_flutter/src/message_widget/ephemeral_message.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
///           StreamMessageInput(),
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
    this.showScrollToBottom = true,
    this.showUnreadCountOnScrollToBottom = false,
    this.scrollToBottomBuilder,
    this.showUnreadIndicator = true,
    this.unreadIndicatorBuilder,
    this.markReadWhenAtTheBottom = true,
    this.messageBuilder,
    this.parentMessageBuilder,
    this.parentMessage,
    this.threadBuilder,
    this.onThreadTap,
    this.dateDividerBuilder,
    this.floatingDateDividerBuilder,
    // we need to use ClampingScrollPhysics to avoid the list view to bounce
    // when we are at the either end of the list view and try to use 'animateTo'
    // to animate in the same direction.
    this.scrollPhysics = const ClampingScrollPhysics(),
    this.initialScrollIndex,
    this.initialAlignment,
    this.scrollController,
    this.itemPositionListener,
    this.highlightInitialMessage = false,
    this.messageHighlightColor,
    this.showConnectionStateTile = false,
    this.headerBuilder,
    this.footerBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.systemMessageBuilder,
    this.ephemeralMessageBuilder,
    this.moderatedMessageBuilder,
    this.messageListBuilder,
    this.errorBuilder,
    this.messageFilter,
    this.onMessageTap,
    this.onSystemMessageTap,
    this.onEphemeralMessageTap,
    this.onModeratedMessageTap,
    this.onMessageLongPress,
    this.showFloatingDateDivider = true,
    this.threadSeparatorBuilder,
    this.unreadMessagesSeparatorBuilder,
    this.messageListController,
    this.reverse = true,
    this.shrinkWrap = false,
    this.paginationLimit = 20,
    this.paginationLoadingIndicatorBuilder,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.spacingWidgetBuilder = _defaultSpacingWidgetBuilder,
  });

  /// [ScrollViewKeyboardDismissBehavior] the defines how this [PositionedList] will
  /// dismiss the keyboard automatically.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// {@macro messageBuilder}
  final MessageBuilder? messageBuilder;

  /// Whether the view scrolls in the reading direction.
  ///
  /// Defaults to true.
  ///
  /// See [ScrollView.reverse].
  final bool reverse;

  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  ///  Defaults to false.
  ///
  /// See [ScrollView.shrinkWrap].
  final bool shrinkWrap;

  /// Limit used during pagination
  final int paginationLimit;

  /// {@macro systemMessageBuilder}
  final SystemMessageBuilder? systemMessageBuilder;

  /// {@macro ephemeralMessageBuilder}
  final EphemeralMessageBuilder? ephemeralMessageBuilder;

  /// {@macro moderatedMessageBuilder}
  final ModeratedMessageBuilder? moderatedMessageBuilder;

  /// {@macro parentMessageBuilder}
  final ParentMessageBuilder? parentMessageBuilder;

  /// {@macro threadBuilder}
  final ThreadBuilder? threadBuilder;

  /// {@macro threadTapCallback}
  ///
  /// By default it calls [Navigator.push] using the widget
  /// built using [threadBuilder]
  final ThreadTapCallback? onThreadTap;

  /// If true will show a scroll to bottom button when
  /// the scroll offset is not zero
  final bool showScrollToBottom;

  /// If true will show an indicator with number of unread messages
  /// on scroll to bottom button
  final bool showUnreadCountOnScrollToBottom;

  /// Function used to build a custom scroll to bottom widget
  ///
  /// Provides the current unread messages count and a reference
  /// to the function that is executed on tap of this widget by default
  ///
  /// As an example:
  /// ```
  /// MessageListView(
  ///   scrollToBottomBuilder: (unreadCount, defaultTapAction) {
  ///     return InkWell(
  ///       onTap: () => defaultTapAction(unreadCount),
  ///       child: Text('Scroll To Bottom'),
  ///     );
  ///   },
  /// ),
  /// ```
  final Widget Function(
    int unreadCount,
    Future<void> Function(int) scrollToBottomDefaultTapAction,
  )? scrollToBottomBuilder;

  /// If true will show an indicator with number of unread messages
  /// that will scroll to latest read message when tapped and mark
  /// channel as read when dismissed
  final bool showUnreadIndicator;

  /// Function used to build a custom unread indicator widget
  ///
  /// Provides the current unread messages count and a reference
  /// to the function that is executed on tap to scroll to latest
  /// read message by default
  ///
  /// As an example:
  /// ```
  /// MessageListView(
  ///   unreadIndicatorBuilder: (unreadCount, defaultTapAction, dismissAction) {
  ///     return InkWell(
  ///       onTap: () => defaultTapAction(unreadCount),
  ///       child: Text('Scroll To Unread'),
  ///     );
  ///   },
  /// ),
  /// ```
  final UnreadIndicatorBuilder? unreadIndicatorBuilder;

  /// If true will mark channel as read when the user scrolls to the bottom of the list
  final bool markReadWhenAtTheBottom;

  /// Parent message in case of a thread
  final Message? parentMessage;

  /// Builder used to render date dividers
  final Widget Function(DateTime)? dateDividerBuilder;

  /// Builder used to render floating date divider that stays on top while scrolling
  /// the message list.
  ///
  /// If null, It will fall back to [dateDividerBuilder] if provided.
  final Widget Function(DateTime)? floatingDateDividerBuilder;

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

  /// The ScrollPhysics used by the ListView
  final ScrollPhysics? scrollPhysics;

  /// If true the list will highlight the initialMessage if there is any.
  ///
  /// Also See [StreamChannel]
  final bool highlightInitialMessage;

  /// Color used while highlighting initial message
  final Color? messageHighlightColor;

  /// Flag for showing tile on header
  final bool showConnectionStateTile;

  /// Flag for showing the floating date divider
  final bool showFloatingDateDivider;

  /// Function called when messages are fetched
  final Widget Function(BuildContext, List<Message>)? messageListBuilder;

  /// Function used to build a header widget
  final WidgetBuilder? headerBuilder;

  /// Function used to build a footer widget
  final WidgetBuilder? footerBuilder;

  /// Function used to build a loading widget
  final WidgetBuilder? loadingBuilder;

  /// Function used to build an empty widget
  final WidgetBuilder? emptyBuilder;

  /// Callback triggered when an error occurs while performing the
  /// given request.
  ///
  /// This parameter can be used to display an error message to
  /// users in the event of a connection failure.
  final ErrorBuilder? errorBuilder;

  /// Predicate used to filter messages
  final bool Function(Message)? messageFilter;

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

  /// Builder used to build the thread separator in case it's a thread view
  final Function(BuildContext context, Message parentMessage)?
      threadSeparatorBuilder;

  /// Builder used to build the unread message separator
  final Widget Function(BuildContext context, int unreadCount)?
      unreadMessagesSeparatorBuilder;

  /// A [MessageListController] allows pagination.
  ///
  /// Use [ChannelListController.paginateData] pagination.
  final MessageListController? messageListController;

  /// Builder used to build the loading indicator shown while paginating.
  final WidgetBuilder? paginationLoadingIndicatorBuilder;

  /// {@macro spacingWidgetBuilder}
  final SpacingWidgetBuilder spacingWidgetBuilder;

  static Widget _defaultSpacingWidgetBuilder(
    BuildContext context,
    List<SpacingType> spacingTypes,
  ) {
    if (spacingTypes.contains(SpacingType.otherUser)) {
      return const SizedBox(height: 8);
    } else if (spacingTypes.contains(SpacingType.thread)) {
      return const SizedBox(height: 8);
    } else if (spacingTypes.contains(SpacingType.timeDiff)) {
      return const SizedBox(height: 8);
    }

    return const SizedBox(height: 2);
  }

  @override
  _StreamMessageListViewState createState() => _StreamMessageListViewState();
}

class _StreamMessageListViewState extends State<StreamMessageListView> {
  ItemScrollController? _scrollController;
  void Function(Message)? _onThreadTap;
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

  bool initialMessageHighlightComplete = false;

  bool _inBetweenList = false;

  late final _defaultController = MessageListController();

  MessageListController get _messageListController =>
      widget.messageListController ?? _defaultController;

  StreamSubscription? _messageNewListener;
  StreamSubscription? _userReadListener;

  Message? _firstUnreadMessage;

  @override
  void initState() {
    super.initState();

    _scrollController = widget.scrollController ?? ItemScrollController();
    _itemPositionListener =
        widget.itemPositionListener ?? ItemPositionsListener.create();
    _itemPositionListener.itemPositions
        .addListener(_handleItemPositionsChanged);

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

      initialIndex = getInitialIndex(
        widget.initialScrollIndex,
        streamChannel!,
        widget.messageFilter,
      );

      initialAlignment = _initialAlignment;

      if (_scrollController?.isAttached == true) {
        _scrollController?.jumpTo(
          index: initialIndex,
          alignment: initialAlignment,
        );
      }

      _messageNewListener =
          streamChannel!.channel.on(EventType.messageNew).listen((event) {
        if (_upToDate) {
          _bottomPaginationActive = false;
        }
        if (event.message?.parentId == widget.parentMessage?.id &&
            event.message!.user!.id ==
                streamChannel!.channel.client.state.currentUser!.id) {
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
    _itemPositionListener.itemPositions
        .removeListener(_handleItemPositionsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      labels: const [kPortalMessageListViewLabel],
      child: ScaffoldMessenger(
        child: MessageListCore(
          paginationLimit: widget.paginationLimit,
          messageFilter: widget.messageFilter,
          loadingBuilder: widget.loadingBuilder ??
              (context) => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
          emptyBuilder: widget.emptyBuilder ??
              (context) => Center(
                    child: Text(
                      context.translations.emptyChatMessagesText,
                      style: _streamTheme.textTheme.footnote.copyWith(
                        color: _streamTheme.colorTheme.textHighEmphasis
                            // ignore: deprecated_member_use
                            .withOpacity(0.5),
                      ),
                    ),
                  ),
          messageListBuilder: widget.messageListBuilder ??
              (context, list) => _buildListView(list),
          messageListController: _messageListController,
          parentMessage: widget.parentMessage,
          errorBuilder: widget.errorBuilder ??
              (BuildContext context, Object error) => Center(
                    child: Text(
                      context.translations.genericErrorText,
                      style: _streamTheme.textTheme.footnote.copyWith(
                        color: _streamTheme.colorTheme.textHighEmphasis
                            // ignore: deprecated_member_use
                            .withOpacity(0.5),
                      ),
                    ),
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
            if (messages[0].user?.id !=
                streamChannel!.channel.client.state.currentUser?.id) {
              initialIndex = first.index + diff;
              initialAlignment = first.itemLeadingEdge;
            }
          }
        }
      }
    }

    _messageListLength = newMessagesListLength;

    final itemCount = messages.length + // total messages
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
              showMessage: widget.showConnectionStateTile && showStatus,
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
                  keyboardDismissBehavior: widget.keyboardDismissBehavior,
                  itemPositionsListener: _itemPositionListener,
                  initialScrollIndex: initialIndex,
                  initialAlignment: initialAlignment,
                  physics: widget.scrollPhysics,
                  itemScrollController: _scrollController,
                  reverse: widget.reverse,
                  shrinkWrap: widget.shrinkWrap,
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
                      if (_firstUnreadMessage?.id != message.id) {
                        return separator;
                      }

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

                      if (widget.threadSeparatorBuilder != null) {
                        return widget.threadSeparatorBuilder!
                            .call(context, widget.parentMessage!);
                      }

                      return ThreadSeparator(
                        parentMessage: widget.parentMessage,
                      );
                    }
                    if (i == itemCount - 3) {
                      if (widget.reverse
                          ? widget.headerBuilder == null
                          : widget.footerBuilder == null) {
                        if (messages.isNotEmpty) {
                          final message = messages.last;
                          return maybeBuildWithUnreadMessagesSeparator(
                            message: message,
                            separator: _buildDateDivider(message),
                          );
                        }

                        if (_isThreadConversation) return const Empty();
                        return const SizedBox(height: 52);
                      }
                      return const SizedBox(height: 8);
                    }
                    if (i == 0) {
                      if (widget.reverse
                          ? widget.footerBuilder == null
                          : widget.headerBuilder == null) {
                        return const SizedBox(height: 30);
                      }
                      return const SizedBox(height: 8);
                    }

                    if (i == 1 || i == itemCount - 4) return const Empty();

                    late final Message message, nextMessage;
                    if (widget.reverse) {
                      message = messages[i - 1];
                      nextMessage = messages[i - 2];
                    } else {
                      message = messages[i - 2];
                      nextMessage = messages[i - 1];
                    }

                    Widget separator;

                    final isPartOfThread = message.replyCount! > 0 ||
                        message.showInChannel == true;

                    final createdAt = Jiffy.parseFromDateTime(
                      message.createdAt.toLocal(),
                    );

                    final nextCreatedAt = Jiffy.parseFromDateTime(
                      nextMessage.createdAt.toLocal(),
                    );

                    if (!createdAt.isSame(nextCreatedAt, unit: Unit.day)) {
                      separator = _buildDateDivider(nextMessage);
                    } else {
                      final hasTimeDiff = !createdAt.isSame(
                        nextCreatedAt,
                        unit: Unit.minute,
                      );

                      final isNextUserSame =
                          message.user!.id == nextMessage.user?.id;
                      final isDeleted = message.isDeleted;

                      final spacingRules = [
                        if (hasTimeDiff) SpacingType.timeDiff,
                        if (!isNextUserSame) SpacingType.otherUser,
                        if (isPartOfThread) SpacingType.thread,
                        if (isDeleted) SpacingType.deleted,
                      ];

                      if (spacingRules.isEmpty) {
                        spacingRules.add(SpacingType.defaultSpacing);
                      }

                      separator = widget.spacingWidgetBuilder.call(
                        context,
                        spacingRules,
                      );
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
                      if (widget.reverse) {
                        return widget.headerBuilder?.call(context) ??
                            const Empty();
                      } else {
                        return widget.footerBuilder?.call(context) ??
                            const Empty();
                      }
                    }

                    final indicatorBuilder =
                        widget.paginationLoadingIndicatorBuilder;

                    if (i == itemCount - 3) {
                      return LoadingIndicator(
                        direction: QueryDirection.top,
                        streamTheme: _streamTheme,
                        streamChannelState: streamChannel!,
                        isThreadConversation: _isThreadConversation,
                        indicatorBuilder: indicatorBuilder,
                      );
                    }

                    if (i == 1) {
                      return LoadingIndicator(
                        direction: QueryDirection.bottom,
                        streamTheme: _streamTheme,
                        streamChannelState: streamChannel!,
                        isThreadConversation: _isThreadConversation,
                        indicatorBuilder: indicatorBuilder,
                      );
                    }

                    if (i == 0) {
                      if (widget.reverse) {
                        return widget.footerBuilder?.call(context) ??
                            const Empty();
                      } else {
                        return widget.headerBuilder?.call(context) ??
                            const Empty();
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
        if (widget.showFloatingDateDivider)
          Positioned(
            top: 20,
            child: FloatingDateDivider(
              itemCount: itemCount,
              reverse: widget.reverse,
              itemPositionListener: _itemPositionListener.itemPositions,
              messages: messages,
              dateDividerBuilder: switch (widget.floatingDateDividerBuilder) {
                final builder? => builder,
                _ => widget.dateDividerBuilder,
              },
            ),
          ),
        if (widget.showScrollToBottom)
          BetterStreamBuilder<bool>(
            stream: streamChannel!.channel.state!.isUpToDateStream,
            initialData: streamChannel!.channel.state!.isUpToDate,
            builder: (context, snapshot) => ValueListenableBuilder<bool>(
              valueListenable: _showScrollToBottom,
              child: _buildScrollToBottom(),
              builder: (context, value, child) {
                if (!snapshot || value) {
                  return child!;
                }
                return const Empty();
              },
            ),
          ),
        if (widget.showUnreadIndicator && !_isThreadConversation)
          Positioned(
            top: 8,
            child: UnreadIndicatorButton(
              onDismissTap: _markMessagesAsRead,
              onTap: scrollToUnreadDefaultTapAction,
              unreadIndicatorBuilder: widget.unreadIndicatorBuilder,
            ),
          ),
      ],
    );

    final backgroundColor =
        StreamMessageListViewTheme.of(context).backgroundColor;
    final backgroundImage =
        StreamMessageListViewTheme.of(context).backgroundImage;

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

  Widget _buildUnreadMessagesSeparator(int unreadCount) {
    final unreadMessagesSeparator =
        widget.unreadMessagesSeparatorBuilder?.call(context, unreadCount) ??
            UnreadMessagesSeparator(unreadCount: unreadCount);
    return unreadMessagesSeparator;
  }

  Future<void> _paginateData(
    StreamChannelState? channel,
    QueryDirection direction,
  ) =>
      _messageListController.paginateData!(direction: direction);

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

  Widget _buildDateDivider(Message message) {
    final createdAt = message.createdAt.toLocal();
    return switch (widget.dateDividerBuilder) {
      final builder? => builder(createdAt),
      _ => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: StreamDateDivider(dateTime: createdAt),
        ),
    };
  }

  Widget buildParentMessage(
    Message message,
  ) {
    final isMyMessage =
        message.user!.id == StreamChat.of(context).currentUser!.id;
    final isOnlyEmoji = message.text?.isOnlyEmoji ?? false;
    final currentUser = StreamChat.of(context).currentUser;
    final members = StreamChannel.of(context).channel.state?.members ?? [];
    final currentUserMember =
        members.firstWhereOrNull((e) => e.user!.id == currentUser!.id);

    final hasFileAttachment =
        message.attachments.any((it) => it.type == AttachmentType.file);

    final hasUrlAttachment =
        message.attachments.any((it) => it.type == AttachmentType.urlPreview);

    final attachmentBorderRadius = hasUrlAttachment
        ? 8.0
        : hasFileAttachment
            ? 12.0
            : 14.0;

    final borderSide = isOnlyEmoji ? BorderSide.none : null;

    final defaultMessageWidget = StreamMessageWidget(
      showReplyMessage: false,
      showResendMessage: false,
      showThreadReplyMessage: false,
      showCopyMessage: false,
      showDeleteMessage: false,
      showEditMessage: false,
      showMarkUnreadMessage: false,
      message: message,
      reverse: isMyMessage,
      showUsername: !isMyMessage,
      padding: const EdgeInsets.all(8),
      showSendingIndicator: false,
      attachmentPadding: EdgeInsets.all(
        hasUrlAttachment
            ? 8
            : hasFileAttachment
                ? 4
                : 2,
      ),
      attachmentShape: RoundedRectangleBorder(
        side: BorderSide(
          color: _streamTheme.colorTheme.borders,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(attachmentBorderRadius),
          bottomLeft: isMyMessage
              ? Radius.circular(attachmentBorderRadius)
              : Radius.zero,
          topRight: Radius.circular(attachmentBorderRadius),
          bottomRight: isMyMessage
              ? Radius.zero
              : Radius.circular(attachmentBorderRadius),
        ),
      ),
      borderRadiusGeometry: BorderRadius.only(
        topLeft: const Radius.circular(16),
        bottomLeft: isMyMessage ? const Radius.circular(16) : Radius.zero,
        topRight: const Radius.circular(16),
        bottomRight: isMyMessage ? Radius.zero : const Radius.circular(16),
      ),
      textPadding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: isOnlyEmoji ? 0 : 16.0,
      ),
      borderSide: borderSide,
      showUserAvatar: isMyMessage ? DisplayWidget.gone : DisplayWidget.show,
      messageTheme: isMyMessage
          ? _streamTheme.ownMessageTheme
          : _streamTheme.otherMessageTheme,
      onMessageTap: widget.onMessageTap,
      onMessageLongPress: widget.onMessageLongPress,
      showPinButton: currentUserMember != null &&
          streamChannel?.channel.canPinMessage == true &&
          // Pinning a restricted visibility message is not allowed, simply
          // because pinning a message is meant to bring attention to that
          // message, that is not possible with a message that is only visible
          // to a subset of users.
          !message.hasRestrictedVisibility,
    );

    if (widget.parentMessageBuilder != null) {
      return widget.parentMessageBuilder!.call(
        context,
        widget.parentMessage,
        defaultMessageWidget,
      );
    }

    return defaultMessageWidget;
  }

  Widget _buildScrollToBottom() {
    return StreamBuilder<int>(
      stream: streamChannel!.channel.state!.unreadCountStream,
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return const Empty();
        } else if (!snapshot.hasData) {
          return const Empty();
        }
        final unreadCount = snapshot.data!;
        if (widget.scrollToBottomBuilder != null) {
          return widget.scrollToBottomBuilder!(
            unreadCount,
            scrollToBottomDefaultTapAction,
          );
        }
        final showUnreadCount = unreadCount > 0 &&
            streamChannel!.channel.state!.members.any((e) =>
                e.userId ==
                streamChannel!.channel.client.state.currentUser!.id);

        return Positioned(
          bottom: 8,
          right: 8,
          width: 40,
          height: 40,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              FloatingActionButton(
                backgroundColor: _streamTheme.colorTheme.barsBg,
                onPressed: () async {
                  return scrollToBottomDefaultTapAction(unreadCount);
                },
                child: widget.reverse
                    ? StreamSvgIcon(
                        icon: StreamSvgIcons.down,
                        color: _streamTheme.colorTheme.textHighEmphasis,
                      )
                    : StreamSvgIcon(
                        icon: StreamSvgIcons.up,
                        color: _streamTheme.colorTheme.textHighEmphasis,
                      ),
              ),
              if (showUnreadCount && widget.showUnreadCountOnScrollToBottom)
                Positioned(
                  left: 0,
                  right: 0,
                  top: -10,
                  child: Center(
                    child: Material(
                      borderRadius: BorderRadius.circular(8),
                      color:
                          StreamChatTheme.of(context).colorTheme.accentPrimary,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                          top: 2,
                          bottom: 2,
                        ),
                        child: Text(
                          '${unreadCount > 99 ? '99+' : unreadCount}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSystemMessage(Message message) {
    if (widget.systemMessageBuilder case final builder?) {
      return builder(context, message);
    }

    return StreamSystemMessage(
      message: message,
      onMessageTap: widget.onSystemMessageTap,
    );
  }

  Widget buildModeratedMessage(Message message) {
    if (widget.moderatedMessageBuilder case final builder?) {
      return builder(context, message);
    }

    return StreamModeratedMessage(
      message: message,
      onMessageTap: widget.onModeratedMessageTap,
    );
  }

  Widget buildEphemeralMessage(Message message) {
    if (widget.ephemeralMessageBuilder case final builder?) {
      return builder(context, message);
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

    final userId = StreamChat.of(context).currentUser!.id;
    final isMyMessage = message.user?.id == userId;
    final nextMessage = index - 1 >= 0 ? messages[index - 1] : null;
    final isNextUserSame =
        nextMessage != null && message.user!.id == nextMessage.user!.id;

    var hasTimeDiff = false;
    if (nextMessage != null) {
      final createdAt = Jiffy.parseFromDateTime(message.createdAt.toLocal());
      final nextCreatedAt = Jiffy.parseFromDateTime(
        nextMessage.createdAt.toLocal(),
      );

      hasTimeDiff = !createdAt.isSame(nextCreatedAt, unit: Unit.minute);
    }

    final hasVoiceRecordingAttachment = message.attachments
        .any((it) => it.type == AttachmentType.voiceRecording);

    final hasFileAttachment =
        message.attachments.any((it) => it.type == AttachmentType.file);

    final hasUrlAttachment =
        message.attachments.any((it) => it.type == AttachmentType.urlPreview);

    final isThreadMessage =
        message.parentId != null && message.showInChannel == true;

    final hasReplies = message.replyCount! > 0;

    final attachmentBorderRadius = hasUrlAttachment
        ? 8.0
        : hasFileAttachment
            ? 12.0
            : 14.0;

    final showTimeStamp = (!isThreadMessage || _isThreadConversation) &&
        !hasReplies &&
        (hasTimeDiff || !isNextUserSame);

    final showUsername = !isMyMessage &&
        (!isThreadMessage || _isThreadConversation) &&
        !hasReplies &&
        (hasTimeDiff || !isNextUserSame);

    final showMarkUnread = streamChannel?.channel.config?.readEvents == true &&
        !isMyMessage &&
        (!isThreadMessage || _isThreadConversation);

    final showUserAvatar = isMyMessage
        ? DisplayWidget.gone
        : (hasTimeDiff || !isNextUserSame)
            ? DisplayWidget.show
            : DisplayWidget.hide;

    final showSendingIndicator =
        isMyMessage && (index == 0 || hasTimeDiff || !isNextUserSame);

    final showInChannelIndicator = !_isThreadConversation && isThreadMessage;
    final showThreadReplyIndicator = !_isThreadConversation && hasReplies;
    final isOnlyEmoji = message.text?.isOnlyEmoji ?? false;

    final borderSide = isOnlyEmoji ? BorderSide.none : null;

    final currentUser = StreamChat.of(context).currentUser;
    final members = StreamChannel.of(context).channel.state?.members ?? [];
    final currentUserMember =
        members.firstWhereOrNull((e) => e.user!.id == currentUser!.id);

    Widget messageWidget = StreamMessageWidget(
      message: message,
      reverse: isMyMessage,
      showReactions: !message.isDeleted,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      showInChannelIndicator: showInChannelIndicator,
      showThreadReplyIndicator: showThreadReplyIndicator,
      showUsername: showUsername,
      showTimestamp: showTimeStamp,
      showSendingIndicator: showSendingIndicator,
      showUserAvatar: showUserAvatar,
      showMarkUnreadMessage: showMarkUnread,
      onQuotedMessageTap: (quotedMessageId) async {
        if (messages.map((e) => e.id).contains(quotedMessageId)) {
          final index = messages.indexWhere((m) => m.id == quotedMessageId);
          _scrollController?.scrollTo(
            index: index + 2, // +2 to account for loader and footer
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            alignment: 0.1,
          );
        } else {
          await streamChannel!
              .loadChannelAtMessage(quotedMessageId)
              .then((_) async {
            initialIndex = 21; // 19 + 2 | 19 is the index of the message
            initialAlignment = 0.1;
          });
        }
      },
      showEditMessage: isMyMessage,
      showDeleteMessage: isMyMessage,
      showThreadReplyMessage:
          !isThreadMessage && streamChannel?.channel.canSendReply == true,
      showFlagButton: !isMyMessage,
      borderSide: borderSide,
      onThreadTap: _onThreadTap,
      attachmentShape: RoundedRectangleBorder(
        side: BorderSide(
          color: _streamTheme.colorTheme.borders,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(attachmentBorderRadius),
          bottomLeft: isMyMessage
              ? Radius.circular(attachmentBorderRadius)
              : Radius.circular(
                  (hasTimeDiff || !isNextUserSame) &&
                          !(hasReplies ||
                              isThreadMessage ||
                              hasFileAttachment ||
                              hasVoiceRecordingAttachment)
                      ? 0
                      : attachmentBorderRadius,
                ),
          topRight: Radius.circular(attachmentBorderRadius),
          bottomRight: isMyMessage
              ? Radius.circular(
                  (hasTimeDiff || !isNextUserSame) &&
                          !(hasReplies ||
                              isThreadMessage ||
                              hasFileAttachment ||
                              hasVoiceRecordingAttachment)
                      ? 0
                      : attachmentBorderRadius,
                )
              : Radius.circular(attachmentBorderRadius),
        ),
      ),
      attachmentPadding: EdgeInsets.all(
        hasUrlAttachment
            ? 8
            : hasFileAttachment || hasVoiceRecordingAttachment
                ? 4
                : 2,
      ),
      borderRadiusGeometry: BorderRadius.only(
        topLeft: const Radius.circular(16),
        bottomLeft: isMyMessage
            ? const Radius.circular(16)
            : Radius.circular(
                (hasTimeDiff || !isNextUserSame) &&
                        !(hasReplies || isThreadMessage)
                    ? 0
                    : 16,
              ),
        topRight: const Radius.circular(16),
        bottomRight: isMyMessage
            ? Radius.circular(
                (hasTimeDiff || !isNextUserSame) &&
                        !(hasReplies || isThreadMessage)
                    ? 0
                    : 16,
              )
            : const Radius.circular(16),
      ),
      textPadding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: isOnlyEmoji ? 0 : 16.0,
      ),
      messageTheme: isMyMessage
          ? _streamTheme.ownMessageTheme
          : _streamTheme.otherMessageTheme,
      onMessageTap: widget.onMessageTap,
      onMessageLongPress: widget.onMessageLongPress,
      showPinButton: currentUserMember != null &&
          streamChannel?.channel.canPinMessage == true &&
          // Pinning a restricted visibility message is not allowed, simply
          // because pinning a message is meant to bring attention to that
          // message, that is not possible with a message that is only visible
          // to a subset of users.
          !message.hasRestrictedVisibility,
    );

    if (widget.messageBuilder != null) {
      messageWidget = widget.messageBuilder!(
        context,
        MessageDetails(
          userId,
          message,
          messages,
          index,
        ),
        messages,
        messageWidget as StreamMessageWidget,
      );
    }

    var child = messageWidget;
    if (!initialMessageHighlightComplete &&
        widget.highlightInitialMessage &&
        isInitialMessage(message.id, streamChannel)) {
      final colorTheme = _streamTheme.colorTheme;
      final highlightColor =
          widget.messageHighlightColor ?? colorTheme.highlight;
      child = TweenAnimationBuilder<Color?>(
        tween: ColorTween(
          begin: highlightColor,
          // ignore: deprecated_member_use
          end: colorTheme.barsBg.withOpacity(0),
        ),
        duration: const Duration(seconds: 3),
        onEnd: () => initialMessageHighlightComplete = true,
        builder: (_, color, child) => ColoredBox(
          color: color!,
          child: child,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: child,
        ),
      );
    }

    return child;
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
      if (widget.markReadWhenAtTheBottom) {
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
    if (widget.onThreadTap != null) {
      _onThreadTap = (Message message) {
        final threadBuilder = widget.threadBuilder;
        widget.onThreadTap!(
          message,
          threadBuilder != null ? threadBuilder(context, message) : null,
        );
      };
    } else if (widget.threadBuilder != null) {
      _onThreadTap = (Message message) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BetterStreamBuilder<Message>(
              stream: streamChannel!.channel.state!.messagesStream.map(
                (messages) => messages.firstWhere((m) => m.id == message.id),
              ),
              initialData: message,
              builder: (_, data) => StreamChannel(
                channel: streamChannel!.channel,
                child: widget.threadBuilder!(context, data),
              ),
            ),
          ),
        );
      };
    }
  }
}
