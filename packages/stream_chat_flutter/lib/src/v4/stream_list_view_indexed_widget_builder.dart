import 'package:flutter/material.dart';

/// TODO: Document me!
typedef StreamListViewIndexedWidgetBuilder<ItemType, WidgetType extends Widget>
    = Widget Function(
  BuildContext context,
  List<ItemType> items,
  int index,
  WidgetType defaultWidget,
);
