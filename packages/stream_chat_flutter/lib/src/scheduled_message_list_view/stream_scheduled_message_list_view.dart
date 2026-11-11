import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../stream_chat_flutter.dart';
import '../utils/network_error_text.dart';
import 'stream_scheduled_message_list_skeleton_loading.dart';

/// Default separator builder for [StreamScheduledMessageListView].
Widget defaultScheduledMessageListViewSeparatorBuilder(
  BuildContext context,
  List<ScheduledMessage> scheduledMessages,
  int index,
) => const _ScheduledMessageListSeparator();

/// Signature for the item builder that creates the children of the
/// [StreamScheduledMessageListView].
typedef StreamScheduledMessageListViewIndexedWidgetBuilder =
    StreamScrollViewIndexedWidgetBuilder<ScheduledMessage, StreamScheduledMessageListItem>;

/// {@template streamScheduledMessageListView}
/// A [ListView] that shows the current user's scheduled messages.
///
/// The list follows the scheduled messages as they change. When they aren't
/// all loaded yet, showing the list loads them.
///
/// Each row is rendered using [StreamScheduledMessageListItem], which can be
/// customized app-wide through [StreamComponentFactory].
///
/// Example:
///
/// ```dart
/// StreamScheduledMessageListView(
///   channel: channel,
///   onScheduledMessageTap: (scheduledMessage) {
///     showStreamScheduledMessageActionsSheet(
///       context: context,
///       scheduledMessage: scheduledMessage,
///     );
///   },
/// )
/// ```
///
/// See also:
///
///  * [StreamScheduledMessageListItem], which renders each scheduled message.
///  * [showStreamScheduledMessageActionsSheet], which shows the actions on one.
/// {@endtemplate}
class StreamScheduledMessageListView extends StatefulWidget {
  /// {@macro streamScheduledMessageListView}
  const StreamScheduledMessageListView({
    super.key,
    this.channel,
    this.parentId,
    this.itemBuilder,
    this.separatorBuilder = defaultScheduledMessageListViewSeparatorBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.onScheduledMessageTap,
    this.onScheduledMessageLongPress,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.scrollCacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  }) : assert(parentId == null || channel != null, 'parentId needs the channel of its thread.');

  /// The channel whose scheduled messages are listed.
  ///
  /// When null, every channel's are. Replies in its threads are listed with
  /// [parentId].
  final Channel? channel;

  /// The ID of the message whose thread's scheduled replies are listed.
  ///
  /// Needs [channel].
  final String? parentId;

  /// A builder that is called to build items in the [ListView].
  final StreamScheduledMessageListViewIndexedWidgetBuilder? itemBuilder;

  /// A builder that is called to build the list separator.
  final PagedValueScrollViewIndexedWidgetBuilder<ScheduledMessage> separatorBuilder;

  /// A builder that is called to build the empty state of the list.
  final WidgetBuilder? emptyBuilder;

  /// A builder that is called to build the loading state of the list.
  final WidgetBuilder? loadingBuilder;

  /// A builder that is called to build the error state of the list.
  final Widget Function(BuildContext, StreamChatError)? errorBuilder;

  /// Called when the user taps a scheduled message.
  final void Function(ScheduledMessage)? onScheduledMessageTap;

  /// Called when the user long-presses on a scheduled message.
  final void Function(ScheduledMessage)? onScheduledMessageLongPress;

  /// {@macro flutter.widgets.scroll_view.scrollDirection}
  final Axis scrollDirection;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry? padding;

  /// Whether to wrap each child in an [AutomaticKeepAlive].
  ///
  /// Typically, children in lazy list are wrapped in [AutomaticKeepAlive]
  /// widgets so that children can use [KeepAliveNotification]s to preserve
  /// their state when they would otherwise be garbage collected off-screen.
  ///
  /// This feature (and [addRepaintBoundaries]) must be disabled if the children
  /// are going to manually maintain their [KeepAlive] state. It may also be
  /// more efficient to disable this feature if it is known ahead of time that
  /// none of the children will ever try to keep themselves alive.
  ///
  /// Defaults to true.
  final bool addAutomaticKeepAlives;

  /// Whether to wrap each child in a [RepaintBoundary].
  ///
  /// Typically, children in a scrolling container are wrapped in repaint
  /// boundaries so that they do not need to be repainted as the list scrolls.
  /// If the children are easy to repaint (e.g., solid color blocks or a short
  /// snippet of text), it might be more efficient to not add a repaint boundary
  /// and simply repaint the children during scrolling.
  ///
  /// Defaults to true.
  final bool addRepaintBoundaries;

  /// Whether to wrap each child in an [IndexedSemantics].
  ///
  /// Typically, children in a scrolling container must be annotated with a
  /// semantic index in order to generate the correct accessibility
  /// announcements. This should only be set to false if the indexes have
  /// already been provided by an [IndexedSemantics] widget.
  ///
  /// Defaults to true.
  ///
  /// See also:
  ///
  ///  * [IndexedSemantics], for an explanation of how to manually
  ///    provide semantic indexes.
  final bool addSemanticIndexes;

  /// {@macro flutter.widgets.scroll_view.reverse}
  final bool reverse;

  /// {@macro flutter.widgets.scroll_view.controller}
  final ScrollController? scrollController;

  /// {@macro flutter.widgets.scroll_view.primary}
  final bool? primary;

  /// {@macro flutter.widgets.scroll_view.shrinkWrap}
  final bool shrinkWrap;

