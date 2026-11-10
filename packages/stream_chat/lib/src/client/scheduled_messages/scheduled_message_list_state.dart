/// @docImport '../client.dart';
library;

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/models/scheduled_message.dart';
import '../../core/util/extension.dart';
import '../../core/util/list_extensions.dart';

/// The scheduled messages a query returned for the channel `cid`.
typedef ChannelScheduledMessages = ({
  String cid,
  List<ScheduledMessage> scheduledMessages,
});

/// The current user's scheduled messages, and whether all of them are loaded.
///
/// Obtained via [ClientState.scheduledMessageListState].
@immutable
final class ScheduledMessageListState extends Equatable {
  /// Creates a state listing [scheduledMessages].
  const ScheduledMessageListState({
    this.scheduledMessages = const [],
    this.hasLoadedAll = false,
  });

  /// The current user's unsent scheduled messages known on this device.
  ///
  /// Failed ones last, each group earliest first.
  final List<ScheduledMessage> scheduledMessages;

  /// Whether every one of the current user's scheduled messages is listed.
  ///
  /// It becomes true once [StreamChatClient.loadScheduledMessages] completes,
  /// and false when the connection is lost. If it was true when the connection
  /// was lost, all of them are loaded again once it recovers.
  final bool hasLoadedAll;

  /// Returns a copy with the given fields replaced.
  ScheduledMessageListState copyWith({
    List<ScheduledMessage>? scheduledMessages,
    bool? hasLoadedAll,
  }) {
    return ScheduledMessageListState(
      scheduledMessages: scheduledMessages ?? this.scheduledMessages,
      hasLoadedAll: hasLoadedAll ?? this.hasLoadedAll,
    );
  }

  @override
  List<Object?> get props => [scheduledMessages, hasLoadedAll];
}

/// The holder of the current user's scheduled message list state.
///
/// It is their only writer.
class ScheduledMessageListStateNotifier {
  /// The scheduled messages, and whether the complete list is loaded.
  ScheduledMessageListState get state => _state.value;
  final _state = BehaviorSubject.seeded(const ScheduledMessageListState());

  /// The [state] as it changes.
  ///
  /// Emits the current value on listen, then a new value each time it changes.
  Stream<ScheduledMessageListState> get stream => _state.stream;

  List<ScheduledMessage> get _scheduledMessages => state.scheduledMessages;

  /// Replaces the scheduled messages with [scheduledMessages], the complete list.
  ///
  /// The list is then loaded. The ones still being scheduled, or whose request
  /// failed, are kept.
  void onLoadScheduledMessages(List<ScheduledMessage> scheduledMessages) {
    final local = _scheduledMessages.where((it) => it.isLocal);
    final merged = _merged(local, scheduledMessages);

    _emit(state.copyWith(scheduledMessages: _sorted(merged), hasLoadedAll: true));
  }

  /// Adds [scheduledMessages], from a page or a filtered query.
  ///
  /// Of two with the same ID, the newer one is used. Nothing is removed.
  void onQueryScheduledMessages(List<ScheduledMessage> scheduledMessages) {
    final merged = _merged(_scheduledMessages, scheduledMessages);
    _emit(state.copyWith(scheduledMessages: _sorted(merged)));
  }

  /// Replaces the scheduled messages of each of [channels] with its queried ones.
  ///
  /// The ones still being scheduled, or whose request failed, are kept.
  void onChannelsQueried(List<ChannelScheduledMessages> channels) {
    final cids = {for (final it in channels) it.cid};
    final kept = _scheduledMessages.where((it) => !cids.contains(it.cid) || it.isLocal);

    final queried = channels.expand((it) => it.scheduledMessages);
    final merged = _merged(kept, queried);
    _emit(state.copyWith(scheduledMessages: _sorted(merged)));
  }

  /// Adds or updates [scheduledMessage].
  ///
  /// Nothing changes if the listed one is newer.
  void onScheduledMessageUpserted(ScheduledMessage scheduledMessage) {
    final updated = _scheduledMessages.sortedUpsert(
      scheduledMessage,
      key: (it) => it.id,
      update: _newer,
      compare: _byScheduledAt,
    );

    _emit(state.copyWith(scheduledMessages: updated));
  }

  /// Removes the scheduled message [id], which was sent or deleted.
  void onScheduledMessageRemoved(String id) {
    final index = _scheduledMessages.indexWhere((it) => it.id == id);
    if (index == -1) return;

    final remaining = [..._scheduledMessages]..removeAt(index);
    _emit(state.copyWith(scheduledMessages: remaining));
  }

  /// Marks the list as possibly incomplete, as the connection was lost.
  void onConnectionLost() => _emit(state.copyWith(hasLoadedAll: false));

  /// Forgets all of the scheduled messages, which are then no longer loaded.
  void clear() => _emit(const ScheduledMessageListState());

  /// Stops accepting changes to the [state].
  Future<void> dispose() => _state.close();

  // Failed ones last, then by scheduledAt, earliest first, then by ID.
  static int _byScheduledAt(ScheduledMessage a, ScheduledMessage b) {
    final isAFailed = a.status == .failed;
    final isBFailed = b.status == .failed;
    if (isAFailed != isBFailed) return isAFailed ? 1 : -1;

    final byScheduledAt = a.scheduledAt.compareTo(b.scheduledAt);
    if (byScheduledAt != 0) return byScheduledAt;

    return a.id.compareTo(b.id);
  }

  // A newer copy wins over an older one, and one from the API over a local one.
  static ScheduledMessage _newer(
    ScheduledMessage original,
    ScheduledMessage updated,
  ) {
    if (original.remoteUpdatedAt == null) return updated;
    if (updated.remoteUpdatedAt == null) return original;
    return original.updatedAt.isAfter(updated.updatedAt) ? original : updated;
  }

  // [listed] with [incoming] merged in by ID, keeping the newer of two.
  static Iterable<ScheduledMessage> _merged(
    Iterable<ScheduledMessage> listed,
    Iterable<ScheduledMessage> incoming,
  ) {
    return listed.merge(incoming, key: (it) => it.id, update: _newer);
  }

  static List<ScheduledMessage> _sorted(
    Iterable<ScheduledMessage> scheduledMessages,
  ) {
    return scheduledMessages.toList().sortedWith(_byScheduledAt);
  }

  void _emit(ScheduledMessageListState next) {
    if (next == state) return;
    _state.safeAdd(next);
  }
}

extension on ScheduledMessage {
  // Whether it is still being scheduled, or scheduling it failed and can be
  // retried.
  bool get isLocal {
    if (status == .preparingToSchedule) return true;
    return failureReason?.isRetriable ?? false;
  }
}
