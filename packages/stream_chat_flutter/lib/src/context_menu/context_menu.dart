import 'package:flutter/material.dart';

const double _kContextMenuScreenPadding = 8;
const double _kContextMenuWidth = 222;

/// Signature for a builder function that wraps the context menu widget.
///
/// This builder can be used to customize the appearance of the menu
/// container by wrapping [child] in additional UI elements.
typedef ContextMenuBuilder = Widget Function(
  BuildContext context,
  Widget child,
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
  /// The [menuBuilder] receives the current context and a [child] widget
  /// containing all the [menuItems].
  ///
  /// Defaults to a card-style scrollable container with fixed width.
  final ContextMenuBuilder menuBuilder;

  /// Default menu container with standard styling.
  ///
  /// Wraps the menu content in a card-like [Material] with scroll support,
  /// applying max width and height constraints.
  static Widget _defaultMenuBuilder(BuildContext context, Widget child) {
    final availableHeight = MediaQuery.of(context).size.height;
    final maxHeight = availableHeight - _kContextMenuScreenPadding * 2;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: _kContextMenuWidth,
        maxWidth: _kContextMenuWidth,
        maxHeight: maxHeight,
      ),
      child: Material(
        elevation: 1,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.all(Radius.circular(7)),
        child: SingleChildScrollView(child: child),
      ),
    );
  }

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
        child: menuBuilder.call(
          context,
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: menuItems,
          ),
        ),
      ),
    );
  }
}
