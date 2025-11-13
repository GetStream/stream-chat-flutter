import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/reaction_icon.dart';

/// {@template reactionIndicatorIconBuilder}
/// Function signature for building a custom reaction icon widget.
///
/// This is used to customize how each reaction icon is displayed in the
/// [ReactionIndicatorIconList].
///
/// Parameters:
/// - [context]: The build context.
/// - [icon]: The reaction icon data containing type and selection state.
/// {@endtemplate}
typedef ReactionIndicatorIconBuilder = Widget Function(
  BuildContext context,
  ReactionIndicatorIcon icon,
);

/// {@template reactionIndicatorIconList}
/// A widget that displays a list of reactionIcons that users have reacted with
/// on a message.
///
/// See also:
/// - [StreamReactionIndicator], which is a higher-level widget that uses this
///   widget to display a reaction indicator in a modal or inline.
/// {@endtemplate}
class ReactionIndicatorIconList extends StatelessWidget {
  /// {@macro reactionIndicatorIconList}
  const ReactionIndicatorIconList({
    super.key,
    required this.indicatorIcons,
    ReactionIndicatorIconBuilder? iconBuilder,
  }) : iconBuilder = iconBuilder ?? _defaultIconBuilder;

  /// The list of available reaction indicator icons.
  final List<ReactionIndicatorIcon> indicatorIcons;

  /// The builder used to create the reaction indicator icons.
  final ReactionIndicatorIconBuilder iconBuilder;

  static Widget _defaultIconBuilder(
    BuildContext context,
    ReactionIndicatorIcon icon,
  ) {
    return icon.build(context);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      runAlignment: WrapAlignment.center,
      alignment: WrapAlignment.spaceAround,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [...indicatorIcons.map((icon) => iconBuilder(context, icon))],
    );
  }
}

/// {@template reactionIndicatorIcon}
/// A data class that represents a reaction icon within the reaction indicator.
///
/// This class holds information about a specific reaction, such as its type,
/// whether it's currently selected by the user, and a builder function
/// to construct its visual representation.
/// {@endtemplate}
class ReactionIndicatorIcon {
  /// {@macro reactionIndicatorIcon}
  const ReactionIndicatorIcon({
    required this.type,
    this.isSelected = false,
    this.iconSize = 16,
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
