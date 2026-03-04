import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

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
typedef ReactionPickerBuilder =
    Widget Function(
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
/// The reaction picker can be configured with custom reaction types, padding,
/// border radius, and can be made scrollable or static depending on the
/// specific needs.
/// {@endtemplate}
class StreamReactionPicker extends StatelessWidget {
  /// {@macro streamReactionPicker}
  const StreamReactionPicker({
    super.key,
    this.onReactionPicked,
    required this.message,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
  });

  /// Creates a [StreamReactionPicker] using the default reaction types
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
    final platform = Theme.of(context).platform;
    return switch (platform) {
      TargetPlatform.iOS || TargetPlatform.android => StreamReactionPicker(
        message: message,
        onReactionPicked: onReactionPicked,
      ),
      _ => StreamReactionPicker(
        message: message,
        borderRadius: BorderRadius.zero,
        onReactionPicked: onReactionPicked,
      ),
    };
  }

  /// Message to attach the reaction to.
  final Message message;

  /// {@macro onReactionPressed}
  final OnReactionPicked? onReactionPicked;

  /// Background color for the reaction picker.
  final Color? backgroundColor;

  /// Padding around the reaction picker.
  ///
  /// Defaults to `EdgeInsets.all(4)`.
  final EdgeInsetsGeometry? padding;

  /// Border radius for the reaction picker.
  ///
  /// Defaults to a circular border with a radius of 24.
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final radius = context.streamRadius;
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;

    final effectivePadding = padding ?? EdgeInsetsDirectional.only(start: spacing.xxs);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.all(radius.xxxxl);
    final effectiveBackgroundColor = backgroundColor ?? colorScheme.backgroundElevation2;

    final side = BorderSide(color: colorScheme.borderDefault);
    final shape = RoundedSuperellipseBorder(borderRadius: effectiveBorderRadius, side: side);

    final config = StreamChatConfiguration.of(context);
    final resolver = config.reactionIconResolver;
    final reactionTypes = resolver.defaultReactions;

    final ownReactions = [...?message.ownReactions];
    final ownReactionsMap = {for (final it in ownReactions) it.type: it};

    final reactionButtons = reactionTypes.map(
      (type) => StreamEmojiButton(
        key: Key(type),
        size: .lg,
        emoji: resolver.resolve(context, type),
        // If the reaction is present in ownReactions, it is selected.
        isSelected: ownReactionsMap[type] != null,
        onPressed: () {
          final reactionEmojiCode = resolver.emojiCode(type);
          final pickedReaction = switch (ownReactionsMap[type]) {
            final reaction? => reaction,
            _ => Reaction(type: type, emojiCode: reactionEmojiCode),
          };

          return onReactionPicked?.call(pickedReaction);
        },
      ),
    );

    final pickerContent = Row(
      mainAxisSize: .min,
      spacing: spacing.none,
      children: [
        // TODO: Re-enable staggered animation when MessageWidget redesign is finalized.
        ...reactionButtons,
        StreamButton.icon(
          key: const Key('add_reaction'),
          size: .small,
          type: .outline,
          style: .secondary,
          icon: icons.plusLarge,
          onTap: () async {
            final selectedReactions = ownReactionsMap.keys.toSet();
            final emoji = await StreamEmojiPickerSheet.show(
              context: context,
              selectedReactions: selectedReactions,
            );

            if (!context.mounted || emoji == null) return;

            final reaction = Reaction(type: emoji.shortName, emojiCode: emoji.emoji);
            return onReactionPicked?.call(reaction);
          },
        ),
      ],
    );

    return Material(
      shape: shape,
      elevation: 3,
      clipBehavior: .antiAlias,
      color: effectiveBackgroundColor,
      child: SingleChildScrollView(
        padding: effectivePadding,
        scrollDirection: .horizontal,
        child: pickerContent,
      ),
    );
  }
}
