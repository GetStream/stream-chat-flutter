import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A widget that calls the callback when the layout dimensions of
/// its child change.
class SizeChangeListener extends SingleChildRenderObjectWidget {
  /// Creates a new instance of [SizeChangeListener].
  const SizeChangeListener({
    super.key,
    required this.onSizeChanged,
    super.child,
  });

  /// The action to perform when the size of child widget changes.
  final ValueChanged<Size> onSizeChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSizeChangedWithCallback(onSizeChanged: onSizeChanged);
  }
}

class _RenderSizeChangedWithCallback extends RenderProxyBox {
  _RenderSizeChangedWithCallback({
    required this.onSizeChanged,
  });

  final ValueChanged<Size> onSizeChanged;
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _oldSize) {
      _oldSize = size;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Call the callback with the new size
        onSizeChanged.call(size);
      });
    }
  }
}
