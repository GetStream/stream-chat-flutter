import 'package:flutter/material.dart';
import 'package:sample_app/widgets/stream_draft_list_tile.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Signature for the item builder that creates the children of the
/// [StreamDraftListView].
typedef StreamDraftListViewIndexedWidgetBuilder = StreamScrollViewIndexedWidgetBuilder<Draft, StreamDraftListTile>;

/// A [ListView] that shows a list of [Draft]'s. It uses a
/// [StreamDraftListController] to load the drafts in paginated form.
class StreamDraftListView extends StatelessWidget {
  /// Creates a new [StreamDraftListView].
  const StreamDraftListView({
    super.key,
    required this.controller,
    this.itemBuilder,
    this.onDraftTap,
  });

  /// The [StreamDraftListController] used to control the drafts in the list.
  final StreamDraftListController controller;

  /// A builder that is called to build items in the [ListView].
  final StreamDraftListViewIndexedWidgetBuilder? itemBuilder;

  /// Called when the user taps a draft tile.
  final void Function(Draft)? onDraftTap;

  @override
  Widget build(BuildContext context) {
    return PagedValueListView<String, Draft>(
      controller: controller,
      separatorBuilder: (_, _, _) => const StreamDraftListSeparator(),
      itemBuilder: (context, drafts, index) {
        final draft = drafts[index];
        final currentUser = StreamChat.of(context).currentUser;
        final onTap = onDraftTap;

        final tile = StreamDraftListTile(
          draft: draft,
          currentUser: currentUser,
          onTap: onTap == null ? null : () => onTap(draft),
        );

        return itemBuilder?.call(context, drafts, index, tile) ?? tile;
      },
      emptyBuilder: (context) => Center(
        child: StreamScrollViewEmptyWidget(
          emptyIcon: const Icon(Icons.drafts_outlined),
          emptyTitle: Text(context.translations.emptyMessagesText),
        ),
      ),
      loadMoreErrorBuilder: (context, error) => StreamScrollViewLoadMoreError.list(
        onTap: controller.retry,
        error: Text(context.translations.loadingMessagesError),
      ),
      loadMoreIndicatorBuilder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: StreamLoadingSpinner(),
        ),
      ),
      loadingBuilder: (context) => Center(
        child: StreamLoadingSpinner(),
      ),
      errorBuilder: (context, error) => Center(
        child: StreamScrollViewErrorWidget(
          errorTitle: Text(context.translations.loadingMessagesError),
          onRetryPressed: controller.refresh,
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
