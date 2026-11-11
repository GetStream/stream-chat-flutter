import 'package:flutter/material.dart';

import '../../stream_chat_flutter.dart';

/// The composer of a [StreamChannelPage] or [StreamThreadPage], with a
/// [StreamScheduledMessagesBanner] above it.
///
/// The banner is hidden while [controller] edits a message.
class PageComposer extends StatelessWidget {
  /// Creates a page composer that shows [composer] below the banner.
  const PageComposer({
    super.key,
    required this.controller,
    required this.composer,
    this.parentId,
    this.onScheduledMessagesViewAllPressed,
  });

  /// The controller of [composer], whose editing hides the banner.
  final StreamMessageComposerController controller;

  /// The composer shown below the banner.
  final Widget composer;

  /// The ID of the message whose thread's scheduled replies the banner counts.
  ///
  /// When null, the banner counts the channel's scheduled messages.
  final String? parentId;

  /// Called when "View all" on the banner is tapped.
  ///
  /// When null, "View all" isn't shown.
  final VoidCallback? onScheduledMessagesViewAllPressed;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    // A floating composer's own top padding spaces the banner from its pill.
    final isFloating = StreamMessageComposer.resolveSurfaceStyle(context).isFloating;

    return Column(
      mainAxisSize: .min,
      children: [
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            if (controller.isEditing) return const SizedBox.shrink();

            return StreamScheduledMessagesBanner(
              parentId: parentId,
              onViewAllPressed: onScheduledMessagesViewAllPressed,
              margin: EdgeInsetsDirectional.fromSTEB(spacing.md, 0, spacing.md, isFloating ? 0 : spacing.md),
            );
          },
        ),
        composer,
      ],
    );
  }
}
