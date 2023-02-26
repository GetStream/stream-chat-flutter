import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// This method calculates the align that the modal of reactions should have.
/// THis is an approximation based on the size of the message and the
/// available space in the screen.
double calculateReactionsHorizontalAlignmentValue(
  User? user,
  Message message,
  BoxConstraints constraints,
  double maxSize,
  double? fontSize,
  int reactionsCount,
  Orientation orientation,
) {
  final shiftFactor = reactionsCount < 5 ? (5 - reactionsCount) * 0.1 : 0.0;
  final maxWidth = constraints.maxWidth;
  final maxHeight = constraints.maxHeight;

  final roughSentenceSize = message.roughMessageSize(fontSize);
  print('roughSentenceSize: $roughSentenceSize');
  print('maxSize: $maxSize');
  final hasAttachments = message.attachments.isNotEmpty;
  final isReply = message.quotedMessageId != null;
  final isAttachment = hasAttachments && !isReply;
  final divFactor = isAttachment
      ? 1
      : (roughSentenceSize == 0 ? 1 : (roughSentenceSize / maxSize));

  if (orientation == Orientation.portrait) {
    return _portraitAlign(
      user,
      message,
      maxWidth,
      maxHeight,
      shiftFactor,
      divFactor,
      isAttachment,
    );
  } else {
    return _landScapeAlign(
      user,
      message,
      maxWidth,
      maxHeight,
      shiftFactor,
      divFactor,
      isAttachment,
    );
  }
}

double _portraitAlign(
  User? user,
  Message message,
  double maxWidth,
  double maxHeight,
  double shiftFactor,
  num divFactor,
  bool isAttachment,
) {
  var result = 0.0;

  // This is an empiric value. This number tries to approximate all the
  // offset necessary for the position of reaction look the best way
  // possible.
  const constant = 1300;

  print('is attachment: $isAttachment');
  print('shiftFactor: $shiftFactor');
  print('divFactor: $divFactor');

  if (user?.id == message.user?.id) {
    if (divFactor >= 1.0 || isAttachment) {
      result = shiftFactor - maxWidth / constant;
    } else {
      // Small messages, it is simpler to align then.
      result = 1.2 - divFactor;
    }
  } else {
    if (divFactor >= 1.0 || isAttachment) {
      result = shiftFactor + maxWidth / constant;
    } else {
      result = -(1.2 - divFactor);
    }
  }

  return _capResult(result);
}

double _landScapeAlign(
  User? user,
  Message message,
  double maxWidth,
  double maxHeight,
  double shiftFactor,
  num divFactor,
  bool isAttachment,
) {
  var result = 0.0;

  print('is attachment: $isAttachment');
  print('shiftFactor: $shiftFactor');
  print('divFactor: $divFactor');

  /*
   This is an empiric value. This number tries to approximate all the
   offset necessary for the position of reaction look the best way
   possible.
  */
  const constant = 3000;
  if (isAttachment) {
    result = 0;
  } else if (user?.id == message.user?.id) {
    if (divFactor >= 1.0) {
      result = 0;
    } else {
      // Small messages, it is simpler to align then.
      result = 1 - divFactor * 0.6;
    }
  } else {
    if (divFactor >= 1.0) {
      result = shiftFactor + maxWidth / constant;
    } else {
      result = -(1 - divFactor * 0.6);
    }
  }

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
