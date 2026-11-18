import '../core/util/immutable_collection_subjects.dart';
import 'channel/channel.dart';

/// The channels of a client, one per cid.
///
/// Listed channels are in [channels]. A hidden channel, or one that hasn't
/// loaded yet, stays the client's channel for its cid without being listed. A
/// deleted, removed or replaced channel is detached, and kept alive until
/// [dispose].
class ChannelRegistry {
  final _channels = <String, Channel>{};
  final _listed = ImmutableMapBehaviorSubject<String, Channel>.seeded(const {});
  final _detached = <Channel>[];

  /// The listed channels, by cid.
  Map<String, Channel> get channels => _listed.value;

  /// The listed channels by cid, as they change.
  ///
  /// Emits the current channels on listen, then a new map each time a channel
  /// is listed, unlisted or removed.
  Stream<Map<String, Channel>> get channelsStream => _listed.stream;

  /// Every channel the client holds for a cid, listed or not.
  Iterable<Channel> get live => [..._channels.values];

  /// The channel the client holds for [cid], listed or not.
  Channel? operator [](String cid) => _channels[cid];

  /// The channel for [cid], created with [create] if there is none.
  Channel putIfAbsent(String cid, Channel Function() create) {
    return _channels.putIfAbsent(cid, create);
  }

  /// Lists exactly [channels], replacing the listed ones.
  ///
  /// A different channel the client held for one of their cids is detached.
  /// A channel left out of [channels] stays the client's channel, unlisted.
  void setChannels(Map<String, Channel> channels) {
    for (final MapEntry(key: cid, value: channel) in channels.entries) {
      _detached.removeWhere((it) => identical(it, channel));

      final current = _channels[cid];
      if (current != null && !identical(current, channel)) _detached.add(current);
      _channels[cid] = channel;
    }

    _listed.safeAdd(channels);
  }

  /// Lists [channels] alongside the ones already listed.
  void addChannels(Map<String, Channel> channels) {
    setChannels({..._listed.value, ...channels});
  }

  /// Takes the channel with [cid] out of [channels].
  ///
  /// It stays the client's channel for [cid].
  void unlist(String cid) {
    if (!_listed.value.containsKey(cid)) return;

    _listed.safeAdd({..._listed.value}..remove(cid));
  }

  /// Lists the channel with [cid] again after [unlist].
  ///
  /// Does nothing for a channel that hasn't loaded yet.
  void relist(String cid) {
    final channel = _channels[cid];
    if (channel == null || channel.state == null) return;
    if (_listed.value.containsKey(cid)) return;

    addChannels({cid: channel});
  }

  /// Detaches the channel with [cid], listed or not, keeping it alive.
  void detach(String cid) {
    final channel = _channels.remove(cid);
    if (channel == null) return;

    unlist(cid);
    _detached.add(channel);
  }

  /// Forgets [channel] without disposing it.
  ///
  /// Another channel the client holds for the same cid stays in place.
  void remove(Channel channel) {
    _detached.removeWhere((it) => identical(it, channel));

    final cid = channel.cid;
    if (cid == null || !identical(_channels[cid], channel)) return;

    _channels.remove(cid);
    unlist(cid);
  }

  /// Disposes every channel, detached ones included.
  ///
  /// [channelsStream] is closed afterwards.
  void dispose() {
    // Taken before closing, as disposing a channel removes it from here.
    final remaining = [...live, ..._detached];
    _listed.close();
    for (final channel in remaining) {
      channel.dispose();
    }
  }
}
