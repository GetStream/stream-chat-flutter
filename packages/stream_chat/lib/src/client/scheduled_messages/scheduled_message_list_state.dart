/// @docImport '../client.dart';
library;

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/models/message.dart';
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
  /// Earliest first, failed ones included.
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

  /// Replaces the list with [scheduledMessages], which is then complete.
  ///
  /// The ones still being scheduled, or whose request failed, are kept, and
  /// so are the unsaved edits of the ones in [scheduledMessages].
  void onLoaded(List<ScheduledMessage> scheduledMessages) {
    final kept = _scheduledMessages.where((it) => it.isKeptOver(scheduledMessages));
    final merged = _merged(kept, scheduledMessages);

    _emit(state.copyWith(scheduledMessages: _sorted(merged), hasLoadedAll: true));
  }

  /// Adds [scheduledMessages], from a page or a filtered query.
  ///
  /// Of two with the same ID, the newer one is used. Nothing is removed.
  void onQueried(List<ScheduledMessage> scheduledMessages) {
    final merged = _merged(_scheduledMessages, scheduledMessages);
    _emit(state.copyWith(scheduledMessages: _sorted(merged)));
  }

  /// Replaces the scheduled messages of each of [channels].
  ///
  /// Each channel lists the ones queried for it. The ones still being
  /// scheduled, or whose request failed, are kept, and so are the unsaved
  /// edits of the ones queried.
  void onChannelsQueried(List<ChannelScheduledMessages> channels) {
    final cids = {for (final it in channels) it.cid};
    final queried = channels.expand((it) => it.scheduledMessages).toList();
    final kept = _scheduledMessages.where((it) {
      return !cids.contains(it.cid) || it.isKeptOver(queried);
    });

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

  /// Updates each quote of [message] to this copy of it.
  ///
  /// Used when [message] is updated or deleted.
  void onQuotedMessageUpdated(Message message) {
    bool quotes(ScheduledMessage it) => it.message.quotedMessageId == message.id;

    if (!_scheduledMessages.any(quotes)) return;

    final updated = [
      for (final it in _scheduledMessages)
        if (quotes(it)) it.copyWith(message: it.message.copyWith(quotedMessage: message)) else it,
    ];

    _emit(state.copyWith(scheduledMessages: updated));
  }

  /// Marks the list as possibly incomplete, as the connection was lost.
  void onConnectionLost() => _emit(state.copyWith(hasLoadedAll: false));

  /// Forgets all of the scheduled messages, which are then no longer loaded.
  void clear() => _emit(const ScheduledMessageListState());

  /// Stops accepting changes to the [state].
  Future<void> dispose() => _state.close();

  // By scheduledAt, earliest first, then by ID.
  static int _byScheduledAt(ScheduledMessage a, ScheduledMessage b) {
    final byScheduledAt = a.scheduledAt.compareTo(b.scheduledAt);
    if (byScheduledAt != 0) return byScheduledAt;

    return a.id.compareTo(b.id);
  }

  // A scheduled copy wins over one not scheduled yet, then the later
  // [ScheduledMessage.updatedAt]. On a tie, a copy changed on this device wins
  // over one that wasn't.
  static ScheduledMessage _newer(
    ScheduledMessage original,
    ScheduledMessage updated,
  ) {
    if (original.remoteUpdatedAt == null) return updated;
    if (updated.remoteUpdatedAt == null) return original;
    if (original.updatedAt.isAfter(updated.updatedAt)) return original;
    if (updated.updatedAt.isAfter(original.updatedAt)) return updated;

    final isLocalChange = original.localUpdatedAt != null && updated.localUpdatedAt == null;
    return isLocalChange ? original : updated;
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

/// Where a [ScheduledMessage] is in the requests made on this device.
@internal
extension ScheduledMessageProgress on ScheduledMessage {
  /// Whether it is being scheduled for the first time.
  bool get isBeingScheduled => status == .preparingToSchedule && remoteCreatedAt == null;

  /// Whether scheduling it failed.
  bool get isSchedulingFailed => failure is ScheduledMessageSchedulingFailed;

  /// Whether saving a change to it failed, so it is still scheduled as it was.
  bool get isEditFailed => failure is ScheduledMessageUpdatingFailed;

  /// Whether it isn't scheduled yet: it is being scheduled, or scheduling it
  /// failed.
  bool get isNotScheduledYet => isBeingScheduled || isSchedulingFailed;

  /// Whether it holds a change not saved yet of a message already scheduled.
  bool get hasUnsavedChange {
    final isBeingChanged = status == .preparingToSchedule && remoteCreatedAt != null;
    return isBeingChanged || isEditFailed;
  }

  /// Whether it is kept when [incoming] replaces the list.
  ///
  /// It is when it isn't scheduled yet, or holds an unsaved change of one in
  /// [incoming].
  bool isKeptOver(List<ScheduledMessage> incoming) {
    if (isNotScheduledYet) return true;
    return hasUnsavedChange && incoming.any((it) => it.id == id);
  }
}
