import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stream_chat/stream_chat.dart';

/// A signature for a callback which exposes an error and returns a function.
/// This Callback can be used in cases where an API failure occurs and the
/// widget is unable to render data.
// TODO: Add stacktrace as a parameter in v7.0.0
typedef ErrorBuilder = Widget Function(BuildContext context, Object error);

/// A Signature for a handler function which will expose a [event].
typedef EventHandler = void Function(Event event);

/// {@template errorListener}
/// A callback that can be passed to [StreamMessageComposerController.sendMessage].
///
/// This callback should not throw.
/// {@endtemplate}
typedef ErrorListener = void Function(Object error, StackTrace? stackTrace);

/// A function that returns true if the message is valid and can be sent.
typedef MessageValidator = bool Function(Message message);

/// Function called right before sending the message. Can be used to transform
/// the message before it is sent.
typedef PreMessageSending = FutureOr<Message> Function(Message message);

/// Signature for the function that determines if a [matchedUri] should be
/// previewed as an OG Attachment.
typedef OgPreviewFilter = bool Function(Uri matchedUri, String messageText);
