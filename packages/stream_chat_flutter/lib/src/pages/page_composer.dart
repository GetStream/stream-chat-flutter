import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../stream_chat_flutter.dart';

/// The composer of a [StreamChannelPage] or [StreamThreadPage], with a
/// [StreamScheduledMessagesBanner] above it.
///
/// The banner is hidden while [controller] edits a message.
@internal
class PageComposer extends StatelessWidget {
  /// Creates a page composer that shows [composer] below the banner.
  const PageComposer({
    super.key,
    required this.controller,
    required this.composer,
    this.parentId,
    this.onScheduledMessagesBannerTap,
  });

  /// The controller of [composer], whose editing hides the banner.
  final StreamMessageComposerController controller;

  /// The composer shown below the banner.
  final Widget composer;

  /// The ID of the message whose thread's scheduled replies the banner counts.
  ///
  /// When null, the banner counts the channel's scheduled messages.
  final String? parentId;

  /// Called when the banner is tapped.
  ///
  /// When null, the banner's link isn't shown.
  final VoidCallback? onScheduledMessagesBannerTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    // A floating composer's own top padding spaces the banner from its pill.
    final isFloating = StreamMessageComposer.resolveSurfaceStyle(context).isFloating;
    final bottom = isFloating ? 0.0 : spacing.md;

    return Column(
      mainAxisSize: .min,
      children: [
        ListenableBuilder(
          listenable: controller,
          builder: (context, banner) => controller.isEditing ? const SizedBox.shrink() : banner!,
          // Built once, so typing doesn't rebuild it.
          child: StreamScheduledMessagesBanner(
            parentId: parentId,
            onTap: onScheduledMessagesBannerTap,
            margin: EdgeInsetsDirectional.fromSTEB(spacing.md, 0, spacing.md, bottom),
          ),
        ),
        composer,
      ],
    );
  }
}
