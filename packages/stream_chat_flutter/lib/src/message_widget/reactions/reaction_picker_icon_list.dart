import 'package:collection/collection.dart';
import 'package:ezanimation/ezanimation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/reaction_icon.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template onReactionPressed}
/// Callback called when a reaction icon is pressed.
/// {@endtemplate}
typedef OnReactionPicked = void Function(Reaction reaction);

/// {@template reactionPickerIconList}
/// A widget that displays a list of reactionIcons that can be picked by a user.
///
/// This widget shows a row of reaction icons with animated entry. When a user
/// taps on a reaction icon, the [onReactionPicked] callback is invoked with the
/// selected reaction.
///
/// The reactions displayed are configured via [reactionIcons] and the widget
/// tracks which reactions the current user has already added to the [message].
/// {@endtemplate}
class ReactionPickerIconList extends StatefulWidget {
  /// {@macro reactionPickerIconList}
  const ReactionPickerIconList({
    super.key,
    required this.message,
    required this.reactionIcons,
    this.onReactionPicked,
  });

  /// The message to display reactions for.
  final Message message;

  /// The list of available reaction icons.
  final List<StreamReactionIcon> reactionIcons;

  /// {@macro onReactionPressed}
  final OnReactionPicked? onReactionPicked;

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
          bool reactionCheck(Reaction reaction) => reaction.type == icon.type;

          final ownReactions = [...?widget.message.ownReactions];
          final reaction = ownReactions.firstWhereOrNull(reactionCheck);

          final animation = _iconAnimations[index];
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Transform.scale(
              scale: animation.value,
              child: child,
            ),
            child: ReactionIconButton(
              icon: icon,
              // If the reaction is present, it is selected.
              isSelected: reaction != null,
              onPressed: switch (widget.onReactionPicked) {
                final onPicked? => () {
                    final type = icon.type;
                    final pickedReaction = reaction ?? Reaction(type: type);
                    return onPicked(pickedReaction);
                  },
                _ => null,
              },
            ),
          );
        }),
      ],
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeInOutBack,
      duration: const Duration(milliseconds: 500),
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: child,
    );
  }
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
    required this.isSelected,
    this.onPressed,
  });

  /// Whether this reaction is currently selected by the user.
  final bool isSelected;

  /// The reaction icon to display.
  final StreamReactionIcon icon;

  /// Callback triggered when the reaction icon is pressed.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 24,
      icon: icon.builder(context, isSelected, 24),
      padding: const EdgeInsets.all(4),
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size.square(24),
      ),
      onPressed: onPressed,
    );
  }
}
