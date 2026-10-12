import 'package:flutter/widgets.dart';

/// A builder that reuses its child until [dependencies] change.
///
/// Values [builder] reads through its `context`, such as the theme, still
/// rebuild the child when they change. Any other value it reads must be part
/// of [dependencies], or the child keeps showing the value it was built with.
class MemoizedBuilder extends StatefulWidget {
  /// Creates a widget that reuses its child until [dependencies] change.
  const MemoizedBuilder({
    super.key,
    required this.dependencies,
    required this.builder,
  });

  /// The values [builder] builds from, compared with `==`.
  ///
  /// Several values can be passed as a record.
  final Object? dependencies;

  /// The function that builds the child.
  final WidgetBuilder builder;

  @override
  State<MemoizedBuilder> createState() => _MemoizedBuilderState();
}

class _MemoizedBuilderState extends State<MemoizedBuilder> {
  // Built under its own context, so values the builder reads through it
  // rebuild only that subtree while the same child is returned.
  Widget? _child;

  @override
  void didUpdateWidget(MemoizedBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dependencies != oldWidget.dependencies) _child = null;
  }

  @override
  Widget build(BuildContext context) {
    return _child ??= Builder(builder: (context) => widget.builder(context));
  }
}
