import 'package:meta/meta.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'extensions.dart';

/// The name of [channel] while it is loaded, or null when it isn't or has no
/// name to show.
///
/// A channel without a name of its own is named after its other members, as
/// [currentUser] sees them.
@internal
String? loadedChannelName(Channel? channel, {User? currentUser}) {
  // A loaded channel keeps its members on its state, not on its model.
  final state = channel?.state;
  final model = state?.channelState.channel?.copyWith(members: state.members);

  final name = model?.formatName(currentUser: currentUser);
  if (name == null || name.trim().isEmpty) return null;

  return name;
}
