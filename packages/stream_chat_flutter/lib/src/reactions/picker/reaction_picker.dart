import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template onReactionPicked}
/// Callback called when a reaction is picked.
/// {@endtemplate}
typedef OnReactionPicked = ValueSetter<Reaction>;

/// {@template reactionPickerBuilder}
/// Function signature for building a custom reaction picker widget.
///
/// Use this to provide a custom reaction picker in [StreamMessageActionsModal]
/// or [StreamMessageReactionsModal].
///
/// Parameters:
/// - [context]: The build context.
/// - [message]: The message to show reactions for.
/// - [onReactionPicked]: Callback when a reaction is picked.
/// {@endtemplate}
typedef ReactionPickerBuilder = Widget Function(
  BuildContext context,
  Message message,
  OnReactionPicked? onReactionPicked,
);

/// {@template streamReactionPicker}
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/reaction_picker.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/reaction_picker_paint.png)
///
/// A widget that displays a horizontal list of reaction icons that users can
/// select to react to a message.
///
/// The reaction picker can be configured with custom reaction icons, padding,
/// border radius, and can be made scrollable or static depending on the
/// specific needs.
/// {@endtemplate}
class StreamReactionPicker extends StatelessWidget {
  /// {@macro streamReactionPicker}
  const StreamReactionPicker({
    super.key,
    this.onReactionPicked,
    required this.message,
    required this.reactionIcons,
    this.reactionIconBuilder,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(4),
    this.scrollable = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
  });

  /// Creates a [StreamReactionPicker] using the default reaction icons
  /// provided by the [StreamChatConfiguration].
  ///
  /// This is the recommended way to create a reaction picker
  /// as it ensures that the icons are consistent with the rest of the app.
  ///
  /// The [onReactionPicked] callback is optional and can be used to handle
  /// the reaction selection.
  factory StreamReactionPicker.builder(
    BuildContext context,
    Message message,
    OnReactionPicked? onReactionPicked,
  ) {
    final config = StreamChatConfiguration.of(context);
    final reactionIcons = config.reactionIcons;

    final platform = Theme.of(context).platform;
    return switch (platform) {
      TargetPlatform.iOS || TargetPlatform.android => StreamReactionPicker(
          message: message,
          reactionIcons: reactionIcons,
          onReactionPicked: onReactionPicked,
        ),
      _ => StreamReactionPicker(
          message: message,
          scrollable: false,
          borderRadius: BorderRadius.zero,
          reactionIcons: reactionIcons,
          onReactionPicked: onReactionPicked,
        ),
    };
  }

  /// Message to attach the reaction to.
  final Message message;

  /// List of reaction icons to display.
  final List<StreamReactionIcon> reactionIcons;

  /// {@macro onReactionPressed}
  final OnReactionPicked? onReactionPicked;

  /// Optional custom builder for reaction picker icons.
  final ReactionPickerIconBuilder? reactionIconBuilder;

  /// Background color for the reaction picker.
  final Color? backgroundColor;

  /// Padding around the reaction picker.
  ///
  /// Defaults to `EdgeInsets.all(4)`.
  final EdgeInsets padding;

  /// Whether the reaction picker should be scrollable.
  ///
  /// Defaults to `true`.
  final bool scrollable;

  /// Border radius for the reaction picker.
  ///
  /// Defaults to a circular border with a radius of 24.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    final ownReactions = [...?message.ownReactions];
    final ownReactionsMap = {for (final it in ownReactions) it.type: it};

    final indicatorIcons = reactionIcons.map(
      (reactionIcon) {
        final reactionType = reactionIcon.type;

        return ReactionPickerIcon(
          type: reactionType,
          builder: reactionIcon.builder,
          // If the reaction is present in ownReactions, it is selected.
          isSelected: ownReactionsMap[reactionType] != null,
        );
      },
    );

    final reactionPicker = ReactionPickerIconList(
      iconBuilder: reactionIconBuilder,
      reactionIcons: [...indicatorIcons],
      onIconPicked: (reactionIcon) {
        final reactionType = reactionIcon.type;
        final reaction = ownReactionsMap[reactionType];

        return onReactionPicked?.call(reaction ?? Reaction(type: reactionType));
      },
    );

    final isSinglePickerIcon = reactionIcons.length == 1;
    final extraPadding = switch (isSinglePickerIcon) {
      true => EdgeInsets.zero,
      false => const EdgeInsets.symmetric(horizontal: 4),
    };

    return Material(
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      color: backgroundColor ?? theme.colorTheme.barsBg,
      child: Padding(
        padding: padding.add(extraPadding),
        child: switch (scrollable) {
          false => reactionPicker,
          true => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: reactionPicker,
            ),
        },
      ),
    );
  }
}
