import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// Tracks the offset of the drag gesture
class GestureStateProvider extends InheritedWidget {
  /// Creates a new OffsetTracker
  const GestureStateProvider({
    super.key,
    required super.child,
    required this.state,
  });

  /// The drag gestures' state information
  final GestureState state;

  /// Returns the state of the drag gesture
  static GestureState? maybeOf(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<GestureStateProvider>();
    return provider?.state;
  }

  @override
  bool updateShouldNotify(GestureStateProvider oldWidget) {
    return oldWidget.state != state;
  }
}

/// Tracks any state that needs to be communicated between the audio recording
/// components
class GestureState extends Equatable {
  /// Creates a new GestureState
  const GestureState({
    required this.offset,
  });

  /// The offset of the drag gesture
  final Offset offset;

  @override
  List<Object?> get props => [offset];
}
