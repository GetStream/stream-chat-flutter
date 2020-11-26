import 'package:flutter/widgets.dart';

enum LoadingStatus { LOADING, STABLE }

/// Signature for EndOfPageListeners
typedef EndOfPageListenerCallback = void Function();

/// A widget that wraps a [Widget] and will trigger [onEndOfPage] when it
/// reaches the bottom of the list
class LazyLoadScrollView extends StatefulWidget {
  /// The [Widget] that this widget watches for changes on
  final Widget child;

  /// Called when the [child] reaches the end of the list
  final EndOfPageListenerCallback onEndOfPage;

  /// The offset to take into account when triggering [onEndOfPage] in pixels
  final int scrollOffset;

  /// Used to determine if loading of new data has finished. You should use set this if you aren't using a FutureBuilder or StreamBuilder
  final bool isLoading;

  LazyLoadScrollView({
    Key key,
    @required this.child,
    @required this.onEndOfPage,
    this.isLoading = false,
    this.scrollOffset = 100,
  })  : assert(onEndOfPage != null),
        assert(child != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _LazyLoadScrollViewState();
}

class _LazyLoadScrollViewState extends State<LazyLoadScrollView> {
  LoadingStatus _loadMoreStatus = LoadingStatus.STABLE;

  @override
  void didUpdateWidget(LazyLoadScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isLoading) {
      _loadMoreStatus = LoadingStatus.STABLE;
    }
  }

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
            _loadMoreStatus == LoadingStatus.STABLE) {
          _loadMoreStatus = LoadingStatus.LOADING;
          widget.onEndOfPage();
        }
      }
      return true;
    }
    if (notification is OverscrollNotification) {
      if (notification.overscroll > 0) {
        if (_loadMoreStatus != null &&
            _loadMoreStatus == LoadingStatus.STABLE) {
          _loadMoreStatus = LoadingStatus.LOADING;
          widget.onEndOfPage();
        }
      }
      return true;
    }
    return false;
  }
}
