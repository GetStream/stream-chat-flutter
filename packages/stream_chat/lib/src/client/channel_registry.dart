import '../core/util/immutable_collection_subjects.dart';
import 'channel/channel.dart';

/// The live channels of a client.
///
/// Only the listed ones are in [channels]. A channel the current user hides or
/// is removed from is unlisted instead: it leaves [channels] but stays alive,
/// so code still holding it keeps working until it is listed again, removed,
/// or disposed with the rest.
class ChannelRegistry {
  final _listed = ImmutableMapBehaviorSubject<String, Channel>.seeded(const {});
  final _unlisted = <String, Channel>{};

  /// The listed channels, by cid.
  Map<String, Channel> get channels => _listed.value;

  /// The listed channels as a stream.
  ///
  /// Emits the current channels on listen, then a new map each time a channel
  /// is listed, unlisted or removed.
  Stream<Map<String, Channel>> get channelsStream => _listed.stream;

  /// Every live channel, listed or not.
  Iterable<Channel> get live => [..._listed.value.values, ..._unlisted.values];

  /// The live channel for [cid], listed or not.
  Channel? operator [](String cid) => _listed.value[cid] ?? _unlisted[cid];

  /// Lists exactly [channels], replacing the listed ones.
  ///
  /// An unlisted channel among them is listed again.
  void setChannels(Map<String, Channel> channels) {
    _unlisted.removeWhere((cid, _) => channels.containsKey(cid));
    _listed.safeAdd(channels);
  }

  /// Lists [channels] alongside the ones already listed.
  ///
  /// An unlisted channel among them is listed again.
  void addChannels(Map<String, Channel> channels) {
    setChannels({..._listed.value, ...channels});
  }

  /// Takes the channel with [cid] out of [channels], keeping it alive.
  void unlist(String cid) {
    final channel = _listed.value[cid];
    if (channel == null) return;

    _listed.safeAdd({..._listed.value}..remove(cid));
    _unlisted[cid] = channel;
  }

  /// Lists the channel with [cid] again after [unlist].
  void relist(String cid) {
    final channel = _unlisted[cid];
    if (channel == null) return;

    addChannels({cid: channel});
  }

  /// Forgets the channel with [cid], listed or not, without disposing it.
  void removeChannel(String cid) {
    _unlisted.remove(cid);
    if (!_listed.value.containsKey(cid)) return;

    _listed.safeAdd({..._listed.value}..remove(cid));
  }

  /// Disposes every live channel and stops emitting [channelsStream].
  void dispose() {
    // Taken before closing, as disposing a channel removes it from here.
    final remaining = live.toList();
    _listed.close();
    for (final channel in remaining) {
      channel.dispose();
    }
  }
}
