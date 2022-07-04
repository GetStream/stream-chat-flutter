import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum _LoadingStatus { loading, stable }

/// Wrapper around a [Scrollable] which triggers [onEndOfPage]/[onStartOfPage] the Scrollable
/// reaches to the start or end of the view extent.
class LazyLoadScrollView extends StatefulWidget {
  /// Creates a new instance of [LazyLoadScrollView]. The parameter [child]
  /// must be supplied and not null.
  const LazyLoadScrollView({
    super.key,
    required this.child,
    this.onStartOfPage,
    this.onEndOfPage,
    this.onPageScrollStart,
    this.onPageScrollEnd,
    this.onInBetweenOfPage,
    this.scrollOffset = 100,
    this.allowNotificationBubbling = false,
  });

  /// The [Widget] that this widget watches for changes on
  final Widget child;

  /// Called when the [child] reaches the start of the list
  final AsyncCallback? onStartOfPage;

  /// Called when the [child] reaches the end of the list
  final AsyncCallback? onEndOfPage;

  /// Called when the list scrolling starts
  final VoidCallback? onPageScrollStart;

  /// Called when the list scrolling ends
  final VoidCallback? onPageScrollEnd;

  /// Called every time the [child] is in-between the list
  final VoidCallback? onInBetweenOfPage;

  /// The offset to take into account when triggering [onEndOfPage]/[onStartOfPage] in pixels
  final double scrollOffset;

  /// If true the notifications will keep bubbling up the tree
  final bool allowNotificationBubbling;

  @override
  State<StatefulWidget> createState() => _LazyLoadScrollViewState();
}

class _LazyLoadScrollViewState extends State<LazyLoadScrollView> {
  var _loadMoreStatus = _LoadingStatus.stable;
  double _scrollPosition = 0;

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: _onNotification,
        child: widget.child,
      );

  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      if (widget.onPageScrollStart != null) {
        widget.onPageScrollStart!();
        return widget.allowNotificationBubbling;
      }
    }
    if (notification is ScrollEndNotification) {
      if (widget.onPageScrollEnd != null) {
        widget.onPageScrollEnd!();
        return widget.allowNotificationBubbling;
      }
    }
    if (notification is ScrollUpdateNotification) {
      final pixels = notification.metrics.pixels;
      final maxScrollExtent = notification.metrics.maxScrollExtent;
      final minScrollExtent = notification.metrics.minScrollExtent;
      final scrollOffset = widget.scrollOffset;

      if (pixels > (minScrollExtent + scrollOffset) &&
          pixels < (maxScrollExtent - scrollOffset)) {
        if (widget.onInBetweenOfPage != null) {
          widget.onInBetweenOfPage!();
          return widget.allowNotificationBubbling;
        }
      }

      final extentBefore = notification.metrics.extentBefore;
      final extentAfter = notification.metrics.extentAfter;
      final scrollingDown = _scrollPosition < pixels;
      _scrollPosition = pixels;

      if (scrollingDown) {
        if (extentAfter <= scrollOffset) {
          _onEndOfPage();
          return widget.allowNotificationBubbling;
        }
      } else {
        if (extentBefore <= scrollOffset) {
          _onStartOfPage();
          return widget.allowNotificationBubbling;
        }
      }
    }
    if (notification is OverscrollNotification) {
      if (notification.overscroll > 0) {
        _onEndOfPage();
      }
      if (notification.overscroll < 0) {
        _onStartOfPage();
      }
      return widget.allowNotificationBubbling;
    }
    return widget.allowNotificationBubbling;
  }

  void _onEndOfPage() {
    if (_loadMoreStatus == _LoadingStatus.stable) {
      if (widget.onEndOfPage != null) {
        _loadMoreStatus = _LoadingStatus.loading;
        widget.onEndOfPage!().whenComplete(() {
          _loadMoreStatus = _LoadingStatus.stable;
        });
      }
    }
  }

  void _onStartOfPage() {
    if (_loadMoreStatus == _LoadingStatus.stable) {
      if (widget.onStartOfPage != null) {
        _loadMoreStatus = _LoadingStatus.loading;
        widget.onStartOfPage!().whenComplete(() {
          _loadMoreStatus = _LoadingStatus.stable;
        });
      }
    }
  }
}
