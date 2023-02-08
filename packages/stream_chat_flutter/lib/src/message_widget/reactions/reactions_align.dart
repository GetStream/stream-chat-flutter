import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Document here!!
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
  final hasAttachments = message.attachments.isNotEmpty;
  final divFactor = hasAttachments
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
      hasAttachments,
    );
  } else {
    return _landScapeAlign(
      user,
      message,
      maxWidth,
      maxHeight,
      shiftFactor,
      divFactor,
      hasAttachments,
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
  bool hasAttachments,
) {
  var result = 0.0;

  // This is an empiric value. This number tries to approximate all the
  // offset necessary for the position of reaction look the best way
  // possible.
  const constant = 1300;

  if (user?.id == message.user?.id) {
    if (divFactor >= 1.0 || hasAttachments) {
      result = shiftFactor - maxWidth / constant;
    } else {
      // Small messages, it is simpler to align then.
      result = 1.2 - divFactor;
    }
  } else {
    if (divFactor >= 1.0 || hasAttachments) {
      result = shiftFactor + maxWidth / constant;
    } else {
      result = -(1.2 - divFactor);
    }
  }

  print('INFO - result portrait: $result');

  // Ensure reactions don't get pushed past the edge of the screen.
  //
  // This happens if divFactor is really big. When this happens, we can simply
  // move the model all the way to the end of screen.
  if (result > 1.0) {
    return 1;
  } else if (result < -1.0) {
    return -1;
  } else {
    return result;
  }
}

double _landScapeAlign(
  User? user,
  Message message,
  double maxWidth,
  double maxHeight,
  double shiftFactor,
  num divFactor,
  bool hasAttachments,
) {
  var result = 0.0;

  /*
   This is an empiric value. This number tries to approximate all the
   offset necessary for the position of reaction look the best way
   possible.
  */
  const constant = 3000;

  if (user?.id == message.user?.id) {
    if (divFactor >= 1.7) {
      result = shiftFactor - maxWidth / constant;
    } else {
      // Small messages, it is simpler to align then.
      result = 1 - divFactor * 0.6;
    }
  } else {
    if (divFactor >= 1.7) {
      result = shiftFactor + maxWidth / constant;
    } else {
      result = -(1.2 - divFactor * 0.6);
    }
  }

  // Ensure reactions don't get pushed past the edge of the screen.
  //
  // This happens if divFactor is really big. When this happens, we can simply
  // move the model all the way to the end of screen.
  if (result > 1.0) {
    return 1;
  } else if (result < -1.0) {
    return -1;
  } else {
    return result;
  }
}
