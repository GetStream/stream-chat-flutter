import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum _LoadingStatus { LOADING, STABLE }

/// A widget that wraps a [Widget] and will trigger [onEndOfPage]/[onStartOfPage] when it
/// reaches the bottom/start of the list
class LazyLoadScrollView extends StatefulWidget {
  /// The [Widget] that this widget watches for changes on
  final Widget child;

  /// Called when the [child] reaches the start of the list
  final AsyncCallback onStartOfPage;

  /// Called when the [child] reaches the end of the list
  final AsyncCallback onEndOfPage;

  /// Called when the list scrolling starts
  final VoidCallback onPageScrollStart;

  /// Called when the list scrolling ends
  final VoidCallback onPageScrollEnd;

  /// Called every time the [child] is in-between the list
  final VoidCallback onInBetweenOfPage;

  /// The offset to take into account when triggering [onEndOfPage]/[onStartOfPage] in pixels
  final double scrollOffset;

  /// Used to determine if loading of new data has finished. You should use set this if you aren't using a FutureBuilder or StreamBuilder
  final bool isLoading;

  /// Initiates a LazyLoadScrollView widget
  const LazyLoadScrollView({
    Key key,
    @required this.child,
    this.onStartOfPage,
    this.onEndOfPage,
    this.onPageScrollStart,
    this.onPageScrollEnd,
    this.onInBetweenOfPage,
    this.isLoading = false,
    this.scrollOffset = 100,
  })  : assert(child != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _LazyLoadScrollViewState();
}

class _LazyLoadScrollViewState extends State<LazyLoadScrollView> {
  _LoadingStatus _loadMoreStatus = _LoadingStatus.STABLE;
  double _scrollPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      child: widget.child,
      onNotification: _onNotification,
    );
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollStartNotification) {
      if (widget.onPageScrollStart != null) {
        widget.onPageScrollStart();
        return true;
      }
    }
    if (notification is ScrollEndNotification) {
      if (widget.onPageScrollEnd != null) {
        widget.onPageScrollEnd();
        return true;
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
          widget.onInBetweenOfPage();
          return true;
        }
      }

      final extentBefore = notification.metrics.extentBefore;
      final extentAfter = notification.metrics.extentAfter;
      final scrollingDown = _scrollPosition < pixels;

      if (scrollOffset == null || scrollOffset == 0) {
        if (extentAfter == 0) {
          _onEndOfPage();
        }
        if (extentBefore == 0) {
          _onStartOfPage();
        }
      } else {
        if (scrollingDown) {
          if (extentAfter <= scrollOffset) {
            _onEndOfPage();
          }
        } else {
          if (extentBefore <= scrollOffset) {
            _onStartOfPage();
          }
        }
      }
      _scrollPosition = pixels;
      return true;
    }
    if (notification is OverscrollNotification) {
      if (notification.overscroll > 0) {
        _onEndOfPage();
      }
      if (notification.overscroll < 0) {
        _onStartOfPage();
      }
      return true;
    }
    return false;
  }

  void _onEndOfPage() {
    if (_loadMoreStatus != null && _loadMoreStatus == _LoadingStatus.STABLE) {
      _loadMoreStatus = _LoadingStatus.LOADING;
      if (widget.onEndOfPage != null) {
        widget.onEndOfPage().whenComplete(() {
          _loadMoreStatus = _LoadingStatus.STABLE;
        });
      }
    }
  }

  void _onStartOfPage() {
    if (_loadMoreStatus != null && _loadMoreStatus == _LoadingStatus.STABLE) {
      _loadMoreStatus = _LoadingStatus.LOADING;
      if (widget.onStartOfPage != null) {
        widget.onStartOfPage().whenComplete(() {
          _loadMoreStatus = _LoadingStatus.STABLE;
        });
      }
    }
  }
}
