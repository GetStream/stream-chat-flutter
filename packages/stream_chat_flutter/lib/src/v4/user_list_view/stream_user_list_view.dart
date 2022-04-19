import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/v4/stream_list_view_indexed_widget_builder.dart';
import 'package:stream_chat_flutter/src/v4/user_list_view/stream_user_list_tile.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Default separator builder for [StreamUserListView].
Widget defaultUserListViewSeparatorBuilder(
  BuildContext context,
  List<User> users,
  int index,
) =>
    const StreamUserListSeparator();

/// Signature for the item builder that creates the children of the
/// [StreamUserListView].
typedef StreamUserListViewIndexedWidgetBuilder
    = StreamListViewIndexedWidgetBuilder<User, StreamUserListTile>;

/// A [ListView] that shows a list of [User]s,
/// it uses [StreamUserListTile] as a default item.
///
/// This is the new version of [UserListView] that uses
/// [StreamUserListController].
///
/// Example:
///
/// ```dart
/// StreamUserListView(
///   controller: controller,
///   onUserTap: (user) {
///     // Handle user tap event
///   },
///   onUserLongPress: (user) {
///     // Handle user long press event
///   },
/// )
/// ```
///
/// See also:
/// * [StreamUserListTile]
/// * [StreamUserListController]
class StreamUserListView extends StatelessWidget {
  /// Creates a new instance of [StreamUserListView].
  const StreamUserListView({
    Key? key,
    required this.controller,
    this.itemBuilder,
    this.separatorBuilder = defaultUserListViewSeparatorBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.onUserTap,
    this.onUserLongPress,
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

  /// The [StreamUserListController] used to control the list of users.
  final StreamUserListController controller;

  /// A builder that is called to build items in the [ListView].
  ///
  /// The `user` parameter is the [User] at this position in the list
  /// and the `defaultWidget` is the default widget used
  /// i.e: [StreamUserListTile].
  final StreamUserListViewIndexedWidgetBuilder? itemBuilder;

  /// A builder that is called to build the list separator.
  final PagedValueListViewIndexedWidgetBuilder<User> separatorBuilder;

  /// A builder that is called to build the empty state of the list.
  ///
  /// If not provided, [StreamUserListEmptyWidget] will be used.
  final WidgetBuilder? emptyBuilder;

  /// A builder that is called to build the loading state of the list.
  ///
  /// If not provided, [StreamUserListLoadingTile] will be used.
  final WidgetBuilder? loadingBuilder;

  /// A builder that is called to build the error state of the list.
  ///
  /// If not provided, [StreamUserListErrorWidget] will be used.
  final Widget Function(BuildContext, StreamChatError)? errorBuilder;

  /// Called when the user taps this list tile.
  final void Function(User)? onUserTap;

  /// Called when the user long-presses on this list tile.
  final void Function(User)? onUserLongPress;

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
  Widget build(BuildContext context) => PagedValueListView<int, User>(
        padding: padding,
        physics: physics,
        reverse: reverse,
        controller: controller,
        primary: primary,
        shrinkWrap: shrinkWrap,
        keyboardDismissBehavior: keyboardDismissBehavior,
        restorationId: restorationId,
        dragStartBehavior: dragStartBehavior,
        cacheExtent: cacheExtent,
        loadMoreTriggerIndex: loadMoreTriggerIndex,
        separatorBuilder: separatorBuilder,
        itemBuilder: (context, users, index) {
          final user = users[index];
          final onTap = onUserTap;
          final onLongPress = onUserLongPress;

          final streamUserListTile = StreamUserListTile(
            user: user,
            onTap: onTap == null ? null : () => onTap(user),
            onLongPress: onLongPress == null ? null : () => onLongPress(user),
          );

          return itemBuilder?.call(
                context,
                users,
                index,
                streamUserListTile,
              ) ??
              streamUserListTile;
        },
        loadMoreErrorBuilder: (context, error) =>
            StreamUserListLoadMoreError(onTap: controller.retry),
        loadMoreIndicatorBuilder: (context) => const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: StreamUserListLoadMoreIndicator(),
          ),
        ),
        emptyBuilder: (context) =>
            emptyBuilder?.call(context) ??
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: StreamUserListEmptyWidget(),
              ),
            ),
        loadingBuilder: (context) =>
            loadingBuilder?.call(context) ??
            ListView.separated(
              padding: padding,
              physics: physics,
              reverse: reverse,
              itemCount: 25,
              separatorBuilder: (_, __) => const StreamUserListSeparator(),
              itemBuilder: (_, __) => const StreamChannelListLoadingTile(),
            ),
        errorBuilder: (context, error) =>
            errorBuilder?.call(context, error) ??
            Center(
              child: StreamUserListErrorWidget(
                onPressed: controller.refresh,
              ),
            ),
      );
}

/// A [StreamUserListTile] that can be used in a [ListView] to show a
/// loading tile while waiting for the [StreamUserListController] to load
/// more channels.
class StreamUserListLoadMoreIndicator extends StatelessWidget {
  /// Creates a new instance of [StreamUserListLoadMoreIndicator].
  const StreamUserListLoadMoreIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator.adaptive(),
      );
}

/// A [StreamUserListTile] that is used to display the error indicator when
/// loading more users fails.
class StreamUserListLoadMoreError extends StatelessWidget {
  /// Creates a new instance of [StreamUserListLoadMoreError].
  const StreamUserListLoadMoreError({
    Key? key,
    this.onTap,
  }) : super(key: key);

  /// The callback to invoke when the user taps on the error indicator.
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        color: theme.colorTheme.textLowEmphasis.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.translations.loadingChannelsError,
                style: theme.textTheme.body.copyWith(
                  color: Colors.white,
                ),
              ),
              StreamSvgIcon.retry(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

/// A widget that is used to display a separator between
/// [StreamUserListTile] items.
class StreamUserListSeparator extends StatelessWidget {
  /// Creates a new instance of [StreamUserListSeparator].
  const StreamUserListSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effect = StreamChatTheme.of(context).colorTheme.borderBottom;
    return Container(
      height: 1,
      color: effect.color!.withOpacity(effect.alpha ?? 1.0),
    );
  }
}

/// A widget that is used to display an error screen
/// when [StreamUserListController] fails to load initial users.
class StreamUserListErrorWidget extends StatelessWidget {
  /// Creates a new instance of [StreamUserListErrorWidget] widget.
  const StreamUserListErrorWidget({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  /// The callback to invoke when the user taps on the retry button.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text.rich(
            TextSpan(
              children: [
                const WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(right: 2),
                    child: Icon(Icons.error_outline),
                  ),
                ),
                TextSpan(text: context.translations.loadingChannelsError),
              ],
            ),
            style: Theme.of(context).textTheme.headline6,
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(context.translations.retryLabel),
          ),
        ],
      );
}

/// A widget that is used to display an empty state when
/// [StreamUserListController] loads zero users.
class StreamUserListEmptyWidget extends StatelessWidget {
  /// Creates a new instance of [StreamUserListEmptyWidget] widget.
  const StreamUserListEmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamSvgIcon.message(
          size: 148,
          color: chatThemeData.colorTheme.disabled,
        ),
        const SizedBox(height: 28),
        Text(
          context.translations.letsStartChattingLabel,
          style: chatThemeData.textTheme.headline,
        ),
      ],
    );
  }
}
