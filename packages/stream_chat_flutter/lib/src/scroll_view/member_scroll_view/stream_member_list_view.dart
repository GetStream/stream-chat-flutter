// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/scroll_view/stream_scroll_view_error_widget.dart';
import 'package:stream_chat_flutter/src/scroll_view/stream_scroll_view_load_more_error.dart';
import 'package:stream_chat_flutter/src/scroll_view/stream_scroll_view_load_more_indicator.dart';
import 'package:stream_chat_flutter/src/scroll_view/stream_scroll_view_loading_widget.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Default separator builder for [StreamMemberListView].
Widget defaultMemberListViewSeparatorBuilder(
  BuildContext context,
  List<Member> members,
  int index,
) =>
    const StreamUserListSeparator();

/// Signature for the item builder that creates the children of the
/// [StreamMemberListView].
typedef StreamMemberListViewIndexedWidgetBuilder
    = StreamScrollViewIndexedWidgetBuilder<Member, StreamUserListTile>;

/// Signature for the member grid tile, currently equal to [StreamUserListTile].
typedef StreamMemberListTile = StreamUserListTile;

/// A [ListView] that shows a list of [Member]s,
/// it uses [StreamMemberListTile] as a default item.
///
/// Example:
///
/// ```dart
/// StreamMemberListView(
///   controller: controller,
///   onMemberTap: (member) {
///     // Handle member tap event
///   },
///   onMemberLongPress: (member) {
///     // Handle member long press event
///   },
/// )
/// ```
///
/// See also:
/// * [StreamMemberListTile]
/// * [StreamMemberListController]
class StreamMemberListView extends StatelessWidget {
  /// Creates a new instance of [StreamMemberListView].
  const StreamMemberListView({
    super.key,
    required this.controller,
    this.itemBuilder,
    this.separatorBuilder = defaultMemberListViewSeparatorBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.onMemberTap,
    this.onMemberLongPress,
    this.loadMoreTriggerIndex = 3,
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

  /// The [StreamMemberListController] used to control the list of members.
  final StreamMemberListController controller;

  /// A builder that is called to build items in the [ListView].
  final StreamMemberListViewIndexedWidgetBuilder? itemBuilder;

  /// A builder that is called to build the list separator.
  final PagedValueScrollViewIndexedWidgetBuilder<Member> separatorBuilder;

  /// A builder that is called to build the empty state of the list.
  final WidgetBuilder? emptyBuilder;

  /// A builder that is called to build the loading state of the list.
  final WidgetBuilder? loadingBuilder;

  /// A builder that is called to build the error state of the list.
  final Widget Function(BuildContext, StreamChatError)? errorBuilder;

  /// Called when the member taps this list tile.
  final void Function(Member)? onMemberTap;

  /// Called when the member long-presses on this list tile.
  final void Function(Member)? onMemberLongPress;

  /// The index to take into account when triggering [controller.loadMore].
  final int loadMoreTriggerIndex;

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
  Widget build(BuildContext context) => PagedValueListView<int, Member>(
        scrollDirection: scrollDirection,
        padding: padding,
        physics: physics,
        reverse: reverse,
        controller: controller,
        scrollController: scrollController,
        primary: primary,
        shrinkWrap: shrinkWrap,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        keyboardDismissBehavior: keyboardDismissBehavior,
        restorationId: restorationId,
        dragStartBehavior: dragStartBehavior,
        cacheExtent: cacheExtent,
        clipBehavior: clipBehavior,
        loadMoreTriggerIndex: loadMoreTriggerIndex,
        separatorBuilder: separatorBuilder,
        itemBuilder: (context, members, index) {
          final member = members[index];
          final onTap = onMemberTap;
          final onLongPress = onMemberLongPress;

          final streamUserListTile = StreamMemberListTile(
            user: member.user!,
            onTap: onTap == null ? null : () => onTap(member),
            onLongPress: onLongPress == null ? null : () => onLongPress(member),
          );

          return itemBuilder?.call(
                context,
                members,
                index,
                streamUserListTile,
              ) ??
              streamUserListTile;
        },
        emptyBuilder: (context) {
          final chatThemeData = StreamChatTheme.of(context);
          return emptyBuilder?.call(context) ??
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: StreamScrollViewEmptyWidget(
                    emptyIcon: StreamSvgIcon.user(
                      size: 148,
                      color: chatThemeData.colorTheme.disabled,
                    ),
                    emptyTitle: Text(
                      context.translations.noUsersLabel,
                      style: chatThemeData.textTheme.headline,
                    ),
                  ),
                ),
              );
        },
        loadMoreErrorBuilder: (context, error) =>
            StreamScrollViewLoadMoreError.list(
          onTap: controller.retry,
          error: Text(context.translations.loadingUsersError),
        ),
        loadMoreIndicatorBuilder: (context) => const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: StreamScrollViewLoadMoreIndicator(),
          ),
        ),
        loadingBuilder: (context) =>
            loadingBuilder?.call(context) ??
            const Center(
              child: StreamScrollViewLoadingWidget(),
            ),
        errorBuilder: (context, error) =>
            errorBuilder?.call(context, error) ??
            Center(
              child: StreamScrollViewErrorWidget(
                errorTitle: Text(context.translations.loadingUsersError),
                onRetryPressed: controller.refresh,
              ),
            ),
      );
}
