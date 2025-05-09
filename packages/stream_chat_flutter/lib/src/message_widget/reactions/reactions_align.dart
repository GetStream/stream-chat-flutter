import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Extension on [Message] that provides alignment calculations for reaction
/// pickers.
///
/// This extension adds functionality to determine the optimal positioning of
/// reaction pickers based on message size and available screen space.
extension ReactionPickerAlignment on Message {
  /// Calculates the alignment for the reaction picker based on the message size
  /// and the available space.
  ///
  /// The [fontSize] is used to calculate the size of the message, if not
  /// provided, the font size of 1 is used.
  ///
  /// The [orientation] is used to calculate the size of the message, if not
  /// provided, the orientation of the device is used.
  AlignmentGeometry calculateReactionPickerAlignment({
    required BoxConstraints constraints,
    double? fontSize,
    Orientation orientation = Orientation.portrait,
    bool reverse = false,
  }) {
    final maxWidth = constraints.maxWidth;

    final roughSentenceSize = roughMessageSize(fontSize);
    final hasAttachments = attachments.isNotEmpty;
    final isReply = quotedMessageId != null;
    final isAttachment = hasAttachments && !isReply;

    // divFactor is the percentage of the available space that the message
    // takes.
    //
    // When the divFactor is bigger than 0.5 that means that the messages is
    // bigger than 50% of the available space and the modal should have an
    // offset in the direction that the message grows. When the divFactor is
    // smaller than 0.5 then the offset should be to he side opposite of the
    // message growth.
    //
    // In resume, when divFactor > 0.5 then result > 0, when divFactor < 0.5
    // then result < 0.
    var divFactor = 0.5;

    // When in portrait, attachments normally take 75% of the screen, when in
    // landscape, attachments normally take 50% of the screen.
    if (isAttachment) {
      divFactor = switch (orientation) {
        Orientation.portrait => 0.75,
        Orientation.landscape => 0.5,
      };
    } else {
      divFactor = roughSentenceSize == 0 ? 0.5 : (roughSentenceSize / maxWidth);
    }

    final signal = reverse ? 1 : -1;
    final result = signal * (1 - divFactor * 2.0);

    // Ensure reactions don't get pushed past the edge of the screen.
    //
    // This happens if divFactor is really big. When this happens, we can simply
    // move the model all the way to the end of screen.
    return Alignment(result.clamp(-1, 1), 0);
  }
}
