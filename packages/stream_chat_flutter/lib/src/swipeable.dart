import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget to make a swipeable tile
class Swipeable extends StatefulWidget {
  /// Constructor for creating a [Swipeable] widget
  const Swipeable({
    Key? key,
    required this.child,
    required this.backgroundIcon,
    this.onSwipeStart,
    this.onSwipeCancel,
    this.onSwipeEnd,
    this.threshold = 82.0,
  }) : super(key: key);

  /// Child to make swipeable
  final Widget child;

  /// Background icon after swipe
  final Widget backgroundIcon;

  /// Callback when swipe starts
  final VoidCallback? onSwipeStart;

  /// Callback when swipe is cancelled
  final VoidCallback? onSwipeCancel;

  /// Callback when swipe ends
  final VoidCallback? onSwipeEnd;

  /// Threshold for swipe
  final double threshold;

  @override
  State<StatefulWidget> createState() => _SwipeableState();
}

class _SwipeableState extends State<Swipeable> with TickerProviderStateMixin {
  double _dragExtent = 0;
  late AnimationController _moveController;
  late AnimationController _iconMoveController;
  late Animation<Offset> _moveAnimation;
  late Animation<Offset> _iconTransitionAnimation;
  late Animation<double> _iconFadeAnimation;
  bool _pastThreshold = false;

  final _animationDuration = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _moveController =
        AnimationController(duration: _animationDuration, vsync: this);
    _iconMoveController =
        AnimationController(duration: _animationDuration, vsync: this);
    _moveAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(1, 0))
        .animate(_moveController);
    _iconTransitionAnimation =
        Tween<Offset>(begin: const Offset(-0.1, 0), end: const Offset(0.4, 0))
            .animate(_moveController);
    _iconFadeAnimation =
        Tween<double>(begin: 0.7, end: 1).animate(_iconMoveController);

    const controllerValue = 0.0;
    _moveController.animateTo(controllerValue);
    _iconMoveController.animateTo(controllerValue);
  }

  @override
  void dispose() {
    _moveController.dispose();
    _iconMoveController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    if (widget.onSwipeStart != null) {
      widget.onSwipeStart!();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta!;
    _dragExtent += delta;

    if (_dragExtent.isNegative) return;

    final movePastThresholdPixels = widget.threshold;
    var newPos = _dragExtent.abs() / context.size!.width;

    if (_dragExtent.abs() > movePastThresholdPixels) {
      // how many "thresholds" past the threshold we are. 1 = the threshold 2
      // = two thresholds.
      final n = _dragExtent.abs() / movePastThresholdPixels;

      // Take the number of thresholds past the threshold, and reduce this
      // number
      final reducedThreshold = math.pow(n, 0.3);

      final adjustedPixelPos = movePastThresholdPixels * reducedThreshold;
      newPos = adjustedPixelPos / context.size!.width;

      if (_dragExtent > 0 && !_pastThreshold) {
        _iconMoveController.value = 1;
        _pastThreshold = true;
      }
    } else {
      // Send a cancel event if the user has swiped back underneath the
      // threshold
      if (_pastThreshold && widget.onSwipeCancel != null) {
        widget.onSwipeCancel!();
      }
      _pastThreshold = false;
    }
    if (!_pastThreshold || newPos < _moveController.value) {
      _iconMoveController.value = newPos;
    }
    _moveController.value = newPos;
  }

  void _handleDragEnd(DragEndDetails details) {
    _moveController.animateTo(0, duration: _animationDuration);
    _iconMoveController.animateTo(0, duration: _animationDuration);
    _dragExtent = 0.0;
    if (_pastThreshold && widget.onSwipeEnd != null) {
      widget.onSwipeEnd!();
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onHorizontalDragStart: _handleDragStart,
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.passthrough,
          children: [
            SlideTransition(
              position: _iconTransitionAnimation,
              child: Row(
                children: [
                  FadeTransition(
                    opacity: _iconFadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              StreamChatTheme.of(context).colorTheme.disabled,
                        ),
                      ),
                      child: widget.backgroundIcon,
                    ),
                  ),
                ],
              ),
            ),
            SlideTransition(
              position: _moveAnimation,
              child: widget.child,
            ),
          ],
        ),
      );
}
