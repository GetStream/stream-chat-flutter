import 'package:flutter/widgets.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// Wraps the test tree in a [StreamComponentFactory] that nudges
/// [DefaultStreamEmoji] glyphs down by 8 px so their visual baseline aligns
/// with surrounding text in golden renders.
class GoldenComponentFactory extends StatelessWidget {
  const GoldenComponentFactory({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamComponentFactory(
      builders: StreamComponentBuilders(
        emoji: (context, props) => Padding(
          padding: const EdgeInsets.only(top: 8),
          child: DefaultStreamEmoji(props: props),
        ),
      ),
      child: child,
    );
  }
}
