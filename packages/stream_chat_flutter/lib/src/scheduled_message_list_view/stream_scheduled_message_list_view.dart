import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../stream_chat_flutter.dart';
import '../utils/network_error_text.dart';
import 'stream_scheduled_message_list_skeleton_loading.dart';

/// Default separator builder for [StreamScheduledMessageListView].
Widget defaultScheduledMessageListViewSeparatorBuilder(
  BuildContext context,
  List<ScheduledMessage> scheduledMessages,
  int index,
) => const StreamScheduledMessageListSeparator();

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
///   cid: channel.cid,
///   onScheduledMessageTap: (scheduledMessage) {
///     showStreamScheduledMessageActions(
///       context,
///       scheduledMessage: scheduledMessage,
///     );
///   },
/// )
/// ```
///
/// See also:
///
///  * [StreamScheduledMessageListItem], which renders each scheduled message.
///  * [showStreamScheduledMessageActions], which shows the actions on one.
/// {@endtemplate}
class StreamScheduledMessageListView extends StatefulWidget {
  /// {@macro streamScheduledMessageListView}
  const StreamScheduledMessageListView({
    super.key,
    this.cid,
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
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  });

  /// The channel whose scheduled messages are listed.
  ///
  /// When null, every channel's are.
  final String? cid;

  /// The ID of the message whose thread's scheduled replies are listed.
  ///
  /// When set, only the replies in that thread are listed. When null and
  /// [cid] is set, the replies in the channel's threads are left out.
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

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtent}
  final double? cacheExtent;

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
  var _didStartLoading = false;
  var _isLoading = false;
  StreamChatError? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didStartLoading) return;
    _didStartLoading = true;

    final client = StreamChat.of(context).client;
    if (client.state.scheduledMessageListState.hasLoadedAll) return;
    _loadScheduledMessages();
  }

  void _loadScheduledMessages() {
    _isLoading = true;
    _error = null;

    final client = StreamChat.of(context).client;
    _load(client).ignore();
  }

  Future<void> _load(StreamChatClient client) async {
    try {
      await client.loadScheduledMessages();
      if (!mounted) return;
      setState(() => _isLoading = false);
    } on StreamChatError catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = error;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = StreamChatError(error.toString());
      });
    }
  }

  // Whether [scheduledMessage] belongs to the scope of this list.
  bool _isListed(ScheduledMessage scheduledMessage) {
    final cid = widget.cid;
    final parentId = widget.parentId;

    if (cid != null && scheduledMessage.cid != cid) return false;
    if (parentId != null) return scheduledMessage.message.parentId == parentId;
    if (cid != null) return scheduledMessage.message.parentId == null;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;

    return BetterStreamBuilder<ScheduledMessageListState>(
      stream: client.state.scheduledMessageListStateStream,
      initialData: client.state.scheduledMessageListState,
      builder: (context, state) {
        final listed = state.scheduledMessages.where(_isListed);
        final scheduledMessages = listed.toList();
        if (scheduledMessages.isEmpty) return _buildPlaceholder(context);

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
          // ignore: deprecated_member_use
          cacheExtent: widget.cacheExtent,
          clipBehavior: widget.clipBehavior,
          itemCount: scheduledMessages.length,
          separatorBuilder: (context, index) {
            return widget.separatorBuilder(context, scheduledMessages, index);
          },
          itemBuilder: (context, index) {
            final scheduledMessage = scheduledMessages[index];
            final onTap = widget.onScheduledMessageTap;
            final onLongPress = widget.onScheduledMessageLongPress;
            final item = StreamScheduledMessageListItem(
              scheduledMessage: scheduledMessage,
              onTap: switch (onTap) {
                final onTap? => () => onTap(scheduledMessage),
                null => null,
              },
              onLongPress: switch (onLongPress) {
                final onLongPress? => () => onLongPress(scheduledMessage),
                null => null,
              },
            );

            final itemBuilder = widget.itemBuilder;
            if (itemBuilder == null) return item;
            return itemBuilder(context, scheduledMessages, index, item);
          },
        );
      },
    );
  }

  // The loading, error or empty state shown while there is no row to list.
  Widget _buildPlaceholder(BuildContext context) {
    if (_isLoading) {
      final loading = widget.loadingBuilder?.call(context);
      if (loading != null) return loading;

      return Center(
        child: StreamScheduledMessageListSkeletonLoading(
          padding: widget.padding,
        ),
      );
    }

    if (_error case final error?) {
      final custom = widget.errorBuilder?.call(context, error);
      if (custom != null) return custom;

      final translations = context.translations;
      final text = resolveNetworkErrorText(
        context,
        error,
        fallbackTitle: translations.loadingScheduledMessagesError,
      );

      return Center(
        child: StreamScrollViewErrorWidget(
          errorTitle: Text(text.title),
          onRetryPressed: () => setState(_loadScheduledMessages),
        ),
      );
    }

    if (widget.emptyBuilder?.call(context) case final empty?) return empty;
    return Center(
      child: StreamScrollViewEmptyWidget(
        emptyIcon: Icon(context.streamIcons.clock),
        emptyTitle: Text(context.translations.noScheduledMessagesText),
      ),
    );
  }
}

/// The divider between [StreamScheduledMessageListItem]s.
class StreamScheduledMessageListSeparator extends StatelessWidget {
  /// Creates a scheduled message list separator.
  const StreamScheduledMessageListSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    return Divider(height: 1, color: colorScheme.borderSubtle);
  }
}
