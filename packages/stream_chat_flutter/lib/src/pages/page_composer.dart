import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../stream_chat_flutter.dart';
import '../localization/translations.dart';

/// The composer of a [StreamChannelPage] or [StreamThreadPage], with a
/// [StreamScheduledMessagesBanner] above it.
///
/// The banner is hidden while [controller] edits a message. Where the user can
/// schedule messages, a long press of send schedules the message, unless
/// [StreamChatConfigurationData.scheduledMessagesEnabled] is false, which also
/// hides the banner.
@internal
class PageComposer extends StatefulWidget {
  /// Creates a page composer that shows the composer [builder] builds below
  /// the banner.
  const PageComposer({
    super.key,
    required this.controller,
    required this.builder,
    this.parentId,
    this.onScheduledMessagesBannerTap,
  });

  /// The controller of the composer, whose editing hides the banner.
  final StreamMessageComposerController controller;

  /// Builds the composer shown below the banner, given what a long press of
  /// send does, or null when it does nothing.
  final Widget Function(BuildContext context, StreamMessageComposerCallback? onSendLongPress) builder;

  /// The ID of the message whose thread's scheduled replies the banner counts.
  ///
  /// When null, the banner counts the channel's scheduled messages.
  final String? parentId;

  /// Called when the banner is tapped.
  ///
  /// When null, the banner's link isn't shown.
  final VoidCallback? onScheduledMessagesBannerTap;

  @override
  State<PageComposer> createState() => _PageComposerState();
}

class _PageComposerState extends State<PageComposer> {
  Channel? _channel;
  Stream<bool>? _canSchedule;

  @override
  Widget build(BuildContext context) {
    final isEnabled = StreamChatConfiguration.of(context).scheduledMessagesEnabled;
    if (!isEnabled) return widget.builder(context, null);

    final spacing = context.streamSpacing;
    // A floating composer's own top padding spaces the banner from its pill.
    final isFloating = StreamMessageComposer.resolveSurfaceStyle(context).isFloating;
    final bottom = isFloating ? 0.0 : spacing.md;

    return Column(
      mainAxisSize: .min,
      children: [
        ListenableBuilder(
          listenable: widget.controller,
          builder: (context, banner) => widget.controller.isEditing ? const SizedBox.shrink() : banner!,
          // Built once, so typing doesn't rebuild it.
          child: StreamScheduledMessagesBanner(
            parentId: widget.parentId,
            onTap: widget.onScheduledMessagesBannerTap,
            margin: EdgeInsetsDirectional.fromSTEB(spacing.md, 0, spacing.md, bottom),
          ),
        ),
        _buildComposer(context),
      ],
    );
  }

  // The composer, scheduling on a long press of send while the channel allows
  // it.
  Widget _buildComposer(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    // A channel not watched yet can't tell, so it doesn't schedule until it is.
    if (channel.state == null) return widget.builder(context, null);

    if (channel != _channel) _canSchedule = null;
    _channel = channel;
    final canSchedule = _canSchedule ??= channel.ownCapabilitiesStream.map(
      (it) => it.contains(ChannelCapability.scheduleMessage),
    );

    return BetterStreamBuilder<bool>(
      stream: canSchedule,
      initialData: channel.canScheduleMessage,
      builder: (context, canSchedule) => widget.builder(context, canSchedule ? _scheduleOnSendLongPress : null),
    );
  }
}

// Schedules the composer's message for a time picked from the schedule sheet.
// The composer is cleared right away, as sending does, and gets the message
// back only when it is refused before it is listed.
Future<void> _scheduleOnSendLongPress(BuildContext context, StreamMessageComposerController controller) async {
  final message = controller.value;
  final channel = StreamChannel.of(context).channel;
  final messenger = StreamSnackbarMessenger.of(context);
  final translations = context.translations;

  final scheduledAt = await showStreamScheduleMessageSheet(context: context, channel: channel, message: message);
  if (scheduledAt == null) return;

  // The next message gets an ID of its own, as the scheduled one took this
  // one's.
  controller.reset();
  final cleared = controller.value;

  try {
    await channel.scheduleMessage(message, scheduledAt: scheduledAt);
  } catch (error) {
    // Its failure is shown on the scheduled messages, to retry from there.
    if (_isListedOnFailure(error)) return;

    // Unless something was typed since, the composer gets it back to fix.
    final isUntouched = controller.value == cleared;
    if (_isRefusedBeforeListed(error) && isUntouched) controller.value = message;

    final text = _scheduleErrorText(translations, channel, error);
    messenger.show(StreamSnackbar(message: Text(text), variant: .error));
  }
}

// Whether the message stays listed as failed after [error], or was sent.
bool _isListedOnFailure(Object error) {
  return switch (error) {
    StreamChatNetworkError(scheduledMessageErrorReason: .scheduledMessageAlreadySent) => true,
    StreamChatNetworkError(:final isRetriable) => isRetriable,
    _ => false,
  };
}

// Whether [error] refused the message before it was listed, or stopped
// listing it, so only the composer still has it.
bool _isRefusedBeforeListed(Object error) {
  return switch (error) {
    ArgumentError() || StateError() || ScheduledMessageRefusedError() => true,
    StreamChatNetworkError(:final isRetriable) => !isRetriable,
    _ => false,
  };
}

// Why scheduling failed with [error], in the words of [translations].
String _scheduleErrorText(Translations translations, Channel channel, Object error) {
  final (reason, isRefusedOnDevice) = switch (error) {
    ScheduledMessageRefusedError(:final reason) => (reason, true),
    StreamChatNetworkError(:final scheduledMessageErrorReason) => (scheduledMessageErrorReason, false),
    _ => (null, false),
  };

  final config = channel.config;
  return switch (reason) {
    .slashCommand => translations.scheduleCommandRefusedError,
    .quotedMessageDeleted => translations.scheduleQuotedMessageDeletedError,
    .scheduledAtTooFar => translations.scheduleTooFarError,
    .scheduledLimitChannel => switch (config?.scheduledMessagesMaxPerChannel) {
      final limit? => translations.scheduleLimitReachedLabel(limit: limit),
      null => translations.scheduleMessageError,
    },
    .scheduledLimitUser => switch (config?.scheduledMessagesMaxPerUser) {
      final limit? => translations.scheduleUserLimitReachedError(limit: limit),
      null => translations.scheduleMessageError,
    },
    .scheduledAtTooSoon => translations.scheduleMessageRefusedError,
    // Any other refusal on this device fails again when retried.
    _ when isRefusedOnDevice => translations.scheduleMessageRefusedError,
    _ => translations.scheduleMessageError,
  };
}
