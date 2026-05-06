import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/widgets/stream_draft_list_tile.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Default separator builder for [StreamDraftListView].
Widget defaultDraftListViewSeparatorBuilder(
  BuildContext context,
  List<Draft> drafts,
  int index,
) => const StreamDraftListSeparator();

/// Signature for the item builder that creates the children of the
/// [StreamDraftListView].
typedef StreamDraftListViewIndexedWidgetBuilder = StreamScrollViewIndexedWidgetBuilder<Draft, StreamDraftListTile>;

/// A [ListView] that shows a list of [Draft]'s. It uses a
/// [StreamDraftListController] to load the drafts in paginated form.
///
/// Example:
///
/// ```dart
/// StreamDraftListView(
///   controller: controller,
///   onDraftTap: (draft) {
///     // Handle draft tap event
///   },
///   onDraftLongPress: (draft) {
///     // Handle draft long press event
///   },
/// )
/// ```
///
/// See also:
/// * [StreamDraftListTile]
/// * [StreamDraftListController]
class StreamDraftListView extends StatelessWidget {
  /// Creates a new [StreamDraftListView].
  const StreamDraftListView({
    super.key,
    required this.controller,
    this.itemBuilder,
    this.separatorBuilder = defaultDraftListViewSeparatorBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.onDraftTap,
    this.onDraftLongPress,
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

  /// The [StreamDraftListController] used to control the drafts in the list.
  final StreamDraftListController controller;

  /// A builder that is called to build items in the [ListView].
  final StreamDraftListViewIndexedWidgetBuilder? itemBuilder;

  /// A builder that is called to build the list separator.
  final PagedValueScrollViewIndexedWidgetBuilder<Draft> separatorBuilder;

  /// A builder that is called to build the empty state of the list.
  final WidgetBuilder? emptyBuilder;

  /// A builder that is called to build the loading state of the list.
  final WidgetBuilder? loadingBuilder;

  /// A builder that is called to build the error state of the list.
  final Widget Function(BuildContext, StreamChatError)? errorBuilder;

  /// Called when the user taps this list tile.
  final void Function(Draft)? onDraftTap;

  /// Called when the user long-presses on this list tile.
  final void Function(Draft)? onDraftLongPress;

  /// The index to take into account when triggering [controller.loadMore].
  final int loadMoreTriggerIndex;

  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
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

  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// Defaults to false.
  final bool reverse;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  final ScrollController? scrollController;

  /// Whether this is the primary scroll view associated with the parent
  /// [PrimaryScrollController].
  ///
  /// Defaults to true when [scrollController] is null.
  final bool? primary;

  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  /// Defaults to false.
  final bool shrinkWrap;

  /// How the scroll view should respond to user input.
  final ScrollPhysics? physics;

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtent}
  final double? cacheExtent;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// Defines how this [ScrollView] will dismiss the keyboard automatically.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String? restorationId;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return PagedValueListView<String, Draft>(
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
      itemBuilder: (context, drafts, index) {
        final draft = drafts[index];
        final currentUser = StreamChat.of(context).currentUser;
        final onTap = onDraftTap;
        final onLongPress = onDraftLongPress;

        final tile = StreamDraftListTile(
          draft: draft,
          currentUser: currentUser,
          onTap: onTap == null ? null : () => onTap(draft),
          onLongPress: onLongPress == null ? null : () => onLongPress(draft),
        );

        return itemBuilder?.call(context, drafts, index, tile) ?? tile;
      },
      emptyBuilder: (context) =>
          emptyBuilder?.call(context) ??
          Center(
            child: StreamScrollViewEmptyWidget(
              emptyIcon: Icon(context.streamIcons.edit),
              emptyTitle: Text(context.translations.emptyMessagesText),
            ),
          ),
      loadMoreErrorBuilder: (context, error) => _LoadMoreError(
        onTap: controller.retry,
        error: context.translations.loadingMessagesError,
      ),
      loadMoreIndicatorBuilder: (context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
      loadingBuilder: (context) =>
          loadingBuilder?.call(context) ??
          const Center(
            child: SizedBox.square(
              dimension: 42,
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
      errorBuilder: (context, error) =>
          errorBuilder?.call(context, error) ??
          Center(
            child: _ErrorWidget(
              errorTitle: context.translations.loadingMessagesError,
              onRetry: controller.refresh,
            ),
          ),
    );
  }
}

/// A simple error widget shown when the draft list fails to load.
class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({
    required this.errorTitle,
    required this.onRetry,
  });

  final String errorTitle;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(errorTitle),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}

/// A simple load-more error widget shown inline in the list.
class _LoadMoreError extends StatelessWidget {
  const _LoadMoreError({
    required this.onTap,
    required this.error,
  });

  final VoidCallback onTap;
  final String error;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(error, style: const TextStyle(color: Colors.white)),
            const Icon(Icons.refresh, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// A widget that is used to display a separator between
/// [StreamDraftListTile] items.
class StreamDraftListSeparator extends StatelessWidget {
  /// Creates a new instance of [StreamDraftListSeparator].
  const StreamDraftListSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    return Divider(height: 1, color: colorScheme.borderSubtle);
  }
}
