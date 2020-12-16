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

  /// The offset to take into account when triggering [onEndOfPage] in pixels
  final double scrollOffset;

  /// Used to determine if loading of new data has finished. You should use set this if you aren't using a FutureBuilder or StreamBuilder
  final bool isLoading;

  /// Initiates a LazyLoadScrollView widget
  LazyLoadScrollView({
    Key key,
    @required this.child,
    this.onStartOfPage,
    this.onEndOfPage,
    this.isLoading = false,
    this.scrollOffset = 100,
  })  : assert(child != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _LazyLoadScrollViewState();
}

class _LazyLoadScrollViewState extends State<LazyLoadScrollView> {
  _LoadingStatus _loadMoreStatus = _LoadingStatus.STABLE;

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      child: widget.child,
      onNotification: _onNotification,
    );
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.maxScrollExtent > notification.metrics.pixels &&
          notification.metrics.maxScrollExtent - notification.metrics.pixels <=
              widget.scrollOffset) {
        if (_loadMoreStatus != null &&
            _loadMoreStatus == _LoadingStatus.STABLE) {
          _loadMoreStatus = _LoadingStatus.LOADING;
          if (widget.onEndOfPage != null) {
            widget.onEndOfPage().whenComplete(() {
              _loadMoreStatus = _LoadingStatus.STABLE;
            });
          }
        }
      }
      if (notification.metrics.minScrollExtent < notification.metrics.pixels &&
          notification.metrics.pixels - notification.metrics.minScrollExtent <=
              widget.scrollOffset) {
        if (_loadMoreStatus != null &&
            _loadMoreStatus == _LoadingStatus.STABLE) {
          _loadMoreStatus = _LoadingStatus.LOADING;
          if (widget.onStartOfPage != null) {
            widget.onStartOfPage().whenComplete(() {
              _loadMoreStatus = _LoadingStatus.STABLE;
            });
          }
        }
      }
      return true;
    }
    if (notification is OverscrollNotification) {
      if (notification.overscroll > 0) {
        if (_loadMoreStatus != null &&
            _loadMoreStatus == _LoadingStatus.STABLE) {
          _loadMoreStatus = _LoadingStatus.LOADING;
          if (widget.onEndOfPage != null) {
            widget.onEndOfPage().whenComplete(() {
              _loadMoreStatus = _LoadingStatus.STABLE;
            });
          }
        }
      }
      if (notification.overscroll < 0) {
        if (_loadMoreStatus != null &&
            _loadMoreStatus == _LoadingStatus.STABLE) {
          _loadMoreStatus = _LoadingStatus.LOADING;
          if (widget.onStartOfPage != null) {
            widget.onStartOfPage().whenComplete(() {
              _loadMoreStatus = _LoadingStatus.STABLE;
            });
          }
        }
      }
      return true;
    }
    return false;
  }
}
