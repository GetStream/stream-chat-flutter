import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// This method calculates the align that the modal of reactions should have.
/// This is an approximation based on the size of the message and the
/// available space in the screen.
double calculateReactionsHorizontalAlignment(
  User? user,
  Message message,
  BoxConstraints constraints,
  double? fontSize,
  Orientation orientation,
) {
  final maxWidth = constraints.maxWidth;

  final roughSentenceSize = message.roughMessageSize(fontSize);
  final hasAttachments = message.attachments.isNotEmpty;
  final isReply = message.quotedMessageId != null;
  final isAttachment = hasAttachments && !isReply;

  // divFactor is the percentage of the available space that the message takes.
  // When the divFactor is bigger than 0.5 that means that the messages is
  // bigger than 50% of the available space and the modal should have an offset
  // in the direction that the message grows. When the divFactor is smaller
  // than 0.5 then the offset should be to he side opposite of the message
  // growth.
  // In resume, when divFactor > 0.5 then result > 0, when divFactor < 0.5
  // then result < 0.
  var divFactor = 0.5;

  // When in portrait, attachments normally take 75% of the screen, when in
  // landscape, attachments normally take 50% of the screen.
  if (isAttachment) {
    if (orientation == Orientation.portrait) {
      divFactor = 0.75;
    } else {
      divFactor = 0.5;
    }
  } else {
    divFactor = roughSentenceSize == 0 ? 0.5 : (roughSentenceSize / maxWidth);
  }

  final signal = user?.id == message.user?.id ? 1 : -1;
  final result = signal * (1 - divFactor * 2.0);

  return _capResult(result);
}

// Ensure reactions don't get pushed past the edge of the screen.
//
// This happens if divFactor is really big. When this happens, we can simply
// move the model all the way to the end of screen.
double _capResult(double result) {
  if (result > 1.0) {
    return 1;
  } else if (result < -1.0) {
    return -1;
  } else {
    return result;
  }
}
