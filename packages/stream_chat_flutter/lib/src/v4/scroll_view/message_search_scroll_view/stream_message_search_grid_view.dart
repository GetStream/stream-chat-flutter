import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';

import 'package:stream_chat_flutter/src/v4/scroll_view/stream_scroll_view_empty_widget.dart';
import 'package:stream_chat_flutter/src/v4/scroll_view/stream_scroll_view_error_widget.dart';
import 'package:stream_chat_flutter/src/v4/scroll_view/stream_scroll_view_load_more_error.dart';
import 'package:stream_chat_flutter/src/v4/scroll_view/stream_scroll_view_load_more_indicator.dart';
import 'package:stream_chat_flutter/src/v4/scroll_view/stream_scroll_view_loading_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Default grid delegate  for [StreamMessageSearchGridView].
const defaultMessageSearchGridViewDelegate =
    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4);

/// Signature for the item builder that creates the children of the
/// [StreamMessageSearchGridView].
typedef StreamMessageSearchGridViewIndexedWidgetBuilder
    = PagedValueScrollViewIndexedWidgetBuilder<GetMessageResponse>;

/// A [GridView] that shows a grid of [GetMessageResponse]s,
/// it uses [StreamMessageSearchGridTile] as a default item.
///
/// Example:
///
/// ```dart
/// StreamMessageSearchGridView(
///   controller: controller,
///   itemBuilder: (context, messageResponses, index) {
///     return GridTile(message: messageResponses[index]);
///   },
/// )
/// ```
///
/// See also:
/// * [StreamUserListTile]
/// * [StreamUserListController]
class StreamMessageSearchGridView extends StatelessWidget {
  /// Creates a new instance of [StreamMessageSearchGridView].
  const StreamMessageSearchGridView({
    Key? key,
    required this.controller,
    required this.itemBuilder,
    this.gridDelegate = defaultMessageSearchGridViewDelegate,
    this.emptyBuilder,
    this.loadMoreErrorBuilder,
    this.loadMoreIndicatorBuilder,
    this.loadingBuilder,
    this.errorBuilder,
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
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  }) : super(key: key);

  /// The [StreamUserListController] used to control the grid of users.
  final StreamMessageSearchListController controller;

  /// A delegate that controls the layout of the children within
  /// the [PagedValueGridView].
  final SliverGridDelegate gridDelegate;

  /// A builder that is called to build items in the [PagedValueGridView].
  ///
  /// The `value` parameter is the [GetMessageBuilder] at this position in the grid.
  final StreamMessageSearchGridViewIndexedWidgetBuilder itemBuilder;

  /// A builder that is called to build the empty state of the grid.
  final WidgetBuilder? emptyBuilder;

  /// A builder that is called to build the load more error state of the grid.
  final PagedValueScrollViewLoadMoreErrorBuilder? loadMoreErrorBuilder;

  /// A builder that is called to build the load more indicator of the grid.
  final WidgetBuilder? loadMoreIndicatorBuilder;

  /// A builder that is called to build the loading state of the grid.
  final WidgetBuilder? loadingBuilder;

  /// A builder that is called to build the error state of the grid.
  final Widget Function(BuildContext, StreamChatError)? errorBuilder;

  /// The index to take into account when triggering [controller.loadMore].
  final int loadMoreTriggerIndex;

  /// {@template flutter.widgets.scroll_view.scrollDirection}
  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  /// {@endtemplate}
  final Axis scrollDirection;

  /// {@template flutter.widgets.scroll_view.reverse}
  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right and
  /// [scrollDirection] is [Axis.horizontal], then the scroll view scrolls from
  /// left to right when [reverse] is false and from right to left when
  /// [reverse] is true.
  ///
  /// Similarly, if [scrollDirection] is [Axis.vertical], then the scroll view
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
  /// ScrollAction is not handled by an otherwise focused part of the application,
  /// the ScrollAction will be evaluated using this scroll view, for example,
  /// when executing [Shortcuts] key events like page up and down.
  ///
  /// On iOS, this also identifies the scroll view that will scroll to top in
  /// response to a tap in the status bar.
  /// {@endtemplate}
  ///
  /// Defaults to true when [scrollDirection] is [Axis.vertical] and
  /// [controller] is null.
  final bool? primary;

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

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtent}
  final double? cacheExtent;

  /// The number of children that will contribute semantic information.
  ///
  /// Some subtypes of [ScrollView] can infer this value automatically. For
  /// example [ListView] will use the number of widgets in the child list,
  /// while the [ListView.separated] constructor will use half that amount.
  ///
  /// For [CustomScrollView] and other types which do not receive a builder
  /// or list of widgets, the child count must be explicitly provided. If the
  /// number is unknown or unbounded this should be left unset or set to null.
  ///
  /// See also:
  ///
  ///  * [SemanticsConfiguration.scrollChildCount], the corresponding semantics property.
  final int? semanticChildCount;

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
  Widget build(BuildContext context) {
    return PagedValueGridView<String, GetMessageResponse>(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      scrollController: scrollController,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      gridDelegate: gridDelegate,
      itemBuilder: itemBuilder,
      emptyBuilder: (context) {
        final chatThemeData = StreamChatTheme.of(context);
        return emptyBuilder?.call(context) ??
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: StreamScrollViewEmptyWidget(
                  emptyIcon: StreamSvgIcon.message(
                    size: 148,
                    color: chatThemeData.colorTheme.disabled,
                  ),
                  emptyTitle: Text(
                    context.translations.emptyMessagesText,
                    style: chatThemeData.textTheme.headline,
                  ),
                ),
              ),
            );
      },
      loadMoreErrorBuilder: (context, error) =>
          StreamScrollViewLoadMoreError.grid(
        onTap: controller.retry,
        error: Text(context.translations.loadingMessagesError),
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
              onRetryPressed: controller.refresh,
            ),
          ),
    );
  }
}
