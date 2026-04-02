import 'package:intl/intl.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_jaspr/src/message_list/stream_message_bubble.dart';
import 'package:stream_chat_jaspr/src/message_list/stream_message_list_controller.dart';
import 'package:stream_chat_jaspr/src/stream_chat_provider.dart';
import 'package:universal_web/web.dart' as web;

const _containerStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.column,
  height: Unit.percent(100),
  overflow: Overflow.auto,
);

const _centerStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.column,
  justifyContent: JustifyContent.center,
  alignItems: AlignItems.center,
  padding: Padding.all(Unit.pixels(48)),
  fontSize: Unit.pixels(14),
  color: Color('#72767e'),
);

const _dateSeparatorStyles = Styles(
  display: Display.flex,
  justifyContent: JustifyContent.center,
  raw: {'padding': '16px 0 8px'},
);

const _dateLabelStyles = Styles(
  fontSize: Unit.pixels(12),
  color: Color('#72767e'),
  fontWeight: FontWeight.w500,
  raw: {
    'background': '#f3f4f6',
    'border-radius': '12px',
    'padding': '3px 10px',
  },
);

const _loadMoreStyles = Styles(
  display: Display.flex,
  justifyContent: JustifyContent.center,
  padding: Padding.symmetric(vertical: Unit.pixels(12)),
  fontSize: Unit.pixels(13),
  color: Color('#72767e'),
);

const _paddingBottomStyles = Styles(
  raw: {'height': '8px'},
);

/// A scrollable list of messages for a single channel.
///
/// Requires a [StreamMessageListController] to manage data and state. Must be
/// placed inside a [StreamChatProvider].
///
/// Messages are rendered chronologically (oldest at the top, newest at the
/// bottom). Date separators are inserted between messages sent on different
/// days.
class StreamMessageListView extends StatefulComponent {
  /// Creates a [StreamMessageListView].
  const StreamMessageListView({
    required this.controller,
    required this.channel,
    super.key,
  });

  /// The controller that manages data and state.
  final StreamMessageListController controller;

  /// The channel being displayed (used for [Channel.markRead]).
  final Channel channel;

  @override
  State<StreamMessageListView> createState() => _StreamMessageListViewState();
}

class _StreamMessageListViewState extends State<StreamMessageListView> {
  /// Cached reference to the scroll container, set on first scroll event.
  web.HTMLElement? _scrollContainer;

  int _previousMessageCount = 0;

  @override
  void initState() {
    super.initState();
    component.controller.onChanged = _onControllerChanged;
    component.channel.markRead().ignore();
  }

  void _onControllerChanged() {
    setState(() {});

    final messages = component.controller.messages;
    if (messages.length > _previousMessageCount) {
      _previousMessageCount = messages.length;
      // Scroll to bottom after the DOM updates.
      Future.microtask(_scrollToBottom);
    }
  }

  void _scrollToBottom() {
    var el = _scrollContainer;
    if (el == null) {
      // Fall back to querying the DOM if we don't have a cached reference yet.
      final found =
          web.document.querySelector('[data-stream-message-list="true"]');
      if (found is web.HTMLElement) {
        _scrollContainer = found;
        el = found;
      }
    }
    if (el == null) return;
    el.scrollTop = el.scrollHeight.toDouble();
  }

  void _onScroll(web.Event event) {
    final target = event.target;
    if (target is web.HTMLElement) {
      _scrollContainer = target;
    }

    if (target is! web.HTMLElement) return;
    // Trigger load-more when scrolled near the top.
    if (target.scrollTop < 100) {
      component.controller.loadMore();
    }
  }

  @override
  void dispose() {
    component.controller.onChanged = null;
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final controller = component.controller;

    if (controller.state == MessageListState.loading &&
        controller.messages.isEmpty) {
      return div(styles: _containerStyles, [
        div(styles: _centerStyles, [Component.text('Loading messages...')]),
      ]);
    }

    if (controller.state == MessageListState.error &&
        controller.messages.isEmpty) {
      return div(styles: _containerStyles, [
        div(styles: _centerStyles, [
          Component.text('Failed to load messages'),
        ]),
      ]);
    }

    if (controller.state == MessageListState.loaded &&
        controller.messages.isEmpty) {
      return div(styles: _containerStyles, [
        div(styles: _centerStyles, [
          Component.text('No messages yet. Say hello!'),
        ]),
      ]);
    }

    final currentUserId =
        StreamChatProvider.clientOf(context).state.currentUser!.id;
    final messages = controller.messages;
    final items = <Component>[];

    if (controller.isLoadingMore) {
      items.add(div(styles: _loadMoreStyles, [
        Component.text('Loading older messages...'),
      ]));
    }

    for (var i = 0; i < messages.length; i++) {
      final message = messages[i];
      final prev = i > 0 ? messages[i - 1] : null;
      final next = i < messages.length - 1 ? messages[i + 1] : null;

      // Insert a date separator when the day changes.
      if (prev == null || !_sameDay(prev.createdAt, message.createdAt)) {
        items.add(_buildDateSeparator(message.createdAt));
      }

      // Show sender name when the sender changes (received messages only).
      final showSenderName =
          message.user?.id != currentUserId &&
          (prev == null || prev.user?.id != message.user?.id);

      // Show avatar on the last message of each consecutive group.
      final showAvatar =
          message.user?.id != currentUserId &&
          (next == null || next.user?.id != message.user?.id);

      items.add(StreamMessageBubble(
        key: ValueKey(message.id),
        message: message,
        currentUserId: currentUserId,
        showSenderName: showSenderName,
        showAvatar: showAvatar,
      ));
    }

    // Spacer so the last message doesn't touch the input border.
    items.add(div(styles: _paddingBottomStyles, []));

    return div(
      styles: _containerStyles,
      attributes: {'data-stream-message-list': 'true'},
      events: {'scroll': _onScroll},
      items,
    );
  }

  Component _buildDateSeparator(DateTime date) {
    final label = _formatDate(date);
    return div(styles: _dateSeparatorStyles, [
      div(styles: _dateLabelStyles, [Component.text(label)]),
    ]);
  }
}

bool _sameDay(DateTime a, DateTime b) {
  final la = a.toLocal();
  final lb = b.toLocal();
  return la.year == lb.year && la.month == lb.month && la.day == lb.day;
}

String _formatDate(DateTime date) {
  final local = date.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(local.year, local.month, local.day);
  final diff = today.difference(day).inDays;

  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  if (diff < 7) return DateFormat.EEEE().format(local);
  if (local.year == now.year) return DateFormat.MMMd().format(local);
  return DateFormat.yMMMd().format(local);
}
