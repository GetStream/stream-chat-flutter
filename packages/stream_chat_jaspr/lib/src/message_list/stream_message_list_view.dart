import 'package:intl/intl.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_jaspr/src/message_list/stream_message_list_controller.dart';
import 'package:stream_chat_jaspr/src/message_list/stream_message_list_item.dart';
import 'package:stream_chat_jaspr/src/stream_chat_provider.dart';
import 'package:stream_chat_jaspr/src/theme/stream_chat_jaspr_tokens.dart';
import 'package:universal_web/web.dart' as web;

const _containerStyles = Styles(
  display: Display.flex,
  height: Unit.percent(100),
  overflow: Overflow.auto,
  raw: {'flex-direction': 'column-reverse'},
);

const _centerStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.column,
  justifyContent: JustifyContent.center,
  alignItems: AlignItems.center,
  padding: Padding.all(Unit.pixels(48)),
  fontSize: Unit.pixels(StreamTypography.sizeBase),
  color: StreamColors.textTertiary,
);

const _dateSeparatorStyles = Styles(
  display: Display.flex,
  justifyContent: JustifyContent.center,
  raw: {'padding': '${StreamSpacing.md}px 0 ${StreamSpacing.xs}px'},
);

const _dateLabelStyles = Styles(
  fontSize: Unit.pixels(StreamTypography.sizeXxs),
  fontWeight: FontWeight.w500,
  color: StreamColors.textTertiary,
  raw: {
    'background': '#F3F4F6',
    'border-radius': '${StreamRadii.pill}px',
    'padding': '3px 10px',
  },
);

const _loadMoreStyles = Styles(
  display: Display.flex,
  justifyContent: JustifyContent.center,
  padding: Padding.symmetric(vertical: Unit.pixels(StreamSpacing.sm)),
  fontSize: Unit.pixels(StreamTypography.sizeBase),
  color: StreamColors.textTertiary,
);

const _paddingBottomStyles = Styles(
  raw: {'height': '${StreamSpacing.xs}px'},
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

  /// The ID of the most recent (newest) message seen. Used to detect when a
  /// new message arrives at the tail vs. older messages being prepended via
  /// pagination. Only the former should trigger an auto-scroll to the bottom.
  String? _latestMessageId;

  @override
  void initState() {
    super.initState();
    component.controller.onChanged = _onControllerChanged;
    component.controller.doInitialLoad();
    component.channel.markRead().ignore();
  }

  void _onControllerChanged() {
    final messages = component.controller.messages;
    final newLatestId = messages.isNotEmpty ? messages.last.id : null;
    final tailChanged = newLatestId != null && newLatestId != _latestMessageId;

    if (tailChanged) _latestMessageId = newLatestId;

    setState(() {});

    // Scroll to bottom only when a new message arrives at the tail. Loading
    // older messages via pagination changes the head, not the tail, so
    // _latestMessageId stays the same and we don't scroll.
    if (tailChanged) {
      Future.microtask(_scrollToBottom);
    } else {
      // After a pagination load, re-check if still near the top and continue
      // fetching if so (handles the case where the viewport doesn't move after
      // new items are inserted above).
      Future.microtask(_checkLoadMoreIfAtTop);
    }
  }

  void _checkLoadMoreIfAtTop() {
    final el = _scrollContainer;
    if (el == null) return;
    _checkLoadMore(el);
  }

  void _scrollToBottom() {
    var el = _scrollContainer;
    if (el == null) {
      final found = web.document.querySelector('[data-stream-message-list="true"]');
      if (found is web.HTMLElement) {
        _scrollContainer = found;
        el = found;
      }
    }
    if (el == null) return;
    // column-reverse: scroll to 0 reaches the visual bottom (newest messages).
    // Browsers represent column-reverse overflow with either scrollTop=0 (visual
    // bottom, legacy Chrome) or scrollTop=0 (visual bottom, modern Chrome after
    // spec alignment). Setting 0 is correct in both cases.
    el.scrollTop = 0;
  }

  void _onScroll(web.Event event) {
    final target = event.target;
    if (target is web.HTMLElement) {
      _scrollContainer = target;
    }

    if (target is! web.HTMLElement) return;
    _checkLoadMore(target);
  }

  void _checkLoadMore(web.HTMLElement target) {
    final maxScroll = target.scrollHeight - target.clientHeight;
    if (maxScroll <= 0) return;

    // column-reverse containers use scrollTop=0 at the visual bottom (newest).
    // Scrolling toward older messages increases scrollTop toward maxScroll.
    // Some browsers/versions may also use negative scrollTop (same semantic,
    // 0=visual bottom, -maxScroll=visual top). Using abs() handles both.
    final distanceFromTop = maxScroll - target.scrollTop.abs();
    if (distanceFromTop < 300) {
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

    if (controller.state == MessageListState.loading && controller.messages.isEmpty) {
      return const div(styles: _containerStyles, [
        div(styles: _centerStyles, [Component.text('Loading messages...')]),
      ]);
    }

    if (controller.state == MessageListState.error && controller.messages.isEmpty) {
      return const div(styles: _containerStyles, [
        div(styles: _centerStyles, [
          Component.text('Failed to load messages'),
        ]),
      ]);
    }

    if (controller.state == MessageListState.loaded && controller.messages.isEmpty) {
      return const div(styles: _containerStyles, [
        div(styles: _centerStyles, [
          Component.text('No messages yet. Say hello!'),
        ]),
      ]);
    }

    final currentUserId = StreamChatProvider.clientOf(context).state.currentUser!.id;
    final messages = controller.messages;
    final items = <Component>[];

    if (controller.isLoadingMore) {
      items.add(
        const div(styles: _loadMoreStyles, [
          Component.text('Loading older messages...'),
        ]),
      );
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
      final showUserName = message.user?.id != currentUserId && (prev == null || prev.user?.id != message.user?.id);

      // Show avatar on the last message of each consecutive group.
      final showAvatar = message.user?.id != currentUserId && (next == null || next.user?.id != message.user?.id);

      // Show timestamp on the last message of each consecutive group or
      // when there is a significant time gap.
      final showTimestamp =
          next == null ||
          next.user?.id != message.user?.id ||
          next.createdAt.difference(message.createdAt) > const Duration(minutes: 5);

      items.add(
        StreamMessageListItem(
          key: ValueKey(message.id),
          message: message,
          currentUserId: currentUserId,
          showUserName: showUserName,
          showAvatar: showAvatar,
          showTimestamp: showTimestamp,
        ),
      );
    }

    // Spacer so the last message doesn't touch the composer border.
    items.add(const div(styles: _paddingBottomStyles, []));

    // column-reverse flips DOM order visually, so reverse items to keep
    // oldest at top and newest at bottom.
    final displayItems = items.reversed.toList();

    return div(
      styles: _containerStyles,
      attributes: const {'data-stream-message-list': 'true'},
      events: {'scroll': _onScroll},
      displayItems,
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
