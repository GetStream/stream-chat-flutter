import 'package:collection/collection.dart';
import 'package:ezanimation/ezanimation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/reaction_icon.dart';

/// {@template onReactionIconPicked}
/// Callback called when a reaction icon is pressed.
/// {@endtemplate}
typedef OnReactionIconPicked = ValueSetter<ReactionPickerIcon>;

/// {@template onReactionPickerIconPressed}
/// Callback called when a reaction picker icon is pressed.
/// {@endtemplate}
typedef OnReactionPickerIconPressed = ValueSetter<String>;

/// {@template reactionPickerIconBuilder}
/// Function signature for building a custom reaction icon widget.
///
/// This is used to customize how each reaction icon is displayed in the
/// [ReactionPickerIconList].
///
/// Parameters:
/// - [context]: The build context.
/// - [icon]: The reaction icon data containing type and selection state.
/// - [onPressed]: Callback when the reaction icon is pressed.
/// {@endtemplate}
typedef ReactionPickerIconBuilder = Widget Function(
  BuildContext context,
  ReactionPickerIcon icon,
  VoidCallback? onPressed,
);

/// {@template reactionPickerIconList}
/// A widget that displays a list of reactionIcons that can be picked by a user.
///
/// This widget shows a row of reaction icons with animated entry. When a user
/// taps on a reaction icon, the [onIconPicked] callback is invoked with the
/// selected reaction.
///
/// The reactions displayed are configured via [reactionIcons].
///
/// See also:
/// - [StreamReactionPicker], which is a higher-level widget that uses this
///   widget to display a reaction picker in a modal or inline.
/// {@endtemplate}
class ReactionPickerIconList extends StatefulWidget {
  /// {@macro reactionPickerIconList}
  const ReactionPickerIconList({
    super.key,
    this.onIconPicked,
    required this.reactionIcons,
    ReactionPickerIconBuilder? iconBuilder,
  }) : iconBuilder = iconBuilder ?? _defaultIconBuilder;

  /// The list of available reaction picker icons.
  final List<ReactionPickerIcon> reactionIcons;

  /// The builder used to create the reaction picker icons.
  final ReactionPickerIconBuilder iconBuilder;

  /// {@macro onReactionIconPicked}
  final OnReactionIconPicked? onIconPicked;

  static Widget _defaultIconBuilder(
    BuildContext context,
    ReactionPickerIcon icon,
    VoidCallback? onPressed,
  ) {
    return ReactionIconButton(
      icon: icon,
      onPressed: onPressed,
    );
  }

  @override
  State<ReactionPickerIconList> createState() => _ReactionPickerIconListState();
}

class _ReactionPickerIconListState extends State<ReactionPickerIconList> {
  List<EzAnimation> _iconAnimations = [];

  void _triggerAnimations() async {
    for (final animation in _iconAnimations) {
      if (mounted) animation.start();
      // Add a small delay between the start of each animation.
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void _dismissAnimations() {
    for (final animation in _iconAnimations) {
      animation.stop();
    }
  }

  void _disposeAnimations() {
    for (final animation in _iconAnimations) {
      animation.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    _iconAnimations = List.generate(
      widget.reactionIcons.length,
      (index) => EzAnimation.tween(
        Tween(begin: 0.0, end: 1.0),
        kThemeAnimationDuration,
        curve: Curves.easeInOutBack,
      ),
    );

    // Trigger animations at the end of the frame to avoid jank.
    WidgetsBinding.instance.endOfFrame.then((_) => _triggerAnimations());
  }

  @override
  void didUpdateWidget(covariant ReactionPickerIconList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reactionIcons.length != widget.reactionIcons.length) {
      // Dismiss and dispose old animations.
      _dismissAnimations();
      _disposeAnimations();

      // Initialize new animations.
      _iconAnimations = List.generate(
        widget.reactionIcons.length,
        (index) => EzAnimation.tween(
          Tween(begin: 0.0, end: 1.0),
          kThemeAnimationDuration,
          curve: Curves.easeInOutBack,
        ),
      );

      // Trigger animations at the end of the frame to avoid jank.
      WidgetsBinding.instance.endOfFrame.then((_) => _triggerAnimations());
    }
  }

  @override
  void dispose() {
    _dismissAnimations();
    _disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = Wrap(
      spacing: 4,
      runSpacing: 4,
      runAlignment: WrapAlignment.center,
      alignment: WrapAlignment.spaceAround,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...widget.reactionIcons.mapIndexed((index, icon) {
          final animation = _iconAnimations[index];
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Transform.scale(
              scale: animation.value,
              child: child,
            ),
            child: Builder(
              builder: (context) {
                final icon = widget.reactionIcons[index];
                final onPressed = switch (widget.onIconPicked) {
                  final onPicked? => () => onPicked(icon),
                  _ => null,
                };

                return widget.iconBuilder(context, icon, onPressed);
              },
            ),
          );
        }),
      ],
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutBack,
      duration: const Duration(milliseconds: 335),
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: child,
    );
  }
}

/// {@template reactionPickerIcon}
/// A data class that represents a reaction icon within the reaction picker.
///
/// This class holds information about a specific reaction, such as its type,
/// whether it's currently selected by the user, and a builder function
/// to construct its visual representation.
/// {@endtemplate}
class ReactionPickerIcon {
  /// {@macro reactionPickerIcon}
  const ReactionPickerIcon({
    required this.type,
    this.isSelected = false,
    this.iconSize = 24,
    required ReactionIconBuilder builder,
  }) : _builder = builder;

  /// The unique identifier for the reaction type (e.g., "like", "love").
  final String type;

  /// A boolean indicating whether this reaction is currently selected by the
  /// user.
  final bool isSelected;

  /// The size of the reaction icon.
  final double iconSize;

  /// Builds the actual widget for this reaction icon using the provided
  /// [context], selection state, and icon size.
  Widget build(BuildContext context) => _builder(context, isSelected, iconSize);
  final ReactionIconBuilder _builder;
}

/// {@template reactionIconButton}
/// A button that displays a reaction icon.
///
/// This button is used in the reaction picker to display individual reaction
/// options.
/// {@endtemplate}
class ReactionIconButton extends StatelessWidget {
  /// {@macro reactionIconButton}
  const ReactionIconButton({
    super.key,
    required this.icon,
    this.onPressed,
  });

  /// The reaction icon to display.
  final ReactionPickerIcon icon;

  /// Callback triggered when the reaction picker icon is pressed.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: Key(icon.type),
      iconSize: icon.iconSize,
      onPressed: onPressed,
      icon: icon.build(context),
      padding: const EdgeInsets.all(4),
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.square(icon.iconSize),
      ),
    );
  }
}
