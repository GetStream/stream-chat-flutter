import '../core/util/immutable_collection_subjects.dart';
import 'channel/channel.dart';

/// The live channels of a client.
///
/// Listed channels are in [channels]. Unlisted ones are hidden but still the
/// client's channel for their cid. Detached ones are deleted, removed or
/// replaced, and kept alive until [dispose].
class ChannelRegistry {
  final _listed = ImmutableMapBehaviorSubject<String, Channel>.seeded(const {});
  final _unlisted = <String, Channel>{};
  final _detached = <Channel>[];

  /// The listed channels, by cid.
  Map<String, Channel> get channels => _listed.value;

  /// The listed channels as a stream.
  ///
  /// Emits the current channels on listen, then a new map each time a channel
  /// is listed, unlisted or removed.
  Stream<Map<String, Channel>> get channelsStream => _listed.stream;

  /// Every channel the client holds for a cid, listed or not.
  Iterable<Channel> get live => [..._listed.value.values, ..._unlisted.values];

  /// The channel the client holds for [cid], listed or not.
  Channel? operator [](String cid) => _listed.value[cid] ?? _unlisted[cid];

  /// Lists exactly [channels], replacing the listed ones.
  ///
  /// An unlisted or detached channel among them is listed again. A different
  /// channel the client held for one of their cids is detached.
  void setChannels(Map<String, Channel> channels) {
    for (final MapEntry(key: cid, value: channel) in channels.entries) {
      _detached.remove(channel);

      final current = this[cid];
      _unlisted.remove(cid);
      if (current != null && !identical(current, channel)) _detached.add(current);
    }

    _listed.safeAdd(channels);
  }

  /// Lists [channels] alongside the ones already listed.
  ///
  /// An unlisted or detached channel among them is listed again.
  void addChannels(Map<String, Channel> channels) {
    setChannels({..._listed.value, ...channels});
  }

  /// Takes the channel with [cid] out of [channels], keeping it as the client's
  /// channel for [cid].
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

  /// Detaches the channel with [cid], listed or not, keeping it alive.
  void detach(String cid) {
    final channel = this[cid];
    if (channel == null) return;

    _removeByCid(cid);
    _detached.add(channel);
  }

  /// Forgets [channel] without disposing it.
  ///
  /// Another channel the client holds for the same cid stays in place.
  void remove(Channel channel) {
    _detached.remove(channel);

    final cid = channel.cid;
    if (cid == null || !identical(this[cid], channel)) return;

    _removeByCid(cid);
  }

  // Forgets the channel with [cid], listed or not, without disposing it.
  void _removeByCid(String cid) {
    _unlisted.remove(cid);
    if (!_listed.value.containsKey(cid)) return;

    _listed.safeAdd({..._listed.value}..remove(cid));
  }

  /// Disposes every channel, detached ones included, and stops emitting
  /// [channelsStream].
  void dispose() {
    // Taken before closing, as disposing a channel removes it from here.
    final remaining = [...live, ..._detached];
    _listed.close();
    for (final channel in remaining) {
      channel.dispose();
    }
  }
}
