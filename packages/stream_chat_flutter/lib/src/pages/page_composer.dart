import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../stream_chat_flutter.dart';
import '../localization/translations.dart';

/// The composer of a [StreamChannelPage] or [StreamThreadPage].
///
/// A [StreamScheduledMessagesBanner] is shown above it.
///
/// The banner is hidden while [controller] edits a message. Where the user can
/// schedule messages, a long press of send schedules the message, unless
/// [StreamChatConfigurationData.scheduledMessagesEnabled] is false, which also
/// hides the banner.
@internal
class PageComposer extends StatefulWidget {
  /// Creates a page composer around the composer [builder] builds.
  ///
  /// The composer is shown below the banner.
  const PageComposer({
    super.key,
    required this.controller,
    required this.builder,
    this.parentId,
    this.onScheduledMessagesBannerTap,
  });

  /// The controller of the composer, whose editing hides the banner.
  final StreamMessageComposerController controller;

  /// Builds the composer shown below the banner.
  ///
  /// It is given what a long press of send does, or null when it does
  /// nothing.
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

// Schedules the composer's message for a time picked from the schedule sheet,
// clearing the composer as soon as the time is picked. A refused one is put
// back, unless something was typed meanwhile.
Future<void> _scheduleOnSendLongPress(
  BuildContext context,
  StreamMessageComposerController controller,
) async {
  final message = controller.value;
  final channel = StreamChannel.of(context).channel;
  final messenger = StreamSnackbarMessenger.of(context);
  final translations = context.translations;

  final scheduledAt = await showStreamScheduleMessageSheet(context: context, channel: channel, message: message);
  if (scheduledAt == null || !context.mounted) return;

  // Cleared before it is scheduled, so it can't be sent as well meanwhile.
  controller.reset();
  final cleared = controller.value;

  try {
    await channel.scheduleMessage(message, scheduledAt: scheduledAt);
  } catch (error) {
    // One listed as failed is retried from the scheduled messages.
    final listed = channel.client.state.scheduledMessages.where((it) => it.id == message.id).firstOrNull;
    if (listed != null) {
      if (listed.failure case final ScheduledMessageUploadFailed failure) {
        final text = translations.scheduledMessageFailureText(failure: failure);
        messenger.show(StreamSnackbar(message: Text(text), variant: .error));
      }
      return;
    }

    // One deleted, replaced or sent meanwhile is done with.
    if (!_isRefused(error)) return;

    final text = _scheduleErrorText(translations, channel, error);
    messenger.show(StreamSnackbar(message: Text(text), variant: .error));

    if (context.mounted && controller.value == cleared) controller.message = message;
  }
}

// Whether scheduling was refused with [error], so the message isn't scheduled.
bool _isRefused(Object error) {
  return switch (error) {
    ScheduledMessageRefusedError() || ArgumentError() || StateError() => true,
    StreamChatNetworkError(scheduledMessageErrorReason: .scheduledMessageAlreadySent) => false,
    StreamChatNetworkError() => !error.isRetriable,
    _ => false,
  };
}

// Why scheduling failed with [error], in the words of [translations].
String _scheduleErrorText(Translations translations, Channel channel, Object error) {
  final (reason, isRefused) = switch (error) {
    ScheduledMessageRefusedError() => (error.reason, true),
    StreamChatNetworkError() => (error.scheduledMessageErrorReason, !error.isRetriable),
    _ => (null, false),
  };

  final config = channel.config;
  return switch (reason) {
    .scheduledMessageIsCommand => translations.scheduleCommandRefusedError,
    .scheduledMessageQuoteDeleted => translations.scheduleQuotedMessageDeletedError,
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
    // Any other refusal, on this device or by the server, fails again when
    // retried.
    _ when isRefused => translations.scheduleMessageRefusedError,
    _ => translations.scheduleMessageError,
  };
}
