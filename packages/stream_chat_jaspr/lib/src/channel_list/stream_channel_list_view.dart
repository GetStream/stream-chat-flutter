import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_jaspr/src/channel_list/stream_channel_list_controller.dart';
import 'package:stream_chat_jaspr/src/channel_list/stream_channel_list_tile.dart';
import 'package:universal_web/web.dart' as web;

/// Signature for a function that builds a component for a given [Channel].
typedef ChannelItemBuilder = Component Function(
  BuildContext context,
  Channel channel,
);

const _listStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.column,
  height: Unit.percent(100),
  overflow: Overflow.auto,
);

const _centerStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.column,
  justifyContent: JustifyContent.center,
  alignItems: AlignItems.center,
  padding: Padding.all(Unit.pixels(48)),
  fontSize: Unit.pixels(14),
  color: Color('#72767e'),
);

const _retryButtonStyles = Styles(
  padding: Padding.symmetric(
    horizontal: Unit.pixels(16),
    vertical: Unit.pixels(8),
  ),
  radius: BorderRadius.circular(Unit.pixels(6)),
  border: Border.all(color: Color('#005FFF'), width: Unit.pixels(1)),
  backgroundColor: Color('#005FFF'),
  color: Colors.white,
  cursor: Cursor.pointer,
  fontSize: Unit.pixels(14),
  raw: {'margin-top': '12px'},
);

const _loadMoreStyles = Styles(
  display: Display.flex,
  justifyContent: JustifyContent.center,
  padding: Padding.symmetric(vertical: Unit.pixels(16)),
  fontSize: Unit.pixels(13),
  color: Color('#72767e'),
);

/// A scrollable list of channels with pagination and real-time updates.
///
/// Requires a [StreamChannelListController] to manage state and data fetching.
/// Must be placed inside a [StreamChatProvider] so that child tiles can access
/// the client.
///
/// ```dart
/// StreamChannelListView(
///   controller: controller,
///   onChannelTap: (channel) => print('Tapped ${channel.id}'),
/// )
/// ```
class StreamChannelListView extends StatefulComponent {
  /// Creates a [StreamChannelListView].
  const StreamChannelListView({
    required this.controller,
    this.itemBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.onChannelTap,
    this.loadMoreThreshold = 200,
    super.key,
  });

  /// The controller that manages data and state.
  final StreamChannelListController controller;

  /// Custom builder for each channel tile.
  ///
  /// Defaults to [StreamChannelListTile].
  final ChannelItemBuilder? itemBuilder;

  /// Builder shown while the initial load is in progress.
  final Component Function(BuildContext context)? loadingBuilder;

  /// Builder shown when the channel list is empty.
  final Component Function(BuildContext context)? emptyBuilder;

  /// Builder shown when an error occurs.
  final Component Function(BuildContext context, Object error)? errorBuilder;

  /// Called when a channel tile is tapped (only applies to the default tile).
  final void Function(Channel channel)? onChannelTap;

  /// Distance from the bottom (in pixels) at which [loadMore] triggers.
  final int loadMoreThreshold;

  @override
  State<StreamChannelListView> createState() => _StreamChannelListViewState();
}

class _StreamChannelListViewState extends State<StreamChannelListView> {
  @override
  void initState() {
    super.initState();
    component.controller.onChanged = () {
      setState(() {});
    };
    component.controller.doInitialLoad();
  }

  @override
  void dispose() {
    component.controller.onChanged = null;
    super.dispose();
  }

  void _onScroll(web.Event event) {
    final target = event.target;
    if (target is! web.HTMLElement) return;

    final scrollTop = target.scrollTop;
    final scrollHeight = target.scrollHeight;
    final clientHeight = target.clientHeight;

    if (scrollTop + clientHeight >=
        scrollHeight - component.loadMoreThreshold) {
      component.controller.loadMore();
    }
  }

  @override
  Component build(BuildContext context) {
    final controller = component.controller;

    if (controller.state == ChannelListState.loading &&
        controller.channels.isEmpty) {
      return div(styles: _listStyles, [
        component.loadingBuilder?.call(context) ??
            div(styles: _centerStyles, [
              Component.text('Loading channels...'),
            ]),
      ]);
    }

    if (controller.state == ChannelListState.error &&
        controller.channels.isEmpty) {
      return div(styles: _listStyles, [
        component.errorBuilder?.call(context, controller.error!) ??
            div(styles: _centerStyles, [
              Component.text('Failed to load channels'),
              button(
                onClick: controller.refresh,
                styles: _retryButtonStyles,
                [Component.text('Retry')],
              ),
            ]),
      ]);
    }

    if (controller.state == ChannelListState.loaded &&
        controller.channels.isEmpty) {
      return div(styles: _listStyles, [
        component.emptyBuilder?.call(context) ??
            div(styles: _centerStyles, [
              Component.text('No channels found'),
            ]),
      ]);
    }

    final tiles = controller.channels.map((channel) {
      return component.itemBuilder?.call(context, channel) ??
          StreamChannelListTile(
            key: ValueKey(channel.cid),
            channel: channel,
            onTap: component.onChannelTap != null
                ? () => component.onChannelTap!(channel)
                : null,
          );
    }).toList();

    if (controller.isLoadingMore) {
      tiles.add(
        div(styles: _loadMoreStyles, [
          Component.text('Loading more...'),
        ]),
      );
    }

    return div(
      styles: _listStyles,
      events: {'scroll': _onScroll},
      tiles,
    );
  }
}
