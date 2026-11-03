import '../core/util/immutable_collection_subjects.dart';
import 'channel/channel.dart';

/// The live channels of a client, and which of them are listed.
///
/// A channel the current user hides or is removed from leaves [channels] but
/// stays here, alive, so code still holding it keeps working. It stays until
/// it is listed again or removed, or this registry is disposed.
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
  Iterable<Channel> get all => [..._listed.value.values, ..._unlisted.values];

  /// The live channel for [cid], listed or not.
  Channel? channelFor(String cid) => _listed.value[cid] ?? _unlisted[cid];

  /// Lists exactly [channels], replacing the listed ones.
  void setChannels(Map<String, Channel> channels) {
    _unlisted.removeWhere((cid, _) => channels.containsKey(cid));
    _listed.safeAdd(channels);
  }

  /// Lists [channels] alongside the ones already listed.
  void addChannels(Map<String, Channel> channels) {
    setChannels({..._listed.value, ...channels});
  }

  /// Takes the channel with [cid] out of [channels], keeping it alive.
  void unlist(String cid) {
    final channel = _listed.value[cid];
    if (channel == null) return;

    removeChannel(cid);
    _unlisted[cid] = channel;
  }

  /// Puts the channel with [cid] back into [channels] after [unlist].
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
    final remaining = all.toList();
    _listed.close();
    for (final channel in remaining) {
      channel.dispose();
    }
  }
}
