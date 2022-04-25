import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';

/// Signature for a function that creates a widget for a given index, e.g., in a
/// [PagedValueListView].
typedef PagedValueListViewIndexedWidgetBuilder<T> = Widget Function(
  BuildContext context,
  List<T> values,
  int index,
);

/// Signature for the item builder that creates the children of the
/// [PagedValueListView].
typedef PagedValueListViewLoadMoreErrorBuilder = Widget Function(
  BuildContext context,
  StreamChatError error,
);

/// A [ListView] that loads more pages when the user scrolls to the end of the
/// list.
///
/// Use [loadMoreTriggerIndex] to set the index of the item that triggers the
/// loading of the next page.
class PagedValueListView<K, V> extends StatefulWidget {
  /// Creates a new instance of [PagedValueListView] widget.
  const PagedValueListView({
    Key? key,
    required this.controller,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.emptyBuilder,
    required this.loadMoreErrorBuilder,
    required this.loadMoreIndicatorBuilder,
    required this.loadingBuilder,
    required this.errorBuilder,
    this.loadMoreTriggerIndex = 3,
    this.padding,
    this.physics,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.scrollBehavior,
    this.shrinkWrap = false,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
  }) : super(key: key);

  /// The [PagedValueNotifier] used to control the list of items.
  final PagedValueNotifier<K, V> controller;

  /// A builder that is called to build items in the [ListView].
  ///
  /// The `value` parameter is the [V] at this position in the list.
  final PagedValueListViewIndexedWidgetBuilder<V> itemBuilder;

  /// A builder that is called to build the list separator.
  final PagedValueListViewIndexedWidgetBuilder<V> separatorBuilder;

  /// A builder that is called to build the empty state of the list.
  final WidgetBuilder emptyBuilder;

  /// A builder that is called to build the load more error state of the list.
  final PagedValueListViewLoadMoreErrorBuilder loadMoreErrorBuilder;

  /// A builder that is called to build the load more indicator of the list.
  final WidgetBuilder loadMoreIndicatorBuilder;

  /// A builder that is called to build the loading state of the list.
  final WidgetBuilder loadingBuilder;

  /// A builder that is called to build the error state of the list.
  final Widget Function(BuildContext, StreamChatError) errorBuilder;

  /// The index to take into account when triggering [controller.loadMore].
  final int loadMoreTriggerIndex;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry? padding;

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

  /// {@macro flutter.widgets.shadow.scrollBehavior}
  ///
  /// [ScrollBehavior]s also provide [ScrollPhysics]. If an explicit
  /// [ScrollPhysics] is provided in [physics], it will take precedence,
  /// followed by [scrollBehavior], and then the inherited ancestor
  /// [ScrollBehavior].
  final ScrollBehavior? scrollBehavior;

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

  @override
  State<PagedValueListView<K, V>> createState() =>
      _PagedValueListViewState<K, V>();
}

class _PagedValueListViewState<K, V> extends State<PagedValueListView<K, V>> {
  PagedValueNotifier<K, V> get _controller => widget.controller;

  // Avoids duplicate requests on rebuilds.
  bool _hasRequestedNextPage = false;

  @override
  void initState() {
    super.initState();
    _controller.doInitialLoad();
  }

  @override
  void didUpdateWidget(covariant PagedValueListView<K, V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller != oldWidget.controller) {
      // reset duplicate requests flag
      _hasRequestedNextPage = false;
      _controller.doInitialLoad();
    }
  }

  @override
  Widget build(BuildContext context) => PagedValueListenableBuilder<K, V>(
        valueListenable: _controller,
        builder: (context, value, _) => value.when(
          (items, nextPageKey, error) {
            if (items.isEmpty) {
              return widget.emptyBuilder(context);
            }

            return ListView.separated(
              padding: widget.padding,
              physics: widget.physics,
              reverse: widget.reverse,
              controller: widget.scrollController,
              primary: widget.primary,
              shrinkWrap: widget.shrinkWrap,
              keyboardDismissBehavior: widget.keyboardDismissBehavior,
              restorationId: widget.restorationId,
              dragStartBehavior: widget.dragStartBehavior,
              cacheExtent: widget.cacheExtent,
              itemCount: value.itemCount,
              separatorBuilder: (context, index) =>
                  widget.separatorBuilder(context, items, index),
              itemBuilder: (context, index) {
                if (!_hasRequestedNextPage) {
                  final newPageRequestTriggerIndex =
                      items.length - widget.loadMoreTriggerIndex;
                  final isBuildingTriggerIndexItem =
                      index == newPageRequestTriggerIndex;
                  if (nextPageKey != null && isBuildingTriggerIndexItem) {
                    // Schedules the request for the end of this frame.
                    WidgetsBinding.instance?.addPostFrameCallback((_) async {
                      if (error == null) {
                        await _controller.loadMore(nextPageKey);
                      }
                      _hasRequestedNextPage = false;
                    });
                    _hasRequestedNextPage = true;
                  }
                }

                if (index == items.length) {
                  if (error != null) {
                    return widget.loadMoreErrorBuilder(context, error);
                  }
                  return widget.loadMoreIndicatorBuilder(context);
                }

                return widget.itemBuilder(context, items, index);
              },
            );
          },
          loading: () => widget.loadingBuilder(context),
          error: (error) => widget.errorBuilder(context, error),
        ),
      );
}
