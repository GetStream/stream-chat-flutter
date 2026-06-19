import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_core_flutter/chat.dart';

/// {@template unreadThreadsBanner}
/// A widget that displays an unread-threads banner.
///
/// When a [child] is provided, the banner appears above it — similar to how
/// [RefreshIndicator] wraps a scrollable. When [child] is omitted, the widget
/// renders only the banner itself.
///
/// When [enabled] is `false` (the default), the banner is hidden and only the
/// [child] (if any) is rendered. Set [enabled] to `true` and provide
/// [unreadThreads] to show the banner.
///
/// Example:
///
/// ```dart
/// StreamUnreadThreadsBanner(
///   enabled: true,
///   unreadThreads: unseenThreadIds,
///   onRefresh: () async {
///     await controller.refresh(resetValue: false);
///     controller.clearUnseenThreadIds();
///   },
///   child: StreamThreadListView(controller: controller),
/// )
/// ```
/// {@endtemplate}
class StreamUnreadThreadsBanner extends StatefulWidget {
  /// {@macro unreadThreadsBanner}
  const StreamUnreadThreadsBanner({
    super.key,
    this.child,
    this.enabled = false,
    this.unreadThreads = const {},
    this.onRefresh,
    this.margin = EdgeInsets.zero,
    this.padding,
  });

  /// The widget below the banner in the tree.
  ///
  /// When `null`, only the banner is rendered without any wrapped content.
  final Widget? child;

  /// Whether the banner is enabled.
  ///
  /// When `false`, the banner is hidden and only [child] is rendered.
  ///
  /// Defaults to `false`.
  final bool enabled;

  /// The set of all the unread thread IDs.
  final Set<String> unreadThreads;

  /// Called when the user taps the banner.
  ///
  /// While the returned [Future] is pending, the banner shows a loading
  /// spinner instead of the refresh icon and label.
  final Future<void> Function()? onRefresh;

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
    final banner = widget.enabled ? _buildBanner(context) : null;
    final child = widget.child;

    if (child == null) return banner ?? const Empty();

    return Column(
      children: [
        if (banner != null) banner,
        Expanded(child: child),
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    final isVisible = _isRefreshing || widget.unreadThreads.isNotEmpty;
    if (!isVisible) return const Empty();

    return GestureDetector(
      onTap: _isRefreshing ? null : _handleTap,
      child: Container(
        margin: widget.margin,
        padding: widget.padding ?? EdgeInsets.all(context.streamSpacing.sm),
        color: context.streamColorScheme.backgroundSurface,
        child: _isRefreshing ? _buildLoading(context) : _buildContent(context),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
          context.streamIcons.refresh,
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
