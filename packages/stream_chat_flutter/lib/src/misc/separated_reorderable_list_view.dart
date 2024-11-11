// ignore_for_file: use_is_even_rather_than_modulo
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// {@template streamSeparatedReorderableListView}
/// A custom implementation of [ReorderableListView] that supports separators.
/// {@endtemplate}
class SeparatedReorderableListView extends ReorderableListView {
  /// {@macro streamSeparatedReorderableListView}
  SeparatedReorderableListView({
    super.key,
    required IndexedWidgetBuilder itemBuilder,
    required IndexedWidgetBuilder separatorBuilder,
    required int itemCount,
    required ReorderCallback onReorder,
    super.itemExtent,
    super.prototypeItem,
    super.proxyDecorator,
    super.padding,
    super.header,
    super.scrollDirection,
    super.reverse,
    super.scrollController,
    super.primary,
    super.physics,
    super.shrinkWrap,
    super.anchor,
    super.cacheExtent,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
  }) : super.builder(
          buildDefaultDragHandles: false,
          itemCount: math.max(0, itemCount * 2 - 1),
          itemBuilder: (BuildContext context, int index) {
            final itemIndex = index ~/ 2;
            if (index.isEven) {
              final listItem = itemBuilder(context, itemIndex);
              return ReorderableDelayedDragStartListener(
                key: listItem.key,
                index: index,
                child: listItem,
              );
            }

            final separator = separatorBuilder(context, itemIndex);
            if (separator.key == null) {
              return KeyedSubtree(
                key: ValueKey('reorderable_separator_$itemIndex'),
                child: IgnorePointer(child: separator),
              );
            }

            return separator;
          },
          onReorder: (int oldIndex, int newIndex) {
            // Adjust the indexes due to an issue in the ReorderableListView
            // which isn't going to be fixed in the near future.
            //
            // issue: https://github.com/flutter/flutter/issues/24786
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }

            // Ideally should never happen as separators are wrapped in the
            // IgnorePointer widget. This is just a safety check.
            if (oldIndex % 2 == 1) return;

            // The item moved behind the top/bottom separator we should not
            // reorder it.
            if ((oldIndex - newIndex).abs() == 1) return;

            // Calculate the updated indexes
            final updatedOldIndex = oldIndex ~/ 2;
            final updatedNewIndex = oldIndex > newIndex && newIndex % 2 == 1
                ? (newIndex + 1) ~/ 2
                : newIndex ~/ 2;

            onReorder(updatedOldIndex, updatedNewIndex);
          },
        );
}
