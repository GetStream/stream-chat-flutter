import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// Callback that performs a refresh and returns a [Future] that completes
/// when the refresh is done.
typedef RefreshCallback = Future<void> Function();

/// {@template unreadThreadsBanner}
/// A widget that shows a banner with the number of unread threads.
///
/// This widget can be used to show a banner with the number of unread threads
/// on the top of the [StreamThreadListView].
///
/// {@endtemplate}
class StreamUnreadThreadsBanner extends StatefulWidget {
  /// {@macro unreadThreadsBanner}
  const StreamUnreadThreadsBanner({
    super.key,
    required this.unreadThreads,
    this.onRefresh,
    this.margin = EdgeInsets.zero,
    this.padding,
  });

  /// The set of all the unread threads.
  final Set<String> unreadThreads;

  /// Called when the user taps the banner.
  ///
  /// While the returned [Future] is pending, the banner shows a loading
  /// spinner instead of the refresh icon and label.
  final RefreshCallback? onRefresh;

  /// The margin applied to the banner.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry? margin;

  /// The padding applied to the banner.
  ///
  /// Defaults to `EdgeInsets.all(spacing.sm)`.
  final EdgeInsetsGeometry? padding;

  @override
  State<StreamUnreadThreadsBanner> createState() => _StreamUnreadThreadsBannerState();
}

class _StreamUnreadThreadsBannerState extends State<StreamUnreadThreadsBanner> {
  bool _isRefreshing = false;

  Future<void> _handleTap() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);
    try {
      await widget.onRefresh?.call();
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVisible = _isRefreshing || widget.unreadThreads.isNotEmpty;
    if (!isVisible) return const Empty();

    return GestureDetector(
      onTap: _isRefreshing ? null : _handleTap,
      child: Container(
        margin: widget.margin,
        padding: widget.padding ?? EdgeInsets.all(context.streamSpacing.sm),
        color: context.streamColorScheme.backgroundSurface,
        child: _isRefreshing ? _buildLoading() : _buildContent(context),
      ),
    );
  }

  Widget _buildLoading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamLoadingSpinner(
          color: context.streamColorScheme.textSecondary,
        ),
        SizedBox(width: context.streamSpacing.xs),
        Text(
          context.translations.loadingLabel,
          style: context.streamTextTheme.metadataEmphasis,
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          context.streamIcons.refresh20,
          size: 20,
          color: context.streamColorScheme.textSecondary,
        ),
        SizedBox(width: context.streamSpacing.xs),
        Text(
          context.translations.newThreadsLabel(
            count: widget.unreadThreads.length,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.streamTextTheme.metadataEmphasis,
        ),
      ],
    );
  }
}
