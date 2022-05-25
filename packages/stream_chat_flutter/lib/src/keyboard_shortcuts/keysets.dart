import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The keyset for sending a message.
final sendMessageKeySet = LogicalKeySet(
  LogicalKeyboardKey.enter,
);

/// The keyset for removing a reply.
final removeReplyKeySet = LogicalKeySet(
  LogicalKeyboardKey.escape,
);

/// The keyset for navigating to the next gallery item.
final nextGalleryItemKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowRight,
);

/// The keyset for navigating to the previous gallery item.
final previousGalleryItemKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowLeft,
);