  /// {@macro flutter.widgets.scroll_view.physics}
  final ScrollPhysics? physics;

  /// {@macro flutter.rendering.RenderViewportBase.scrollCacheExtent}
  final ScrollCacheExtent? scrollCacheExtent;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.scroll_view.keyboardDismissBehavior}
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String? restorationId;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  @override
  State<StreamScheduledMessageListView> createState() => _StreamScheduledMessageListViewState();
}

class _StreamScheduledMessageListViewState extends State<StreamScheduledMessageListView> {
  Future<void>? _loading;
  Stream<List<ScheduledMessage>>? _stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stream ??= _scheduledMessagesStream();
    _loading ??= _loadIfNeeded();
  }

  @override
  void didUpdateWidget(covariant StreamScheduledMessageListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.channel == oldWidget.channel && widget.parentId == oldWidget.parentId) return;

    _stream = _scheduledMessagesStream();
  }

  Future<void>? _loadIfNeeded() {
    final client = StreamChat.of(context).client;
    if (client.state.scheduledMessageListState.hasLoadedAll) return null;

    // A failure only shows when there's nothing to list, so it's ignored.
    return client.loadScheduledMessages()..ignore();
  }

  void _retry() {
    setState(() {
      _loading = _loadIfNeeded();
    });
  }

  // The scheduled messages in the scope of this list, as they change.
  Stream<List<ScheduledMessage>> _scheduledMessagesStream() {
    final channel = widget.channel;
    if (channel == null) return StreamChat.of(context).client.state.scheduledMessagesStream;

    final channelState = channel.state!;
    final parentId = widget.parentId;
    if (parentId == null) return channelState.scheduledMessagesStream;
    return channelState.scheduledThreadRepliesStream(parentId);
  }

  // The scheduled messages in the scope of this list.
  List<ScheduledMessage> _currentScheduledMessages() {
    final channel = widget.channel;
    if (channel == null) return StreamChat.of(context).client.state.scheduledMessages;

    final channelState = channel.state!;
    final parentId = widget.parentId;
    if (parentId == null) return channelState.scheduledMessages;
    return channelState.scheduledThreadReplies(parentId);
  }

  @override
  Widget build(BuildContext context) {
    return BetterStreamBuilder<List<ScheduledMessage>>(
      stream: _stream,
      initialData: _currentScheduledMessages(),
      builder: (context, scheduledMessages) {
        if (scheduledMessages.isEmpty) {
          return FutureBuilder<void>(
            future: _loading,
            builder: (context, snapshot) => switch (snapshot) {
              AsyncSnapshot(connectionState: .waiting) => _buildLoading(context),
              AsyncSnapshot(:final error?) => _buildError(context, error),
              _ => _buildEmpty(context),
            },
          );
        }

        return ListView.separated(
          scrollDirection: widget.scrollDirection,
          padding: widget.padding,
          physics: widget.physics,
          reverse: widget.reverse,
          controller: widget.scrollController,
          primary: widget.primary,
          shrinkWrap: widget.shrinkWrap,
          addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
          addRepaintBoundaries: widget.addRepaintBoundaries,
          addSemanticIndexes: widget.addSemanticIndexes,
          keyboardDismissBehavior: widget.keyboardDismissBehavior,
          restorationId: widget.restorationId,
          dragStartBehavior: widget.dragStartBehavior,
          scrollCacheExtent: widget.scrollCacheExtent,
          clipBehavior: widget.clipBehavior,
          itemCount: scheduledMessages.length,
          separatorBuilder: (context, index) => widget.separatorBuilder(context, scheduledMessages, index),
          itemBuilder: (context, index) => _buildItem(context, scheduledMessages, index),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, List<ScheduledMessage> scheduledMessages, int index) {
    final scheduledMessage = scheduledMessages[index];
    final onTap = widget.onScheduledMessageTap;
    final onLongPress = widget.onScheduledMessageLongPress;
    final item = StreamScheduledMessageListItem(
      scheduledMessage: scheduledMessage,
      onTap: onTap == null ? null : () => onTap(scheduledMessage),
      onLongPress: onLongPress == null ? null : () => onLongPress(scheduledMessage),
    );

    return widget.itemBuilder?.call(context, scheduledMessages, index, item) ?? item;
  }

  Widget _buildLoading(BuildContext context) {
    if (widget.loadingBuilder?.call(context) case final custom?) return custom;

    return Center(
      child: StreamScheduledMessageListSkeletonLoading(padding: widget.padding),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    final chatError = switch (error) {
      final StreamChatError error => error,
      _ => StreamChatError(error.toString()),
    };

    if (widget.errorBuilder?.call(context, chatError) case final custom?) return custom;

    final translations = context.translations;
    final text = resolveNetworkErrorText(context, chatError, fallbackTitle: translations.loadingScheduledMessagesError);

    return Center(
      child: StreamScrollViewErrorWidget(
        errorTitle: Text(text.title),
        onRetryPressed: _retry,
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    if (widget.emptyBuilder?.call(context) case final custom?) return custom;

    return Center(
      child: StreamScrollViewEmptyWidget(
        emptyIcon: Icon(context.streamIcons.clock),
        emptyTitle: Text(context.translations.noScheduledMessagesText),
      ),
    );
  }
}

// The divider between [StreamScheduledMessageListItem]s.
class _ScheduledMessageListSeparator extends StatelessWidget {
  const _ScheduledMessageListSeparator();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    return Divider(height: 1, color: colorScheme.borderSubtle);
  }
}
