import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/stream_chat_component_builders.dart';
import 'package:stream_chat_flutter/src/stream_chat_configuration.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
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
///
/// See also:
///
///  * [StreamReactionPickerProps], which configures this widget.
///  * [DefaultStreamReactionPicker], the default implementation.
/// {@endtemplate}
class StreamReactionPicker extends StatelessWidget {
  /// {@macro streamReactionPicker}
  StreamReactionPicker({
    super.key,
    required Message message,
    OnReactionPicked? onReactionPicked,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
  }) : props = StreamReactionPickerProps(
         message: message,
         onReactionPicked: onReactionPicked,
         backgroundColor: backgroundColor,
         padding: padding,
         borderRadius: borderRadius,
       );

  /// The properties that configure this reaction picker.
  final StreamReactionPickerProps props;

  /// Creates a [StreamReactionPicker] with platform-appropriate defaults.
  ///
  /// On iOS/Android the picker uses rounded corners; on desktop/web the
  /// border radius is set to zero.
  static Widget builder(
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

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamReactionPickerProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamReactionPicker(props: props);
  }
}

/// Properties for configuring a [StreamReactionPicker].
///
/// See also:
///
///  * [StreamReactionPicker], which uses these properties.
///  * [DefaultStreamReactionPicker], the default implementation.
@immutable
class StreamReactionPickerProps {
  /// Creates properties for a reaction picker.
  const StreamReactionPickerProps({
    required this.message,
    this.onReactionPicked,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
  });

  /// The message to attach the reaction to.
  final Message message;

  /// {@macro onReactionPicked}
  final OnReactionPicked? onReactionPicked;

  /// Background color for the reaction picker.
  final Color? backgroundColor;

  /// Padding around the reaction picker.
  ///
  /// When null, defaults to `EdgeInsetsDirectional.only(start: spacing.xxs)`.
  final EdgeInsetsGeometry? padding;

  /// Border radius for the reaction picker.
  ///
  /// When null, defaults to a circular border with radius `xxxxl`.
  final BorderRadiusGeometry? borderRadius;
}

/// The default implementation of [StreamReactionPicker].
///
/// Resolves [StreamReactionPickerProps] into a horizontal row of reaction
/// emoji buttons plus an "add reaction" button that opens the emoji picker
/// sheet.
///
/// See also:
///
///  * [StreamReactionPicker], the public API widget.
///  * [StreamReactionPickerProps], which configures this widget.
class DefaultStreamReactionPicker extends StatelessWidget {
  /// Creates a default reaction picker with the given [props].
  const DefaultStreamReactionPicker({super.key, required this.props});

  /// The properties that configure this widget.
  final StreamReactionPickerProps props;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final radius = context.streamRadius;
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;

    final effectivePadding = props.padding ?? EdgeInsetsDirectional.only(start: spacing.xxs);
    final effectiveBorderRadius = props.borderRadius ?? BorderRadius.all(radius.xxxxl);
    final effectiveBackgroundColor = props.backgroundColor ?? colorScheme.backgroundElevation2;

    final side = BorderSide(color: colorScheme.borderDefault);
    final shape = RoundedSuperellipseBorder(borderRadius: effectiveBorderRadius, side: side);

    final config = StreamChatConfiguration.of(context);
    final resolver = config.reactionIconResolver;
    final reactionTypes = resolver.defaultReactions;

    final message = props.message;
    final onReactionPicked = props.onReactionPicked;

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
