import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

const double _kContextMenuScreenPadding = 8;

/// Signature for a builder function that wraps the context menu items.
///
/// This builder can be used to customize the appearance of the menu
/// container by wrapping [menuItems] in additional UI elements.
typedef ContextMenuContainerBuilder =
    Widget Function(
      BuildContext context,
      List<Widget> menuItems,
    );

/// A widget that displays a context menu anchored to a specific [Offset].
///
/// The menu will try to position itself as close to the [anchor] as possible,
/// while respecting screen padding and safe areas.
class ContextMenu extends StatelessWidget {
  /// Creates a [ContextMenu].
  ///
  /// The [anchor] defines where the menu is shown, and [menuItems] are the
  /// widgets displayed within the menu. An optional [menuBuilder] can be used
  /// to customize the menu's container.
  ///
  /// The [menuItems] list must not be empty.
  const ContextMenu({
    super.key,
    required this.anchor,
    required this.menuItems,
    this.menuBuilder = _defaultMenuBuilder,
  }) : assert(menuItems.length > 0, 'Context menu must have at least one item');

  /// The target position on screen where the context menu should appear.
  final Offset anchor;

  /// The list of menu items to display inside the menu.
  ///
  /// These can be [ListTile] widgets, buttons, or any other widget.
  final List<Widget> menuItems;

  /// Builds the outer container for the menu.
  ///
  /// The [menuBuilder] receives the current context and the [menuItems] list,
  /// and should return a widget wrapping all items.
  ///
  /// Defaults to a [StreamContextMenu] wrapping all items.
  final ContextMenuContainerBuilder menuBuilder;

  /// Default menu container with standard styling.
  ///
  /// Wraps the menu content in a card-like [Material] with scroll support,
  /// applying max width and height constraints.
  static Widget _defaultMenuBuilder(
    BuildContext context,
    List<Widget> menuItems,
  ) => StreamContextMenu(children: menuItems);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context), '');

    final safePadding = MediaQuery.paddingOf(context);
    final paddingAbove = safePadding.top + _kContextMenuScreenPadding;
    final localAdjustment = Offset(_kContextMenuScreenPadding, paddingAbove);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        _kContextMenuScreenPadding,
        paddingAbove,
        _kContextMenuScreenPadding,
        _kContextMenuScreenPadding,
      ),
      child: CustomSingleChildLayout(
        delegate: DesktopTextSelectionToolbarLayoutDelegate(
          anchor: anchor - localAdjustment,
        ),
        child: menuBuilder.call(context, menuItems),
      ),
    );
  }
}
