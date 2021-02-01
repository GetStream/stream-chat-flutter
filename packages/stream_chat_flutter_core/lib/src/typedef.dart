import 'package:flutter/widgets.dart';
import 'package:stream_chat/stream_chat.dart';

/// A signature for a callback which exposes an error and returns a function.
/// This Callback can be used in cases where an API failure occurs and the widget
/// is unable to render data.
typedef ErrorBuilder = Widget Function(BuildContext context, Object error);

/// A Signature for a handler function which will expose a [event].
typedef EventHandler = void Function(Event event);
