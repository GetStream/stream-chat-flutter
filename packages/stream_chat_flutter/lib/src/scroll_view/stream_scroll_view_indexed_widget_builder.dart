import 'package:flutter/material.dart';

/// Signature for a function that creates a widget for a given index, e.g., in a
/// list, grid.
///
/// Used by [StreamChannelListView], [StreamMessageSearchListView]
/// and [StreamUserListView].
typedef StreamScrollViewIndexedWidgetBuilder<ItemType,
        WidgetType extends Widget>
    = Widget Function(
  BuildContext context,
  List<ItemType> items,
  int index,
  WidgetType defaultWidget,
);
