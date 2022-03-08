import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/v4/channel_list_view/stream_channel_list_loading_tile.dart';
import 'package:stream_chat_flutter/src/v4/channel_list_view/stream_channel_list_tile.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Default separator builder for [StreamChannelListView].
Widget defaultSeparatorBuilder(BuildContext context, int index) =>
    const StreamChannelListSeparator();

/// Signature for the item builder that creates the children of the
/// [StreamChannelListView].
typedef StreamChannelListViewItemBuilder = Widget Function(
  BuildContext context,
  Channel channel,
  StreamChannelListTile defaultWidget,
);

/// A [ListView] that shows a list of [Channel]s,
/// it uses [StreamChannelListTile] as a default item.
///
/// This is the new version of [ChannelListView] that uses
/// [StreamChannelListController].
///
/// Example:
///
/// ```dart
/// StreamChannelListView(
///   controller: controller,
///   onChannelTap: (channel) {
///     // Handle channel tap event
///   },
///   onChannelLongPress: (channel) {
///     // Handle channel long press event
///   },
/// )
/// ```
///
/// See also:
/// * [StreamChannelListTile]
/// * [StreamChannelListController]
class StreamChannelListView extends StatefulWidget {
  /// Creates a new instance of [StreamChannelListView].
  const StreamChannelListView({
    Key? key,
    required this.controller,
    this.itemBuilder,
    this.separatorBuilder = defaultSeparatorBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.onChannelTap,
    this.onChannelLongPress,
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

  /// The [StreamChannelListController] used to control the list of channels.
  final StreamChannelListController controller;

  /// A builder that is called to build items in the [ListView].
  ///
  /// The `channel` parameter is the [Channel] at this position in the list
  /// and the `defaultWidget` is the default widget used
  /// i.e: [StreamChannelListTile].
  final StreamChannelListViewItemBuilder? itemBuilder;

  /// A builder that is called to build the list separator.
  final IndexedWidgetBuilder separatorBuilder;

  /// A builder that is called to build the empty state of the list.
  ///
  /// If not provider, [StreamChannelListEmptyWidget] will be used.
  final WidgetBuilder? emptyBuilder;

  /// A builder that is called to build the loading state of the list.
  ///
  /// If not provided, [StreamChannelListLoadingTile] will be used.
  final WidgetBuilder? loadingBuilder;

  /// A builder that is called to build the error state of the list.
  ///
  /// If not provided, [StreamChannelListErrorWidget] will be used.
  final Widget Function(BuildContext, StreamChatError)? errorBuilder;

  /// Called when the user taps this list tile.
  final void Function(Channel)? onChannelTap;

  /// Called when the user long-presses on this list tile.
  final void Function(Channel)? onChannelLongPress;

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
  _StreamChannelListViewState createState() => _StreamChannelListViewState();
}

class _StreamChannelListViewState extends State<StreamChannelListView> {
  StreamChannelListController get _controller => widget.controller;

  // Avoids duplicate requests on rebuilds.
  bool _hasRequestedNextPage = false;

  @override
  void initState() {
    super.initState();
    _controller.doInitialLoad();
  }

  @override
  void didUpdateWidget(covariant StreamChannelListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller != oldWidget.controller) {
      // reset duplicate requests flag
      _hasRequestedNextPage = false;
      _controller.doInitialLoad();
    }
  }

  @override
  Widget build(BuildContext context) =>
      PagedValueListenableBuilder<int, Channel>(
        valueListenable: widget.controller,
        builder: (context, value, _) => value.when(
          (channels, nextPageKey, error) {
            if (channels.isEmpty) {
              return widget.emptyBuilder?.call(context) ??
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: StreamChannelListEmptyWidget(),
                    ),
                  );
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
              separatorBuilder: widget.separatorBuilder,
              itemBuilder: (context, index) {
                if (!_hasRequestedNextPage) {
                  final newPageRequestTriggerIndex = channels.length - 3;
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

                if (index == channels.length) {
                  if (error != null) {
                    return StreamChannelListLoadMoreError(
                      onTap: _controller.retry,
                    );
                  }
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: StreamChannelListLoadMoreIndicator(),
                    ),
                  );
                }

                final channel = channels[index];

                final onTap = widget.onChannelTap;
                final onLongPress = widget.onChannelLongPress;

                final streamChannelListTile = StreamChannelListTile(
                  channel: channel,
                  onTap: onTap == null ? null : () => onTap(channel),
                  onLongPress:
                      onLongPress == null ? null : () => onLongPress(channel),
                );

                final itemBuilder = widget.itemBuilder;

                if (itemBuilder != null) {
                  return itemBuilder(
                    context,
                    channel,
                    streamChannelListTile,
                  );
                }

                return streamChannelListTile;
              },
            );
          },
          loading: () =>
              widget.loadingBuilder?.call(context) ??
              ListView.separated(
                padding: widget.padding,
                physics: widget.physics,
                reverse: widget.reverse,
                itemCount: 25,
                separatorBuilder: widget.separatorBuilder,
                itemBuilder: (_, __) => const StreamChannelListLoadingTile(),
              ),
          error: (error) =>
              widget.errorBuilder?.call(context, error) ??
              Center(
                child: StreamChannelListErrorWidget(
                  onPressed: _controller.refresh,
                ),
              ),
        ),
      );
}

/// A [StreamChannelListTile] that can be used in a [ListView] to show a
/// loading tile while waiting for the [StreamChannelListController] to load
/// more channels.
class StreamChannelListLoadMoreIndicator extends StatelessWidget {
  /// Creates a new instance of [StreamChannelListLoadMoreIndicator].
  const StreamChannelListLoadMoreIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator.adaptive(),
      );
}

/// A [StreamChannelListTile] that is used to display the error indicator when
/// loading more channels fails.
class StreamChannelListLoadMoreError extends StatelessWidget {
  /// Creates a new instance of [StreamChannelListLoadMoreError].
  const StreamChannelListLoadMoreError({
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
/// [StreamChannelListTile] items.
class StreamChannelListSeparator extends StatelessWidget {
  /// Creates a new instance of [StreamChannelListSeparator].
  const StreamChannelListSeparator({Key? key}) : super(key: key);

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
/// when [StreamChannelListController] fails to load initial channels.
class StreamChannelListErrorWidget extends StatelessWidget {
  /// Creates a new instance of [StreamChannelListErrorWidget] widget.
  const StreamChannelListErrorWidget({
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
/// [StreamChannelListController] loads zero channels.
class StreamChannelListEmptyWidget extends StatelessWidget {
  /// Creates a new instance of [StreamChannelListEmptyWidget] widget.
  const StreamChannelListEmptyWidget({Key? key}) : super(key: key);

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
