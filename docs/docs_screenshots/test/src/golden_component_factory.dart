import 'package:flutter/widgets.dart';
import 'package:stream_core_flutter/chat.dart';

import 'golden_network_image.dart';

/// Wraps the test tree in a [StreamComponentFactory] tuned for golden tests:
///
/// - `emoji` is wrapped in an 8 px top padding so glyphs align with
///   surrounding text.
/// - `networkImage` is swapped for a deterministic [GoldenAvatarFixtures]
///   provider so avatars and channel images render predictably without any
///   real HTTP fetch.
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
        networkImage: goldenNetworkImageBuilder,
      ),
      child: child,
    );
  }
}
