import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../stream_chat_flutter.dart';
import '../../utils/network_error_text.dart';
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
/// * [StreamScheduledMessageListItem], which renders each scheduled message.
/// * [showStreamScheduledMessageActions], which shows the actions on one.
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
  /// When set, only the replies in that thread are listed, whatever the
  /// [cid]. When null and [cid] is set, the replies in the channel's threads
  /// are left out.
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

  /// {@template flutter.widgets.scroll_view.scrollDirection}
  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  /// {@endtemplate}
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

  /// {@template flutter.widgets.scroll_view.reverse}
  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// For example, if [scrollDirection] is [Axis.vertical], then the scroll view
  /// scrolls from top to bottom when [reverse] is false and from bottom to top
  /// when [reverse] is true.
  ///
  /// Defaults to false.
  /// {@endtemplate}
  final bool reverse;

  /// {@template flutter.widgets.scroll_view.controller}
  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// Must be null if [primary] is true.
  ///
  /// A [ScrollController] serves several purposes. It can be used to control
  /// the initial scroll position (see [ScrollController.initialScrollOffset]).
  /// It can be used to control whether the scroll view should automatically
  /// save and restore its scroll position in the [PageStorage] (see
  /// [ScrollController.keepScrollOffset]). It can be used to read the current
  /// scroll position (see [ScrollController.offset]), or change it (see
  /// [ScrollController.animateTo]).
  /// {@endtemplate}
  final ScrollController? scrollController;

  /// {@template flutter.widgets.scroll_view.primary}
  /// Whether this is the primary scroll view associated with the parent
  /// [PrimaryScrollController].
  ///
  /// When this is true, the scroll view is scrollable even if it does not have
  /// sufficient content to actually scroll. Otherwise, by default the user can
  /// only scroll the view if it has sufficient content. See [physics].
  ///
  /// Also when true, the scroll view is used for default [ScrollAction]s. If a
  /// ScrollAction is not handled by an otherwise focused part of the
  /// application, the ScrollAction will be evaluated using this scroll view,
  /// for example, when executing [Shortcuts] key events like page up and down.
  ///
  /// On iOS, this also identifies the scroll view that will scroll to top in
  /// response to a tap in the status bar.
  /// {@endtemplate}
  ///
  /// Defaults to true when [scrollController] is null.
  final bool? primary;

  /// {@template flutter.widgets.scroll_view.shrinkWrap}
  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  /// If the scroll view does not shrink wrap, then the scroll view will expand
  /// to the maximum allowed size in the [scrollDirection]. If the scroll view
  /// has unbounded constraints in the [scrollDirection], then [shrinkWrap] must
  /// be true.
  ///
  /// Shrink wrapping the content of the scroll view is significantly more
  /// expensive than expanding to the maximum allowed size because the content
  /// can expand and contract during scrolling, which means the size of the
  /// scroll view needs to be recomputed whenever the scroll position changes.
  ///
  /// Defaults to false.
  /// {@endtemplate}
  final bool shrinkWrap;

  /// {@template flutter.widgets.scroll_view.physics}
  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions. Furthermore, if [primary] is
  /// false, then the user cannot scroll if there is insufficient content to
  /// scroll, while if [primary] is true, they can always attempt to scroll.
  ///
  /// To force the scroll view to always be scrollable even if there is
  /// insufficient content, as if [primary] was true but without necessarily
  /// setting it to true, provide an [AlwaysScrollableScrollPhysics] physics
  /// object, as in:
  ///
  /// ```dart
  ///   physics: const AlwaysScrollableScrollPhysics(),
  /// ```
  ///
  /// To force the scroll view to use the default platform conventions and not
  /// be scrollable if there is insufficient content, regardless of the value of
  /// [primary], provide an explicit [ScrollPhysics] object, as in:
  ///
  /// ```dart
  ///   physics: const ScrollPhysics(),
  /// ```
  ///
  /// The physics can be changed dynamically (by providing a new object in a
  /// subsequent build), but new physics will only take effect if the _class_ of
  /// the provided object changes. Merely constructing a new instance with a
  /// different configuration is insufficient to cause the physics to be
  /// reapplied. (This is because the final object used is generated
  /// dynamically, which can be relatively expensive, and it would be
  /// inefficient to speculatively create this object each frame to see if the
  /// physics should be updated.)
  /// {@endtemplate}
  ///
  /// If an explicit [ScrollBehavior] is provided to [scrollBehavior], the
  /// [ScrollPhysics] provided by that behavior will take precedence after
  /// [physics].
  final ScrollPhysics? physics;

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtent}
  final double? cacheExtent;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@template flutter.widgets.scroll_view.keyboardDismissBehavior}
  /// [ScrollViewKeyboardDismissBehavior] the defines how this [ScrollView] will
  /// dismiss the keyboard automatically.
  /// {@endtemplate}
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
        final scheduledMessages = state.scheduledMessages.where(_isListed).toList();
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
          separatorBuilder: (context, index) => widget.separatorBuilder(context, scheduledMessages, index),
          itemBuilder: (context, index) {
            final scheduledMessage = scheduledMessages[index];
            final onTap = widget.onScheduledMessageTap;
            final onLongPress = widget.onScheduledMessageLongPress;
            final item = StreamScheduledMessageListItem(
              scheduledMessage: scheduledMessage,
              onTap: onTap == null ? null : () => onTap(scheduledMessage),
              onLongPress: onLongPress == null ? null : () => onLongPress(scheduledMessage),
            );

            return widget.itemBuilder?.call(context, scheduledMessages, index, item) ?? item;
          },
        );
      },
    );
  }

  // The loading, error or empty state shown while there is no row to list.
  Widget _buildPlaceholder(BuildContext context) {
    if (_isLoading) {
      if (widget.loadingBuilder?.call(context) case final loading?) return loading;
      return Center(
        child: StreamScheduledMessageListSkeletonLoading(padding: widget.padding),
      );
    }

    if (_error case final error?) {
      if (widget.errorBuilder?.call(context, error) case final custom?) return custom;

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

/// A widget that is used to display a separator between
/// [StreamScheduledMessageListItem] items.
class StreamScheduledMessageListSeparator extends StatelessWidget {
  /// Creates a new instance of [StreamScheduledMessageListSeparator].
  const StreamScheduledMessageListSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    return Divider(height: 1, color: colorScheme.borderSubtle);
  }
}
