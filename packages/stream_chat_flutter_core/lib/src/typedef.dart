import 'package:flutter/widgets.dart';

/// A signature for a callback which exposes an error and returns a function.
/// This Callback can be used in cases where an API failure occurs and the widget
/// is unable to render data.
typedef ErrorBuilder = Widget Function(BuildContext context, Object error);
