import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Default separator builder for [StreamReactionListView].
Widget defaultReactionListViewSeparatorBuilder(
  BuildContext context,
  List<Reaction> reactions,
  int index,
) => const SizedBox.shrink();

/// Signature for the item builder that creates the children of the
/// [StreamReactionListView].
typedef StreamReactionListViewIndexedWidgetBuilder = PagedValueScrollViewIndexedWidgetBuilder<Reaction>;

/// {@template streamReactionListView}
/// A [ListView] that shows a list of [Reaction]s. It uses a
/// [StreamReactionListController] to load the reactions in paginated form.
///
/// Example:
///
/// ```dart
/// StreamReactionListView(
///   controller: controller,
///   itemBuilder: (context, reactions, index) {
///     final reaction = reactions[index];
///     return ListTile(title: Text(reaction.type));
///   },
/// )
/// ```
///
/// See also:
/// * [StreamReactionListController]
/// {@endtemplate}
class StreamReactionListView extends StatelessWidget {
  /// Creates a new instance of [StreamReactionListView].
  const StreamReactionListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.separatorBuilder = defaultReactionListViewSeparatorBuilder,
    this.emptyBuilder,
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
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  });

  /// The [StreamReactionListController] used to control the list of reactions.
  final StreamReactionListController controller;

  /// A builder that is called to build items in the [ListView].
  final StreamReactionListViewIndexedWidgetBuilder itemBuilder;

  /// A builder that is called to build the list separator.
  final PagedValueScrollViewIndexedWidgetBuilder<Reaction> separatorBuilder;

  /// A builder that is called to build the empty state of the list.
  final WidgetBuilder? emptyBuilder;

  /// A builder that is called to build the loading state of the list.
  final WidgetBuilder? loadingBuilder;

  /// A builder that is called to build the error state of the list.
  final Widget Function(BuildContext, StreamChatError)? errorBuilder;

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
  /// Defaults to true.
  final bool addAutomaticKeepAlives;

  /// Whether to wrap each child in a [RepaintBoundary].
  ///
  /// Defaults to true.
  final bool addRepaintBoundaries;

  /// Whether to wrap each child in an [IndexedSemantics].
  ///
  /// Defaults to true.
  final bool addSemanticIndexes;

  /// {@template flutter.widgets.scroll_view.reverse}
  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// Defaults to false.
  /// {@endtemplate}
  final bool reverse;

  /// {@template flutter.widgets.scroll_view.controller}
  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  /// {@endtemplate}
  final ScrollController? scrollController;

  /// {@template flutter.widgets.scroll_view.primary}
  /// Whether this is the primary scroll view associated with the parent
  /// [PrimaryScrollController].
  /// {@endtemplate}
  final bool? primary;

  /// {@template flutter.widgets.scroll_view.shrinkWrap}
  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  /// Defaults to false.
  /// {@endtemplate}
  final bool shrinkWrap;

  /// {@template flutter.widgets.scroll_view.physics}
  /// How the scroll view should respond to user input.
  /// {@endtemplate}
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
  Widget build(BuildContext context) => PagedValueListView<String?, Reaction>(
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
    itemBuilder: itemBuilder,
    emptyBuilder: (context) =>
        emptyBuilder?.call(context) ??
        Center(
          child: StreamScrollViewEmptyWidget(
            emptyIcon: Icon(context.streamIcons.emoji),
            emptyTitle: Text(context.translations.emptyReactionsText),
          ),
        ),
    loadMoreErrorBuilder: (context, error) => StreamScrollViewLoadMoreError.list(
      onTap: controller.retry,
      error: Text(context.translations.loadingReactionsError),
    ),
    loadMoreIndicatorBuilder: (context) => Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamLoadingSpinner(),
      ),
    ),
    loadingBuilder: (context) => loadingBuilder?.call(context) ?? const Center(child: StreamScrollViewLoadingWidget()),
    errorBuilder: (context, error) =>
        errorBuilder?.call(context, error) ??
        Center(
          child: StreamScrollViewErrorWidget(
            errorTitle: Text(context.translations.loadingReactionsError),
            onRetryPressed: controller.refresh,
          ),
        ),
  );
}
