import 'package:flutter/material.dart';

typedef StreamListViewIndexedWidgetBuilder<ItemType, WidgetType extends Widget>
    = Widget Function(
  BuildContext context,
  List<ItemType> items,
  int index,
  WidgetType defaultWidget,
);
