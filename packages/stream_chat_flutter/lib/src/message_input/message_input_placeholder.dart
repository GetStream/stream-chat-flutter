import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Sealed hierarchy describing why a particular placeholder is shown in
/// [StreamMessageComposer].
///
/// The state is resolved once per rebuild from the current
/// [StreamMessageComposerController] using [MessageInputPlaceholder.resolve],
/// then handed to a [MessageInputPlaceholderBuilder] to produce the actual
/// placeholder string that gets passed down to the underlying
/// [StreamChatMessageInput].
///
/// Each case carries the contextual data relevant to that state — for example
/// [SlowModePlaceholder.cooldownTimeOut] for the remaining cooldown, or
/// [AttachmentsPlaceholder.attachments] for the pending attachments — so a
/// custom builder can use it to render rich, context-aware placeholders.
///
/// Use an exhaustive `switch` over the cases in your custom builder so that
/// adding a new case in a future SDK release becomes a compile error you can
/// easily fix:
///
/// ```dart
/// String? myPlaceholderBuilder(
///   BuildContext context,
///   MessageInputPlaceholder placeholder,
/// ) {
///   final translations = context.translations;
///   return switch (placeholder) {
///     SlowModePlaceholder(:final cooldownTimeOut) =>
///       translations.slowModeOnLabel(cooldownTimeOut),
///     CommandPlaceholder(command: 'giphy') => translations.searchGifLabel,
///     CommandPlaceholder(command: 'mute' || 'unmute' || 'ban' || 'unban') =>
///       translations.commandUsernameLabel,
///     CommandPlaceholder(command: 'weather') => 'Type a city name',
///     CommandPlaceholder() => translations.writeAMessageLabel,
///     AttachmentsPlaceholder() => translations.addACommentOrSendLabel,
///     WriteMessagePlaceholder() => translations.writeAMessageLabel,
///   };
/// }
/// ```
sealed class MessageInputPlaceholder {
  /// Creates a new instance of [MessageInputPlaceholder].
  const MessageInputPlaceholder();

  /// Resolves the appropriate placeholder for the current state of the
  /// [controller].
  ///
  /// Precedence (highest to lowest):
  /// 1. [SlowModePlaceholder] when the channel is in slow mode for the
  ///    current user.
  /// 2. [CommandPlaceholder] when [StreamMessageComposerController.message] has
  ///    an active command.
  /// 3. [AttachmentsPlaceholder] when there are pending attachments but no
  ///    text yet.
  /// 4. [WriteMessagePlaceholder] otherwise.
  factory MessageInputPlaceholder.resolve(
    StreamMessageComposerController controller,
  ) {
    if (controller.isSlowModeActive) {
      return SlowModePlaceholder(cooldownTimeOut: controller.cooldownTimeOut);
    }
    if (controller.message.command case final command?) {
      return CommandPlaceholder(command: command);
    }
    if (controller.attachments.isNotEmpty) {
      return AttachmentsPlaceholder(attachments: controller.attachments);
    }
    return WriteMessagePlaceholder(isEditing: controller.isEditing);
  }
}

/// Default placeholder shown when the input is idle and no other state
/// ([SlowModePlaceholder], [CommandPlaceholder], [AttachmentsPlaceholder])
/// applies.
///
/// [isEditing] is `true` when the input is editing an existing message rather
/// than composing a new one. Consumers can use this to swap the placeholder
/// text when in edit mode.
final class WriteMessagePlaceholder extends MessageInputPlaceholder {
  /// Creates a new instance of [WriteMessagePlaceholder].
  const WriteMessagePlaceholder({this.isEditing = false});

  /// Whether the input is editing an existing message.
  final bool isEditing;
}

/// Placeholder shown when the channel has slow mode active for the current
/// user.
///
/// The placeholder text typically tells the user how long they need to wait
/// before sending another message. The remaining cooldown is exposed both as
/// raw seconds via [cooldownTimeOut] and as a [Duration] via [cooldown] for
/// convenience when formatting timer strings.
final class SlowModePlaceholder extends MessageInputPlaceholder {
  /// Creates a new instance of [SlowModePlaceholder].
  const SlowModePlaceholder({required this.cooldownTimeOut});

  /// The remaining slow-mode cooldown in seconds.
  ///
  /// Mirrors [StreamMessageComposerController.cooldownTimeOut].
  final int cooldownTimeOut;

  /// The remaining slow-mode cooldown as a [Duration].
  Duration get cooldown => Duration(seconds: cooldownTimeOut);
}

/// Placeholder shown when the input has an active command.
///
/// The [command] is the command name as stored on [Message.command] (for
/// example `'mute'`, `'giphy'`, or any backend-defined command). Use this to
/// render command-specific guidance, for example `@username` for `/mute` or
/// `Search GIFs` for `/giphy`.
final class CommandPlaceholder extends MessageInputPlaceholder {
  /// Creates a new instance of [CommandPlaceholder].
  const CommandPlaceholder({required this.command});

  /// The active command name.
  final String command;
}

/// Placeholder shown when the input has pending attachments but no text yet.
///
/// The pending [attachments] are exposed so consumers can render a
/// context-aware placeholder (for example "Add a comment to your photo" when
/// the only attachment is an image).
final class AttachmentsPlaceholder extends MessageInputPlaceholder {
  /// Creates a new instance of [AttachmentsPlaceholder].
  const AttachmentsPlaceholder({required this.attachments});

  /// The pending attachments currently held by the input.
  ///
  /// OG link previews are still included here — filter them out via
  /// [Attachment.ogScrapeUrl] if you want only user-added attachments.
  final List<Attachment> attachments;
}

/// Returns the placeholder string shown inside [StreamMessageComposer]'s text
/// field.
///
/// Receives the current [MessageInputPlaceholder] state and may return a
/// localized string or `null` to show no placeholder.
typedef MessageInputPlaceholderBuilder = String? Function(BuildContext, MessageInputPlaceholder);
