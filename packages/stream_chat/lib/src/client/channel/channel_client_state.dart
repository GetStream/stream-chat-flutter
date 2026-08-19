// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/client/retry_queue.dart';
import 'package:stream_chat/src/core/util/utils.dart';
import 'package:stream_chat/stream_chat.dart';

/// The maximum time the incoming [Event.typingStart] event is valid before a
/// [Event.typingStop] event is emitted automatically.
const incomingTypingStartEventTimeout = 7;

/// The class that handles the state of the channel listening to the events.
class ChannelClientState {
  /// Creates a new instance listening to events and updating the state.
  ChannelClientState(
    this._channel,
    ChannelState channelState,
  ) {
    _retryQueue = RetryQueue(
      channel: _channel,
      logger: _client.detachedLogger(
        '🔄 (${generateHash([_channel.cid])})',
      ),
    );

    _channelStateController = BehaviorSubject.seeded(channelState);
    // Update the persistence storage with the seeded channel state.
    _debouncedUpdatePersistenceChannelState.call([channelState]);

    // region TYPING EVENTS
    _listenTypingEvents();
    // endregion

    // region MESSAGE EVENTS
    _listenMessageNew();
    _listenMessageDeleted();
    _listenMessageUpdated();
    // endregion

    // region DRAFT EVENTS
    _listenDraftUpdated();
    _listenDraftDeleted();
    // endregion

    // region REACTION EVENTS
    _listenReactionNew();
    _listenReactionUpdated();
    _listenReactionDeleted();
    // endregion

    // region POLL EVENTS
    _listenPollCreated();
    _listenPollUpdated();
    _listenPollClosed();
    _listenPollAnswerCasted();
    _listenPollVoteCasted();
    _listenPollVoteChanged();
    _listenPollAnswerRemoved();
    _listenPollVoteRemoved();
    // endregion

    // region READ EVENTS
    _listenReadEvents();
    // endregion

    // region CHANNEL EVENTS
    _listenChannelTruncated();
    _listenChannelUpdated();
    _listenChannelMessageCount();
    // endregion

    // region MEMBER EVENTS
    _listenMemberAdded();
    _listenMemberRemoved();
    _listenMemberUpdated();
    _listenMemberBanned();
    _listenMemberUnbanned();
    _listenUserMessagesDeleted();
    // endregion

    // region USER WATCHING EVENTS
    _listenUserStartWatching();
    _listenUserStopWatching();
    // endregion

    // region REMINDER EVENTS
    _listenReminderCreated();
    _listenReminderUpdated();
    _listenReminderDeleted();
    // endregion

    // region LOCATION EVENTS
    _listenLocationShared();
    _listenLocationUpdated();
    _listenLocationExpired();
    // endregion

    _startCleaningStaleTypingEvents();

    _startCleaningStalePinnedMessages();

    _startCleaningExpiredLocations();

    _listenChannelPushPreferenceUpdated();

    final persistenceClient = _client.chatPersistenceClient;
    persistenceClient
        ?.getChannelThreads(_channel.cid!)
        .then((threads) {
          // Load all the threads for the channel from the offline storage.
          if (threads.isNotEmpty) _threads = threads;
        })
        .then((_) => retryFailedMessages());
  }

  final Channel _channel;
  StreamChatClient get _client => _channel.client;
  final _subscriptions = CompositeSubscription();

  void _listenMemberAdded() {
    _subscriptions.add(
      _channel.on(EventType.memberAdded).listen((Event e) {
        final member = e.member!;
        final existingMembers = channelState.members ?? [];

        updateChannelState(
          channelState.copyWith(
            members: [...existingMembers, member],
          ),
        );
      }),
    );
  }

  void _listenMemberRemoved() {
    _subscriptions.add(
      _channel.on(EventType.memberRemoved).listen((Event e) {
        final user = e.user!;
        final existingRead = channelState.read ?? [];
        final existingMembers = channelState.members ?? [];

        updateChannelState(
          channelState.copyWith(
            read: [...existingRead.where((r) => r.user.id != user.id)],
            members: [...existingMembers.where((m) => m.userId != user.id)],
          ),
        );
      }),
    );
  }

  void _listenMemberUpdated() {
    _subscriptions
      // Listen to events containing member users
      ..add(
        _channel.on().listen(
          (event) {
            final user = event.user;
            if (user == null) return;

            final existingMembers = [...?channelState.members];
            final existingMembership = channelState.membership;

            // Return if the user is not a existing member of the channel.
            if (!existingMembers.any((m) => m.userId == user.id)) return;

            Member? maybeUpdateMemberUser(Member? existingMember) {
              if (existingMember == null) return null;
              if (existingMember.userId == user.id) {
                return existingMember.copyWith(user: user);
              }
              return existingMember;
            }

            updateChannelState(
              channelState.copyWith(
                membership: maybeUpdateMemberUser(existingMembership),
                members: [...existingMembers.map(maybeUpdateMemberUser).nonNulls],
              ),
            );
          },
        ),
      )
      // Listen to member updated events.
      ..add(
        _channel.on(EventType.memberUpdated).listen(
          (Event e) {
            final member = e.member!;
            final existingMembers = channelState.members ?? [];
            final existingMembership = channelState.membership;

            Member? maybeUpdateMember(Member? existingMember) {
              if (existingMember == null) return null;
              if (existingMember.userId == member.userId) return member;
              return existingMember;
            }

            updateChannelState(
              channelState.copyWith(
                membership: maybeUpdateMember(existingMembership),
                members: [...existingMembers.map(maybeUpdateMember).nonNulls],
              ),
            );
          },
        ),
      );
  }

  void _listenChannelUpdated() {
    _subscriptions.add(
      _channel.on(EventType.channelUpdated).listen((Event e) {
        final channel = e.channel!;
        updateChannelState(
          channelState.copyWith(
            channel: channelState.channel?.merge(channel),
            members: channel.members,
          ),
        );
      }),
    );
  }

  void _listenChannelMessageCount() {
    _subscriptions.add(
      _channel.on().listen(
        (Event e) {
          final messageCount = e.channelMessageCount;
          if (messageCount == null) return;

          updateChannelState(
            channelState.copyWith(
              channel: channelState.channel?.copyWith(
                messageCount: messageCount,
              ),
            ),
          );
        },
      ),
    );
  }

  void _listenChannelTruncated() {
    _subscriptions.add(
      _channel.on(EventType.channelTruncated, EventType.notificationChannelTruncated).listen((event) async {
        final channel = event.channel!;
        await _client.chatPersistenceClient?.deleteMessageByCid(channel.cid);
        truncate();
        if (event.message != null) {
          updateMessage(event.message!);
        }
      }),
    );
  }

  void _listenMemberBanned() {
    _subscriptions.add(
      _channel
          .on(EventType.userBanned)
          .where((it) => it.cid != null) // filters channel ban from app ban
          .listen(
            (event) async {
              final user = event.user!;
              final member = await _channel
                  .queryMembers(filter: Filter.equal('id', user.id))
                  .then((it) => it.members.first);

              _updateMember(member);
            },
          ),
    );
  }

  void _listenUserStartWatching() {
    _subscriptions.add(
      _channel.on(EventType.userWatchingStart).listen((event) {
        final watcher = event.user;
        if (watcher != null) {
          final existingWatchers = channelState.watchers;
          updateChannelState(
            channelState.copyWith(
              watchers: [
                watcher,
                ...?existingWatchers?.where((user) => user.id != watcher.id),
              ],
              watcherCount: event.watcherCount,
            ),
          );
        }
      }),
    );
  }

  void _listenUserStopWatching() {
    _subscriptions.add(
      _channel.on(EventType.userWatchingStop).listen((event) {
        final watcher = event.user;
        if (watcher != null) {
          final existingWatchers = channelState.watchers ?? const <User>[];
          _channelState = channelState.copyWith(
            watchers: existingWatchers.where((user) => user.id != watcher.id).toList(),
            watcherCount: event.watcherCount,
          );
        }
      }),
    );
  }

  void _listenMemberUnbanned() {
    _subscriptions.add(
      _channel
          .on(EventType.userUnbanned)
          .where((it) => it.cid != null) // filters channel ban from app ban
          .listen(
            (event) async {
              final user = event.user!;
              final member = await _channel
                  .queryMembers(filter: Filter.equal('id', user.id))
                  .then((it) => it.members.first);

              _updateMember(member);
            },
          ),
    );
  }

  void _updateMember(Member member) {
    final currentMembers = [...members];
    final memberIndex = currentMembers.indexWhere(
      (m) => m.userId == member.userId,
    );

    if (memberIndex == -1) return;
    currentMembers[memberIndex] = member;

    updateChannelState(
      channelState.copyWith(
        members: currentMembers,
      ),
    );
  }

  /// Flag which indicates if [ChannelClientState] contain latest/recent messages or not.
  ///
  /// This flag should be managed by UI sdks.
  ///
  /// When false, any new message received by WebSocket event
  /// [EventType.messageNew] will not be pushed on to message list.
  bool get isUpToDate => _isUpToDateController.value;

  set isUpToDate(bool isUpToDate) => _isUpToDateController.safeAdd(isUpToDate);

  /// [isUpToDate] flag count as a stream.
  Stream<bool> get isUpToDateStream => _isUpToDateController.stream;
  final _isUpToDateController = BehaviorSubject.seeded(true);

  /// The retry queue associated to this channel.
  late final RetryQueue _retryQueue;

  /// Retry failed message.
  Future<void> retryFailedMessages() async {
    final allMessages = [...messages, ...threads.values.flattened];
    final failedMessages = allMessages.where((it) => it.state.isFailed);

    if (failedMessages.isEmpty) return;
    _retryQueue.add(failedMessages);
  }

  /// Adds a failed [message] to the retry queue, scheduling it to be
  /// automatically resent once the connection is re-established.
  @internal
  void scheduleRetry(Message message) => _retryQueue.add([message]);

  Message? _findPollMessage(String pollId) {
    final message = messages.firstWhereOrNull((it) => it.pollId == pollId);
    if (message != null) return message;

    final threadMessage = threads.values.flattened.firstWhereOrNull((it) {
      return it.pollId == pollId;
    });

    return threadMessage;
  }

  void _listenPollCreated() {
    _subscriptions.add(
      _channel.on(EventType.pollCreated).listen((event) {
        final message = event.message;
        if (message == null || message.poll == null) return;

        return addNewMessage(message);
      }),
    );
  }

  void _listenPollUpdated() {
    _subscriptions.add(
      _channel.on(EventType.pollUpdated).listen((event) {
        final eventPoll = event.poll;
        if (eventPoll == null) return;

        final pollMessage = _findPollMessage(eventPoll.id);
        if (pollMessage == null) return;

        final oldPoll = pollMessage.poll;

        final latestAnswers = oldPoll?.latestAnswers ?? eventPoll.latestAnswers;
        final ownVotesAndAnswers = oldPoll?.ownVotesAndAnswers ?? eventPoll.ownVotesAndAnswers;

        final poll = eventPoll.copyWith(
          latestAnswers: latestAnswers,
          ownVotesAndAnswers: ownVotesAndAnswers,
        );

        final message = pollMessage.copyWith(poll: poll);
        updateMessage(message);
      }),
    );
  }

  void _listenPollClosed() {
    _subscriptions.add(
      _channel.on(EventType.pollClosed).listen((event) {
        final eventPoll = event.poll;
        if (eventPoll == null) return;

        final pollMessage = _findPollMessage(eventPoll.id);
        if (pollMessage == null) return;

        final oldPoll = pollMessage.poll;
        final poll = oldPoll?.copyWith(isClosed: true) ?? eventPoll;

        final message = pollMessage.copyWith(poll: poll);
        updateMessage(message);
      }),
    );
  }

  void _listenPollAnswerCasted() {
    _subscriptions.add(
      _channel.on(EventType.pollAnswerCasted).listen((event) {
        final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
        if (eventPoll == null || eventPollVote == null) return;

        final pollMessage = _findPollMessage(eventPoll.id);
        if (pollMessage == null) return;

        final oldPoll = pollMessage.poll;

        final latestAnswers = <String, PollVote>{
          for (final ans in oldPoll?.latestAnswers ?? []) ans.id: ans,
          eventPollVote.id!: eventPollVote,
        };

        final currentUserId = _client.state.currentUser?.id;
        final ownVotesAndAnswers = <String, PollVote>{
          for (final vote in oldPoll?.ownVotesAndAnswers ?? []) vote.id: vote,
          if (eventPollVote.userId == currentUserId) eventPollVote.id!: eventPollVote,
        };

        final poll = eventPoll.copyWith(
          latestAnswers: [...latestAnswers.values],
          ownVotesAndAnswers: [...ownVotesAndAnswers.values],
        );

        final message = pollMessage.copyWith(poll: poll);
        updateMessage(message);
      }),
    );
  }

  void _listenPollVoteCasted() {
    _subscriptions.add(
      _channel.on(EventType.pollVoteCasted).listen((event) {
        final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
        if (eventPoll == null || eventPollVote == null) return;

        final pollMessage = _findPollMessage(eventPoll.id);
        if (pollMessage == null) return;

        final oldPoll = pollMessage.poll;

        final latestAnswers = oldPoll?.latestAnswers ?? eventPoll.latestAnswers;
        final currentUserId = _client.state.currentUser?.id;
        final ownVotesAndAnswers = <String, PollVote>{
          for (final vote in oldPoll?.ownVotesAndAnswers ?? []) vote.id: vote,
          if (eventPollVote.userId == currentUserId) eventPollVote.id!: eventPollVote,
        };

        final poll = eventPoll.copyWith(
          latestAnswers: latestAnswers,
          ownVotesAndAnswers: [...ownVotesAndAnswers.values],
        );

        final message = pollMessage.copyWith(poll: poll);
        updateMessage(message);
      }),
    );
  }

  void _listenPollAnswerRemoved() {
    _subscriptions.add(
      _channel.on(EventType.pollAnswerRemoved).listen((event) {
        final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
        if (eventPoll == null || eventPollVote == null) return;

        final pollMessage = _findPollMessage(eventPoll.id);
        if (pollMessage == null) return;

        final oldPoll = pollMessage.poll;

        final latestAnswers = <String, PollVote>{
          for (final ans in oldPoll?.latestAnswers ?? []) ans.id: ans,
        }..remove(eventPollVote.id);

        final ownVotesAndAnswers = <String, PollVote>{
          for (final vote in oldPoll?.ownVotesAndAnswers ?? []) vote.id: vote,
        }..remove(eventPollVote.id);

        final poll = eventPoll.copyWith(
          latestAnswers: [...latestAnswers.values],
          ownVotesAndAnswers: [...ownVotesAndAnswers.values],
        );

        final message = pollMessage.copyWith(poll: poll);
        updateMessage(message);
      }),
    );
  }

  void _listenPollVoteRemoved() {
    _subscriptions.add(
      _channel.on(EventType.pollVoteRemoved).listen((event) {
        final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
        if (eventPoll == null || eventPollVote == null) return;

        final pollMessage = _findPollMessage(eventPoll.id);
        if (pollMessage == null) return;

        final oldPoll = pollMessage.poll;

        final latestAnswers = oldPoll?.latestAnswers ?? eventPoll.latestAnswers;
        final ownVotesAndAnswers = <String, PollVote>{
          for (final vote in oldPoll?.ownVotesAndAnswers ?? []) vote.id: vote,
        }..remove(eventPollVote.id);

        final poll = eventPoll.copyWith(
          latestAnswers: latestAnswers,
          ownVotesAndAnswers: [...ownVotesAndAnswers.values],
        );

        final message = pollMessage.copyWith(poll: poll);
        updateMessage(message);
      }),
    );
  }

  void _listenPollVoteChanged() {
    _subscriptions.add(
      _channel.on(EventType.pollVoteChanged).listen((event) {
        final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
        if (eventPoll == null || eventPollVote == null) return;

        final pollMessage = _findPollMessage(eventPoll.id);
        if (pollMessage == null) return;

        final oldPoll = pollMessage.poll;

        final latestAnswers = oldPoll?.latestAnswers ?? eventPoll.latestAnswers;
        final currentUserId = _client.state.currentUser?.id;
        final ownVotesAndAnswers = <String, PollVote>{
          for (final vote in oldPoll?.ownVotesAndAnswers ?? []) vote.id: vote,
          if (eventPollVote.userId == currentUserId) eventPollVote.id!: eventPollVote,
        };

        final poll = eventPoll.copyWith(
          latestAnswers: latestAnswers,
          ownVotesAndAnswers: [...ownVotesAndAnswers.values],
        );

        final message = pollMessage.copyWith(poll: poll);
        updateMessage(message);
      }),
    );
  }

  void _listenDraftUpdated() {
    _subscriptions.add(
      _channel.on(EventType.draftUpdated).listen((event) {
        final draft = event.draft;
        if (draft == null) return;

        return updateDraft(draft);
      }),
    );
  }

  void _listenDraftDeleted() {
    _subscriptions.add(
      _channel.on(EventType.draftDeleted).listen((event) {
        final draft = event.draft;
        if (draft == null) return;

        return deleteDraft(draft);
      }),
    );
  }

  void _listenReminderCreated() {
    _subscriptions.add(
      _channel.on(EventType.reminderCreated).listen((event) {
        final reminder = event.reminder;
        if (reminder == null) return;

        updateReminder(reminder);
      }),
    );
  }

  void _listenReminderUpdated() {
    _subscriptions.add(
      _channel.on(EventType.reminderUpdated).listen((event) {
        final reminder = event.reminder;
        if (reminder == null) return;

        updateReminder(reminder);
      }),
    );
  }

  void _listenReminderDeleted() {
    _subscriptions.add(
      _channel.on(EventType.reminderDeleted).listen((event) {
        final reminder = event.reminder;
        if (reminder == null) return;

        deleteReminder(reminder);
      }),
    );
  }

  /// Updates the [reminder] of the message if it exists.
  void updateReminder(MessageReminder reminder) {
    final messageId = reminder.messageId;
    // TODO: Improve once we have support for parentId in reminders.
    for (final message in [...messages, ...threads.values.flattened]) {
      if (message.id == messageId) {
        return updateMessage(
          message.copyWith(reminder: reminder),
        );
      }
    }
  }

  /// Deletes the [reminder] of the message if it exists.
  void deleteReminder(MessageReminder reminder) {
    final messageId = reminder.messageId;
    // TODO: Improve once we have support for parentId in reminders.
    for (final message in [...messages, ...threads.values.flattened]) {
      if (message.id == messageId) {
        return updateMessage(
          message.copyWith(reminder: null),
        );
      }
    }
  }

  Message? _findLocationMessage(String id) {
    final message = messages.firstWhereOrNull((it) {
      return it.sharedLocation?.messageId == id;
    });

    if (message != null) return message;

    final threadMessage = threads.values.flattened.firstWhereOrNull((it) {
      return it.sharedLocation?.messageId == id;
    });

    return threadMessage;
  }

  void _listenLocationShared() {
    _subscriptions.add(
      _channel.on(EventType.locationShared).listen((event) {
        final message = event.message;
        if (message == null || message.sharedLocation == null) return;

        return addNewMessage(message);
      }),
    );
  }

  void _listenLocationUpdated() {
    _subscriptions.add(
      _channel.on(EventType.locationUpdated).listen((event) {
        final location = event.message?.sharedLocation;
        if (location == null) return;

        final messageId = location.messageId;
        if (messageId == null) return;

        final oldMessage = _findLocationMessage(messageId);
        if (oldMessage == null) return;

        final updatedMessage = oldMessage.copyWith(sharedLocation: location);
        return updateMessage(updatedMessage);
      }),
    );
  }

  void _listenLocationExpired() {
    _subscriptions.add(
      _channel.on(EventType.locationExpired).listen((event) {
        final location = event.message?.sharedLocation;
        if (location == null) return;

        final messageId = location.messageId;
        if (messageId == null) return;

        final oldMessage = _findLocationMessage(messageId);
        if (oldMessage == null) return;

        final updatedMessage = oldMessage.copyWith(sharedLocation: location);
        return updateMessage(updatedMessage);
      }),
    );
  }

  void _listenReactionDeleted() {
    _subscriptions.add(
      _channel.on(EventType.reactionDeleted).listen((event) {
        final (eventReaction, eventMessage) = (event.reaction, event.message);
        if (eventReaction == null || eventMessage == null) return;

        final messageId = eventMessage.id;
        final parentId = eventMessage.parentId;

        for (final message in [...messages, ...?threads[parentId]]) {
          if (message.id == messageId) {
            final currentUserId = _channel.client.state.currentUser?.id;

            final currentMessage = switch (currentUserId) {
              final userId? when userId == eventReaction.userId => message.deleteMyReaction(
                reactionType: eventReaction.type,
              ),
              _ => message,
            };

            return updateMessage(
              eventMessage.copyWith(
                ownReactions: currentMessage.ownReactions,
              ),
            );
          }
        }
      }),
    );
  }

  void _listenReactionNew() {
    _subscriptions.add(
      _channel.on(EventType.reactionNew).listen((event) {
        final (eventReaction, eventMessage) = (event.reaction, event.message);
        if (eventReaction == null || eventMessage == null) return;

        final messageId = eventMessage.id;
        final parentId = eventMessage.parentId;

        for (final message in [...messages, ...?threads[parentId]]) {
          if (message.id == messageId) {
            final currentUserId = _channel.client.state.currentUser?.id;

            final currentMessage = switch (currentUserId) {
              final userId? when userId == eventReaction.userId => message.addMyReaction(eventReaction),
              _ => message,
            };

            return updateMessage(
              eventMessage.copyWith(
                ownReactions: currentMessage.ownReactions,
              ),
            );
          }
        }
      }),
    );
  }

  void _listenReactionUpdated() {
    _subscriptions.add(
      _channel.on(EventType.reactionUpdated).listen((event) {
        final (eventReaction, eventMessage) = (event.reaction, event.message);
        if (eventReaction == null || eventMessage == null) return;

        final messageId = eventMessage.id;
        final parentId = eventMessage.parentId;

        for (final message in [...messages, ...?threads[parentId]]) {
          if (message.id == messageId) {
            final currentUserId = _channel.client.state.currentUser?.id;

            final currentMessage = switch (currentUserId) {
              final userId? when userId == eventReaction.userId =>
                // reaction.updated is only called if enforce_unique is true
                message.addMyReaction(eventReaction, enforceUnique: true),
              _ => message,
            };

            return updateMessage(
              eventMessage.copyWith(
                ownReactions: currentMessage.ownReactions,
              ),
            );
          }
        }
      }),
    );
  }

  void _listenMessageUpdated() {
    _subscriptions.add(
      _channel.on(EventType.messageUpdated).listen((event) {
        final message = event.message;
        if (message == null) return;

        return updateMessage(message, upsert: false);
      }),
    );
  }

  void _listenMessageDeleted() {
    _subscriptions.add(
      _channel.on(EventType.messageDeleted).listen((event) {
        final hardDelete = event.hardDelete ?? false;

        final message = event.message!.copyWith(
          // TODO: Remove once deletedForMe is properly enriched on the backend.
          deletedForMe: event.deletedForMe,
        );

        // Decrement the locally-tracked unread count for hard-deleted
        // messages that would have counted as unread. Soft-deleted messages
        // keep their slot. Only applies to channels that track unread counts
        // locally (see [Channel.usesLocalUnreadCount]) — server-driven
        // channels get corrected counts from server read events instead.
        if (hardDelete && _channel.usesLocalUnreadCount && MessageRules.canCountAsUnread(message, _channel)) {
          unreadCount = math.max(0, unreadCount - 1);
        }

        return deleteMessage(message, hardDelete: hardDelete);
      }),
    );
  }

  void _listenMessageNew() {
    _subscriptions.add(
      _channel
          .on(
            EventType.messageNew,
            EventType.notificationMessageNew,
          )
          .listen((event) {
            final message = event.message;
            if (message == null) return;

            addNewMessage(message);

            // Only message.new carries a reliable watcher count;
            // notification.message_new targets non-watchers and reports 0.
            if (event.watcherCount case final watcherCount? when event.type == EventType.messageNew) {
              updateChannelState(
                channelState.copyWith(watcherCount: watcherCount),
              );
            }
          }),
    );
  }

  /// Adds a new message to the channel state and updates the unread count.
  void addNewMessage(Message message) {
    // A message not shown in the channel is necessarily a thread-only reply.
    final isThreadOnlyMessage = !_isShownInChannel(message);

    // Only add the message if the channel is upToDate or if the message is
    // a thread-only message.
    if (isUpToDate || isThreadOnlyMessage) updateMessage(message);

    // Otherwise, check if we can count the message as unread.
    if (MessageRules.canCountAsUnread(message, _channel)) {
      unreadCount += 1; // Increment unread count
    }

    _client.channelDeliveryReporter.submitForDelivery([_channel]);
  }

  /// Updates the [read] in the state if it exists. Adds it otherwise.
  void updateRead([Iterable<Read>? read]) {
    final existingReads = channelState.read ?? const <Read>[];
    final updatedReads = existingReads.merge(
      read,
      key: (read) => read.user.id,
    );

    updateChannelState(
      channelState.copyWith(
        read: updatedReads.toList(),
      ),
    );
  }

  /// Updates the [draft] in the channel state or the message if it exists.
  void updateDraft(Draft draft) {
    if (draft.parentId case final parentId?) {
      for (final message in messages) {
        if (message.id == parentId) {
          return updateMessage(message.copyWith(draft: draft));
        }
      }
    }

    updateChannelState(
      channelState.copyWith(
        draft: draft,
      ),
    );
  }

  /// Deletes the [draft] from the state if it exists.
  void deleteDraft(Draft draft) async {
    // Delete the draft from the persistence client.
    await _client.chatPersistenceClient?.deleteDraftMessageByCid(
      draft.channelCid,
      parentId: draft.parentId,
    );

    if (draft.parentId case final parentId?) {
      for (final message in messages) {
        if (message.id == parentId) {
          return updateMessage(
            message.copyWith(draft: null),
          );
        }
      }
    }

    updateChannelState(
      channelState.copyWith(
        draft: null,
      ),
    );
  }

  /// Updates the [message] in the state.
  ///
  /// Reconciles via `Message.updateWith`, so locally-known enrichment
  /// (poll, sharedLocation, ownReactions, nested quotedMessage) is
  /// preserved when [message] omits those fields. Use [replaceMessage]
  /// for paths that need a strict overwrite.
  ///
  /// When [upsert] is `true` (the default) and [message] isn't already in
  /// the state, it's added. When `false`, an unknown [message] is skipped
  /// and the state is left unchanged; only a message already loaded in the
  /// state is updated.
  void updateMessage(Message message, {bool upsert = true}) => _updateMessages([message], upsert: upsert);

  /// Replaces the [message] in the state if it exists, no-op otherwise.
  ///
  /// Unlike [updateMessage], this does **not** merge with the existing
  /// state — [message] is used as-is. Useful for local rollbacks of an
  /// optimistic update, where the caller has the full prior snapshot and
  /// doesn't want the merge falling back to the optimistic values.
  void replaceMessage(Message message) => _updateMessages([message], update: _replaceUpdate);

  // Default `update` for [_updateMessages]: merge incoming with the
  // locally-known message via `Message.updateWith`, preserving enrichment
  // the server may strip on partial payloads.
  static Message _mergeUpdate(Message original, Message updated) => original.updateWith(updated);

  // Replace `update` for [_updateMessages]: take the incoming as-is. Used
  // by local rollback paths.
  static Message _replaceUpdate(Message _, Message updated) => updated;

  /// Cleans up all the stale error messages which requires no action.
  void cleanUpStaleErrorMessages() {
    final errorMessages = messages.where((message) {
      return message.isError && !message.isBounced;
    });

    if (errorMessages.isEmpty) return;
    return _removeMessages(errorMessages);
  }

  /// Remove a [message] from this [channelState].
  void removeMessage(Message message) => _removeMessages([message]);

  /// Removes/Updates the [message] based on the [hardDelete] value.
  void deleteMessage(Message message, {bool hardDelete = false}) {
    return _deleteMessages([message], hardDelete: hardDelete);
  }

  void _listenReadEvents() {
    _subscriptions
      ..add(
        _channel.on(EventType.messageRead, EventType.notificationMarkRead).listen(
          (event) {
            // Skip handling the event if delivered for a thread
            if (event.thread != null) return;

            final user = event.user;
            if (user == null) return;

            final currentRead = userReadOf(userId: user.id);

            final updatedRead = Read(
              user: user,
              lastRead: event.createdAt,
              unreadMessages: 0, // Reset unread count
              lastReadMessageId: event.lastReadMessageId,
              // Preserve delivery info as it's not part of the read event.
              lastDeliveredAt: currentRead?.lastDeliveredAt,
              lastDeliveredMessageId: currentRead?.lastDeliveredMessageId,
            );

            updateRead([updatedRead]);

            // If the read event is from the current user, reconcile the
            // channel delivery status with the updated read state.
            final currentUser = _client.state.currentUser;
            if (event.isFromUser(userId: currentUser?.id)) {
              _client.channelDeliveryReporter.reconcileDelivery([_channel]);
            }
          },
        ),
      )
      ..add(
        _channel.on(EventType.notificationMarkUnread).listen(
          (event) {
            final user = event.user;
            if (user == null) return;

            final currentRead = userReadOf(userId: user.id);

            final updatedRead = Read(
              user: user,
              lastRead: event.lastReadAt!,
              unreadMessages: event.unreadMessages,
              lastReadMessageId: event.lastReadMessageId,
              // Preserve delivery info as it's not part of the read event.
              lastDeliveredAt: currentRead?.lastDeliveredAt,
              lastDeliveredMessageId: currentRead?.lastDeliveredMessageId,
            );

            return updateRead([updatedRead]);
          },
        ),
      )
      ..add(
        _channel.on(EventType.messageDelivered).listen(
          (event) {
            final user = event.user;
            if (user == null) return;

            final currentRead = userReadOf(userId: user.id);
            final never = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

            final updatedRead = Read(
              user: user,
              lastDeliveredAt: event.lastDeliveredAt,
              lastDeliveredMessageId: event.lastDeliveredMessageId,
              // Preserve read info as it's not part of the delivery event.
              lastRead: currentRead?.lastRead ?? never,
              unreadMessages: currentRead?.unreadMessages,
              lastReadMessageId: currentRead?.lastReadMessageId,
            );

            updateRead([updatedRead]);

            // If the delivered event is from the current user, reconcile
            // the channel delivery with the updated read state.
            final currentUser = _client.state.currentUser;
            if (event.isFromUser(userId: currentUser?.id)) {
              _client.channelDeliveryReporter.reconcileDelivery([_channel]);
            }
          },
        ),
      );
  }

  /// Channel message list.
  List<Message> get messages => _channelState.messages ?? <Message>[];

  /// Channel message list as a stream.
  Stream<List<Message>> get messagesStream =>
      channelStateStream.map((cs) => cs.messages ?? <Message>[]).distinct(const ListEquality().equals);

  /// Channel pinned message list.
  List<Message> get pinnedMessages => _channelState.pinnedMessages ?? <Message>[];

  /// Channel pinned message list as a stream.
  Stream<List<Message>> get pinnedMessagesStream =>
      channelStateStream.map((cs) => cs.pinnedMessages ?? <Message>[]).distinct(const ListEquality().equals);

  /// Channel pending message list.
  List<Message> get pendingMessages => _channelState.pendingMessages ?? <Message>[];

  /// Channel pending message list as a stream.
  Stream<List<Message>> get pendingMessagesStream =>
      channelStateStream.map((cs) => cs.pendingMessages ?? <Message>[]).distinct(const ListEquality().equals);

  /// Get channel last message.
  Message? get lastMessage => messages.lastOrNull;

  /// Get channel last message as a stream.
  Stream<Message?> get lastMessageStream {
    return messagesStream.map((messages) => messages.lastOrNull);
  }

  /// Channel members list.
  List<Member> get members =>
      (_channelState.members ?? <Member>[]).map((e) => e.copyWith(user: _client.state.users[e.user!.id])).toList();

  /// Channel members list as a stream.
  Stream<List<Member>> get membersStream =>
      CombineLatestStream.combine2<List<Member?>?, Map<String?, User?>, List<Member>>(
        channelStateStream.map((cs) => cs.members),
        _client.state.usersStream,
        (members, users) => [...?members?.map((e) => e!.copyWith(user: users[e.user!.id]))],
      ).distinct(const ListEquality().equals);

  /// Channel watcher count.
  int? get watcherCount => _channelState.watcherCount;

  /// Channel watcher count as a stream.
  Stream<int?> get watcherCountStream => channelStateStream.map((cs) => cs.watcherCount);

  /// Channel watchers list.
  List<User> get watchers => (_channelState.watchers ?? <User>[]).map((e) => _client.state.users[e.id] ?? e).toList();

  /// Channel watchers list as a stream.
  Stream<List<User>> get watchersStream => CombineLatestStream.combine2<List<User>?, Map<String?, User?>, List<User>>(
    channelStateStream.map((cs) => cs.watchers),
    _client.state.usersStream,
    (watchers, users) => [...?watchers?.map((e) => users[e.id] ?? e)],
  ).distinct(const ListEquality().equals);

  /// Channel active live locations.
  List<Location> get activeLiveLocations {
    return _channelState.activeLiveLocations ?? <Location>[];
  }

  /// Channel active live locations as a stream.
  Stream<List<Location>> get activeLiveLocationsStream =>
      channelStateStream.map((cs) => cs.activeLiveLocations ?? <Location>[]).distinct(const ListEquality().equals);

  /// Channel draft.
  Draft? get draft => _channelState.draft;

  /// Channel draft as a stream.
  Stream<Draft?> get draftStream {
    return channelStateStream.map((cs) => cs.draft).distinct();
  }

  /// Channel member for the current user.
  Member? get currentUserMember => members.firstWhereOrNull(
    (m) => m.user?.id == _client.state.currentUser?.id,
  );

  /// Channel role for the current user
  String? get currentUserChannelRole => currentUserMember?.channelRole;

  /// Channel read list.
  List<Read> get read => _channelState.read ?? <Read>[];

  /// Channel read list as a stream.
  Stream<List<Read>> get readStream =>
      channelStateStream.map((cs) => cs.read ?? <Read>[]).distinct(const ListEquality().equals);

  /// Channel read for the logged in user.
  Read? get currentUserRead {
    final currentUser = _client.state.currentUser;
    return userReadOf(userId: currentUser?.id);
  }

  /// Channel read for the logged in user as a stream.
  ///
  /// Re-subscribes only when the user id actually changes; null still
  /// propagates downstream so consumers see the logged-out transition.
  Stream<Read?> get currentUserReadStream {
    final currentUserId = _client.state.currentUserStream.map((it) => it?.id).distinct();
    return currentUserId.switchMap((id) => userReadStreamOf(userId: id)).distinct();
  }

  /// Unread count getter as a stream.
  Stream<int> get unreadCountStream => currentUserReadStream.map((read) => read?.unreadMessages ?? 0).distinct();

  /// Unread count getter.
  int get unreadCount => currentUserRead?.unreadMessages ?? 0;

  /// Setter for unread count.
  set unreadCount(int count) {
    final currentUser = _client.state.currentUser;
    if (currentUser == null) return;

    var existingUserRead = currentUserRead;
    if (existingUserRead == null) {
      final lastMessageAt = _channelState.channel?.lastMessageAt;
      existingUserRead = Read(
        user: currentUser,
        lastRead: lastMessageAt ?? DateTime.now(),
      );
    }

    return updateRead([existingUserRead.copyWith(unreadMessages: count)]);
  }

  /// Marks the channel as read locally, without making a network request.
  ///
  /// Used for channels that track unread counts locally (see
  /// [Channel.usesLocalUnreadCount]), since the server rejects the mark-read
  /// endpoint for channels that have read events disabled.
  ///
  /// [messageId] only sets the resulting [Read.lastReadMessageId]; it does not
  /// narrow which messages stay unread. The count always drops to zero and
  /// [Read.lastRead] is always `now`, so messages newer than [messageId] are
  /// marked read as well. This differs from the server, which recomputes the
  /// count as the number of messages after [messageId], and from
  /// [markUnreadLocally], which does recompute from the locally-known
  /// messages. Callers that need a partial boundary should use
  /// [markUnreadLocally] instead.
  void markReadLocally({String? messageId}) {
    final currentUser = _client.state.currentUser;
    if (currentUser == null) return;

    final now = DateTime.now();
    final lastReadMessageId = messageId ?? messages.lastOrNull?.id;

    final existingUserRead = currentUserRead;
    updateRead([
      Read(
        user: currentUser,
        lastRead: now,
        lastReadMessageId: lastReadMessageId,
        lastDeliveredAt: existingUserRead?.lastDeliveredAt,
        lastDeliveredMessageId: existingUserRead?.lastDeliveredMessageId,
      ),
    ]);

    // Read supersedes delivered, so drop any pending delivery candidate the
    // new read boundary just made ineligible. `delivery_events` is configured
    // independently of `read_events`, so a channel tracking unread counts
    // locally can still have delivery receipts enabled. Mirrors what the
    // `message.read` event listener does for server-driven channels.
    _client.channelDeliveryReporter.reconcileDelivery([_channel]);
  }

  /// Marks the channel as unread locally, without making a network request.
  ///
  /// [lastRead] and [lastReadMessageId] define the new read boundary: any
  /// locally-known message that is still eligible per
  /// [MessageRules.canCountAsUnread] once this boundary is applied is counted
  /// as unread.
  ///
  /// Used for channels that track unread counts locally (see
  /// [Channel.usesLocalUnreadCount]), since the server rejects the
  /// mark-unread endpoint for channels that have read events disabled.
  void markUnreadLocally({
    required DateTime lastRead,
    String? lastReadMessageId,
  }) {
    final currentUser = _client.state.currentUser;
    if (currentUser == null) return;

    final existingUserRead = currentUserRead;

    // Apply the new read boundary first so `MessageRules.canCountAsUnread`
    // (which reads `channel.state?.currentUserRead`) evaluates against it.
    updateRead([
      Read(
        user: currentUser,
        lastRead: lastRead,
        lastReadMessageId: lastReadMessageId,
        lastDeliveredAt: existingUserRead?.lastDeliveredAt,
        lastDeliveredMessageId: existingUserRead?.lastDeliveredMessageId,
      ),
    ]);

    // Recompute the unread count from the locally-known messages now that
    // the boundary above is in effect.
    final unread = messages.where((it) => MessageRules.canCountAsUnread(it, _channel)).length;

    unreadCount = unread;
  }

  /// Counts the number of unread messages mentioning the current user.
  ///
  /// **NOTE**: The method relies on the [Channel.messages] list and doesn't do
  /// any API call. Therefore, the count might be not reliable as it relies on
  /// the local data.
  int countUnreadMentions() {
    final currentUserId = _client.state.currentUser?.id;

    var count = 0;
    for (final message in messages) {
      if (!MessageRules.canCountAsUnread(message, _channel)) continue;
      if (!message.mentionedUsers.any((it) => it.id == currentUserId)) continue;

      count++;
    }

    return count;
  }

  /// Delete all channel messages.
  void truncate() {
    _channelState = _channelState.copyWith(
      messages: [],
    );
  }

  /// Drops the oldest messages, keeping at most [maxMessages].
  ///
  /// No-op when [maxMessages] is non-positive, when the current count is
  /// already within the limit, or when [isUpToDate] is `false`.
  ///
  /// Prefer `StreamChannel.pruneOldest` when a [StreamChannel] is present:
  /// it also resets the widget-layer "top reached" marker so top-pagination
  /// can resume. Calling this directly leaves that marker untouched.
  void pruneOldest(int maxMessages) {
    if (maxMessages <= 0) return;
    if (!isUpToDate) return;

    final current = messages;
    if (current.length <= maxMessages) return;

    final pruned = current.sublist(current.length - maxMessages);
    _channelState = _channelState.copyWith(messages: pruned);
  }

  /// Update channelState with updated information.
  void updateChannelState(ChannelState updatedState) {
    final newMessages = messages.mergeSorted(
      updatedState.messages,
      key: (message) => message.id,
      update: _mergeUpdate,
      compare: _sortByCreatedAt,
    );

    final watchers = _channelState.watchers ?? const <User>[];
    final newWatchers = watchers.merge(
      updatedState.watchers,
      key: (watcher) => watcher.id,
    );

    final reads = _channelState.read ?? const <Read>[];
    final newReads = reads.merge(
      updatedState.read,
      key: (read) => read.user.id,
    );

    _channelState = _channelState.copyWith(
      messages: newMessages,
      channel: _channelState.channel?.merge(updatedState.channel),
      watchers: newWatchers.toList(),
      watcherCount: updatedState.watcherCount,
      members: updatedState.members,
      membership: updatedState.membership,
      read: newReads.toList(),
      draft: updatedState.draft,
      pinnedMessages: updatedState.pinnedMessages,
      pendingMessages: updatedState.pendingMessages,
      pushPreferences: updatedState.pushPreferences,
      activeLiveLocations: updatedState.activeLiveLocations,
    );
  }

  /// Applies a [remoteState] received from the server or offline storage
  /// (e.g. a `query`/`watch` response), merging it into local state.
  ///
  /// Unlike [updateChannelState], this preserves the current user's
  /// locally-tracked read state for channels that track unread counts
  /// on-device (see [Channel.usesLocalUnreadCount]) — their `lastRead`,
  /// `lastReadMessageId`, and `unreadMessages` are kept as-is instead of
  /// being overwritten by the remote payload; only delivery fields are
  /// still applied from it.
  ///
  /// Call this instead of [updateChannelState] whenever [remoteState]
  /// genuinely comes from the network or offline storage.
  void updateChannelStateFromServer(ChannelState remoteState) {
    updateChannelState(_preserveLocalUnreadState(remoteState));
  }

  /// Rewrites the current user's [Read] in [remoteState], if present, to
  /// keep the locally-tracked `lastRead` / `lastReadMessageId` /
  /// `unreadMessages` while still adopting the remote delivery fields.
  ///
  /// No-op unless [Channel.usesLocalUnreadCount] is enabled and a local read
  /// already exists for the current user.
  ChannelState _preserveLocalUnreadState(ChannelState remoteState) {
    if (!_channel.usesLocalUnreadCount) return remoteState;

    final localRead = currentUserRead;
    final remoteReads = remoteState.read;
    if (localRead == null || remoteReads == null) return remoteState;

    final currentUserId = localRead.user.id;
    final preservedReads = remoteReads.map((read) {
      if (read.user.id != currentUserId) return read;
      return localRead.copyWith(
        lastDeliveredAt: read.lastDeliveredAt,
        lastDeliveredMessageId: read.lastDeliveredMessageId,
      );
    });

    return remoteState.copyWith(read: preservedReads.toList());
  }

  int _sortByCreatedAt(Message a, Message b) => a.createdAt.compareTo(b.createdAt);

  /// The channel state related to this client.
  ChannelState get _channelState => _channelStateController.value;

  /// The channel state related to this client as a stream.
  Stream<ChannelState> get channelStateStream => _channelStateController.stream;

  /// The channel state related to this client.
  ChannelState get channelState => _channelStateController.value;
  late BehaviorSubject<ChannelState> _channelStateController;

  late final _debouncedUpdatePersistenceChannelState = debounce(
    (ChannelState state) {
      final persistenceClient = _client.chatPersistenceClient;
      return persistenceClient?.updateChannelState(state);
    },
    const Duration(seconds: 1),
  );

  set _channelState(ChannelState v) {
    _channelStateController.safeAdd(v);
    _debouncedUpdatePersistenceChannelState.call([v]);
  }

  late final _debouncedUpdatePersistenceChannelThreads = debounce(
    (Map<String, List<Message>> threads) async {
      final channelCid = _channel.cid;
      if (channelCid == null) return;

      final persistenceClient = _client.chatPersistenceClient;
      return persistenceClient?.updateChannelThreads(channelCid, threads);
    },
    const Duration(seconds: 1),
  );

  /// The channel threads related to this channel.
  Map<String, List<Message>> get threads => {..._threadsController.value};

  /// The channel threads related to this channel as a stream.
  Stream<Map<String, List<Message>>> get threadsStream => _threadsController;
  final _threadsController = BehaviorSubject.seeded(<String, List<Message>>{});
  set _threads(Map<String, List<Message>> threads) {
    _threadsController.safeAdd(threads);
    _debouncedUpdatePersistenceChannelThreads.call([threads]);
  }

  /// Clears all the replies in the thread identified by [parentId].
  void clearThread(String parentId) {
    final updatedThreads = {
      ...threads,
      parentId: <Message>[],
    };

    _threads = updatedThreads;
  }

  /// Update threads with updated information about messages.
  void updateThreadInfo(String parentId, List<Message> messages) {
    final updatedThreads = {...threads};

    final threadMessages = updatedThreads[parentId] ?? <Message>[];
    final updatedThreadMessages = _mergeMessagesIntoExisting(
      existing: threadMessages,
      toMerge: messages.where((it) => it.id != parentId),
    );

    // Update the thread with the modified message list.
    updatedThreads[parentId] = updatedThreadMessages.toList();

    _threads = updatedThreads;
  }

  Draft? _getThreadDraft(String parentId, List<Message>? messages) {
    return messages?.firstWhereOrNull((it) => it.id == parentId)?.draft;
  }

  /// Draft for a specific thread identified by [parentId].
  Draft? threadDraft(String parentId) => _getThreadDraft(parentId, messages);

  /// Stream of draft for a specific thread identified by [parentId].
  ///
  /// This stream emits a new value whenever the draft associated with the
  /// specified thread is updated or removed.
  Stream<Draft?> threadDraftStream(String parentId) =>
      channelStateStream.map((cs) => _getThreadDraft(parentId, cs.messages)).distinct();

  /// Channel related typing users stream.
  Stream<Map<User, Event>> get typingEventsStream => _typingEventsController.stream;

  /// Channel related typing users last value.
  Map<User, Event> get typingEvents => _typingEventsController.value;
  final _typingEventsController = BehaviorSubject.seeded(<User, Event>{});

  void _listenTypingEvents() {
    _subscriptions
      ..add(
        _channel.on(EventType.typingStart).listen(
          (event) {
            final user = event.user;
            if (user == null) return;

            final currentUser = _client.state.currentUser;
            if (event.isFromUser(userId: currentUser?.id)) return;

            final events = {...typingEvents, user: event};
            _typingEventsController.safeAdd(events);
          },
        ),
      )
      ..add(
        _channel.on(EventType.typingStop).listen(
          (event) {
            final user = event.user;
            if (user == null) return;

            final currentUser = _client.state.currentUser;
            if (event.isFromUser(userId: currentUser?.id)) return;

            final events = {...typingEvents}..remove(user);
            _typingEventsController.safeAdd(events);
          },
        ),
      );
  }

  Timer? _staleTypingEventsCleanerTimer;

  // Checks and removes stale typing events that were not explicitly stopped by
  // the sender due to technical difficulties. e.g. process death, loss of
  // Internet connection or custom implementation.
  void _startCleaningStaleTypingEvents() {
    _staleTypingEventsCleanerTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        final now = DateTime.now();
        typingEvents.forEach((user, event) {
          if (now.difference(event.createdAt).inSeconds > incomingTypingStartEventTimeout) {
            _client.handleEvent(
              Event(
                type: EventType.typingStop,
                user: user,
                cid: _channel.cid,
                parentId: event.parentId,
              ),
            );
          }
        });
      },
    );
  }

  Timer? _stalePinnedMessagesCleanerTimer;

  // Checks and removes stale pinned messages that are not valid anymore.
  void _startCleaningStalePinnedMessages() {
    _stalePinnedMessagesCleanerTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        final now = DateTime.now();
        var expiredMessages = channelState.pinnedMessages?.where((m) => m.pinExpires?.isBefore(now) == true).toList();
        if (expiredMessages != null && expiredMessages.isNotEmpty) {
          expiredMessages = expiredMessages
              .map(
                (m) => m.copyWith(
                  pinExpires: null,
                  pinned: false,
                ),
              )
              .toList();

          updateChannelState(
            _channelState.copyWith(
              pinnedMessages: pinnedMessages.where(_pinIsValid).toList(),
              messages: expiredMessages,
            ),
          );
        }
      },
    );
  }

  Timer? _staleLiveLocationsCleanerTimer;
  void _startCleaningExpiredLocations() {
    _staleLiveLocationsCleanerTimer?.cancel();
    _staleLiveLocationsCleanerTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        final currentUserId = _client.state.currentUser?.id;
        if (currentUserId == null) return;

        final expired = activeLiveLocations.where((it) => it.isExpired);
        if (expired.isEmpty) return;

        for (final sharedLocation in expired) {
          // Skip if the location is shared by the current user,
          // as we are already handling them in the client.
          if (sharedLocation.userId == currentUserId) continue;

          final lastUpdatedAt = DateTime.timestamp();
          final locationExpiredEvent = Event(
            type: EventType.locationExpired,
            cid: sharedLocation.channelCid,
            message: Message(
              id: sharedLocation.messageId,
              updatedAt: lastUpdatedAt,
              sharedLocation: sharedLocation.copyWith(
                updatedAt: lastUpdatedAt,
              ),
            ),
          );

          _client.handleEvent(locationExpiredEvent);
        }
      },
    );
  }

  // Listens to channel push preference update events and updates the state
  void _listenChannelPushPreferenceUpdated() {
    _subscriptions.add(
      _channel.on(EventType.channelPushPreferenceUpdated).listen(
        (event) {
          final pushPreferences = event.channelPushPreference;
          if (pushPreferences == null) return;

          updateChannelState(
            channelState.copyWith(
              pushPreferences: pushPreferences,
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteMessagesFromUser({
    required String userId,
    bool hardDelete = false,
    DateTime? deletedAt,
  }) async {
    // Delete messages from persistence.
    //
    // Note: We perform this operation separately even though [_removeMessages]
    // already handles it as we need to delete all messages from the user, not
    // only the ones present in the current state.
    final persistence = _channel.client.chatPersistenceClient;
    await persistence?.deleteMessagesFromUser(
      userId: userId,
      cid: _channel.cid,
      hardDelete: hardDelete,
      deletedAt: deletedAt,
    );

    // Gather messages to delete from state.
    final userMessages = <String, Message>{};
    for (final message in [...messages, ...threads.values.flattened]) {
      if (message.user?.id != userId) continue;
      userMessages[message.id] = message.copyWith(
        type: MessageType.deleted,
        deletedAt: deletedAt ?? DateTime.now(),
        state: switch (hardDelete) {
          true => MessageState.hardDeleted,
          false => MessageState.softDeleted,
        },
      );
    }

    final messagesToDelete = userMessages.values;
    return _deleteMessages(messagesToDelete, hardDelete: hardDelete);
  }

  void _deleteMessages(
    Iterable<Message> messages, {
    bool hardDelete = false,
  }) {
    if (messages.isEmpty) return;

    if (hardDelete) return _removeMessages(messages);
    return _updateMessages(messages, upsert: false);
  }

  void _updateMessages(
    Iterable<Message> messages, {
    Message Function(Message original, Message updated) update = _mergeUpdate,
    bool upsert = true,
  }) {
    if (messages.isEmpty) return;

    _updateThreadMessages(messages, update: update, upsert: upsert);
    _updateChannelMessages(messages, update: update, upsert: upsert);
    _updatePinnedMessages(messages, update: update);
    _updateActiveLiveLocations(messages);
  }

  void _updateThreadMessages(
    Iterable<Message> messages, {
    Message Function(Message original, Message updated) update = _mergeUpdate,
    bool upsert = true,
  }) {
    if (messages.isEmpty) return;

    // Group messages by parentId so each thread merge only sees its own
    // replies — passing the full batch to every thread would leak replies
    // across thread boundaries (the merge dedups by id, not by parentId).
    final messagesByThread = <String, List<Message>>{};
    for (final m in messages) {
      if (m.parentId case final parentId?) (messagesByThread[parentId] ??= []).add(m);
    }

    // If there are no affected threads, return early.
    if (messagesByThread.isEmpty) return;

    final updatedThreads = {...threads};
    for (final MapEntry(key: thread, :value) in messagesByThread.entries) {
      final existingThreadMessages = updatedThreads[thread];

      // Don't create a phantom entry for a thread that wasn't loaded: with
      // `upsert: false` an out-of-window reply is dropped, so there's nothing
      // to merge. Writing it back would make `threads.containsKey(parentId)`
      // report a thread that was never paged in.
      if (existingThreadMessages == null && !upsert) continue;

      final threadMessages = existingThreadMessages ?? <Message>[];
      final updatedThreadMessages = _mergeMessagesIntoExisting(
        existing: threadMessages,
        toMerge: value,
        update: update,
        upsert: upsert,
      );

      // Update the thread with the modified message list.
      updatedThreads[thread] = updatedThreadMessages.toList();
    }

    // Update the threads map.
    _threads = updatedThreads;
  }

  void _updateChannelMessages(
    Iterable<Message> messages, {
    Message Function(Message original, Message updated) update = _mergeUpdate,
    bool upsert = true,
  }) {
    if (messages.isEmpty) return;

    // Only messages shown in the channel are affected.
    final affectedMessages = messages.where(_isShownInChannel);

    // If there are no affected messages, return early.
    if (affectedMessages.isEmpty) return;

    final channelMessages = [...this.messages];
    final updatedChannelMessages = _mergeMessagesIntoExisting(
      existing: channelMessages,
      toMerge: affectedMessages,
      update: update,
      upsert: upsert,
    );

    // Calculate the new last message at time.
    var lastMessageAt = _channelState.channel?.lastMessageAt;
    for (final message in affectedMessages) {
      if (MessageRules.canUpdateChannelLastMessageAt(message, _channel)) {
        lastMessageAt = [lastMessageAt, message.createdAt].nonNulls.max;
      }
    }

    _channelState = _channelState.copyWith(
      messages: updatedChannelMessages.toList(),
      channel: _channelState.channel?.copyWith(lastMessageAt: lastMessageAt),
    );
  }

  void _updatePinnedMessages(
    Iterable<Message> messages, {
    Message Function(Message original, Message updated) update = _mergeUpdate,
  }) {
    if (messages.isEmpty) return;

    // No-op fast path: nothing was pinned, and nothing in the batch is
    // becoming pinned — skip the merge/copyWith churn that would otherwise
    // land right back on an empty `pinnedMessages` list.
    if (pinnedMessages.isEmpty && messages.every((m) => !m.pinned)) return;

    final updatedPinnedMessages = _mergePinnedMessagesIntoExisting(
      existing: pinnedMessages,
      toMerge: messages,
      update: update,
    );

    _channelState = _channelState.copyWith(
      pinnedMessages: updatedPinnedMessages.toList(),
    );
  }

  void _updateActiveLiveLocations(Iterable<Message> messages) {
    if (messages.isEmpty) return;

    final activeLiveLocations = [...this.activeLiveLocations];
    final updatedActiveLiveLocations = _mergeActiveLocationsIntoExisting(
      existing: activeLiveLocations,
      toMerge: messages,
    );

    _channelState = _channelState.copyWith(
      activeLiveLocations: updatedActiveLiveLocations.toList(),
    );
  }

  Iterable<Location> _mergeActiveLocationsIntoExisting({
    required Iterable<Location> existing,
    required Iterable<Message> toMerge,
  }) {
    if (toMerge.isEmpty) return existing;

    final mergedLocations = existing.mergeFrom(
      toMerge,
      key: (it) => (it.userId, it.channelCid, it.createdByDeviceId),
      value: (message) => message.sharedLocation,
      update: (original, updated) => updated,
    );

    final toUpdateMap = {for (final m in toMerge) m.id: m};
    final updatedLocations = mergedLocations.where((it) {
      // Remove the location if it's expired.
      if (it.isExpired) return false;

      final updatedMessage = toUpdateMap[it.messageId];
      // Remove the location if the attached message is deleted.
      if (updatedMessage?.isDeleted == true) return false;

      return true;
    });

    return updatedLocations;
  }

  Iterable<Message> _mergePinnedMessagesIntoExisting({
    required Iterable<Message> existing,
    required Iterable<Message> toMerge,
    Message Function(Message original, Message updated) update = _mergeUpdate,
  }) {
    return _mergeMessagesIntoExisting(
      existing: existing,
      toMerge: toMerge,
      update: update,
    ).where(_pinIsValid);
  }

  Iterable<Message> _mergeMessagesIntoExisting({
    required Iterable<Message> existing,
    required Iterable<Message> toMerge,
    Message Function(Message original, Message updated) update = _mergeUpdate,
    bool upsert = true,
  }) {
    if (toMerge.isEmpty) return existing;

    // [update] decides whether each pair is reconciled (default — see
    // `_mergeUpdate`) or replaced (`_replaceUpdate`, used by local rollback
    // paths that don't want enrichment fallback to keep optimistic values).
    //
    // [upsert] controls whether ids not already in [existing] are inserted.
    // Event-driven paths (`message.updated`, `message.deleted` soft) pass
    // `upsert: false` so an out-of-window message isn't dropped into a gap
    // between the loaded slice and history the client hasn't paged in yet.
    final existingList = existing is List<Message> ? existing : existing.toList();
    var toMergeList = toMerge is List<Message> ? toMerge : toMerge.toList();

    // Single-message fast path. The hot ingest path (server echoes, edits,
    // reactions, read receipts) always lands here, and `lastIndexWhere` +
    // `sortedUpsertAt` skips the O(N) keymap build that the two-pointer
    // merge would otherwise do up front.
    if (toMergeList.length == 1) {
      final message = toMergeList.first;
      final oldIndex = existingList.lastIndexWhere((it) => it.id == message.id);

      // upsert: false — skip update if message is not loaded
      if (oldIndex == -1 && !upsert) return existingList;

      final resolved = oldIndex == -1 ? message : update(existingList[oldIndex], message);

      final mergedMessages = existingList.sortedUpsertAt(
        oldIndex,
        resolved,
        update: update,
        compare: _sortByCreatedAt,
      );

      // Non-delete updates can't change what embedded quotedMessage copies
      // should display, so we can skip the rewrite entirely.
      if (!resolved.isDeleted) return mergedMessages;

      return mergedMessages.updateIf(
        (it) => it.quotedMessageId == resolved.id,
        (it) => it.copyWith(quotedMessage: resolved),
      );
    }

    // upsert: false - skip messages not loaded in the window
    if (!upsert) {
      final existingIds = {for (final m in existingList) m.id};
      toMergeList = toMergeList.where((m) => existingIds.contains(m.id)).toList();
      if (toMergeList.isEmpty) return existingList;
    }

    // Batch path: receiver (`existingList`) is maintained sorted as a
    // state invariant; `mergeSorted` sorts `toMergeList` internally and
    // returns a sorted result.
    final mergedMessages = existingList.mergeSorted(
      toMergeList,
      key: (message) => message.id,
      update: update,
      compare: _sortByCreatedAt,
    );

    // Refresh embedded `quotedMessage` refs only for messages quoting an
    // incoming message that is now deleted. `updateIf` returns the same
    // list reference when nothing matches, so steady-state allocates
    // nothing for this step.
    final deletedIds = toMergeList.where((m) => m.isDeleted).map((m) => m.id).toSet();
    if (deletedIds.isEmpty) return mergedMessages;

    final mergedById = {for (final m in mergedMessages) m.id: m};
    return mergedMessages.updateIf(
      (it) => deletedIds.contains(it.quotedMessageId),
      (it) => it.copyWith(quotedMessage: mergedById[it.quotedMessageId]),
    );
  }

  void _removeMessages(Iterable<Message> messages) {
    if (messages.isEmpty) return;

    final messageIds = messages.map((m) => m.id).toSet().toList();
    final persistenceClient = _channel.client.chatPersistenceClient;
    // Remove the messages from the persistence client.
    persistenceClient?.deleteMessageByIds(messageIds);
    persistenceClient?.deletePinnedMessageByIds(messageIds);

    _removeThreadMessages(messages);
    _removeChannelMessages(messages);
    _removePinnedMessages(messages);
    _removeActiveLiveLocations(messages);
  }

  void _removeThreadMessages(Iterable<Message> messages) {
    if (messages.isEmpty) return;

    final affectedThreads = {...messages.map((it) => it.parentId).nonNulls};
    // If there are no affected threads, return early.
    if (affectedThreads.isEmpty) return;

    final updatedThreads = {...threads};
    for (final thread in affectedThreads) {
      final threadMessages = updatedThreads[thread];
      // Continue if the thread doesn't exist.
      if (threadMessages == null) continue;

      // Remove the deleted message from the thread messages and reference from
      // other messages quoting it.
      final updatedThreadMessages = _removeMessagesFromExisting(
        existing: threadMessages,
        toRemove: messages,
      );

      // If there are no more messages in the thread, remove the thread entry.
      if (updatedThreadMessages.isEmpty) {
        updatedThreads.remove(thread);
        continue;
      }

      // Otherwise, update the thread with the modified message list.
      updatedThreads[thread] = updatedThreadMessages.toList();
    }

    // Update the threads map.
    _threads = updatedThreads;
  }

  void _removeChannelMessages(Iterable<Message> messages) {
    if (messages.isEmpty) return;

    // Only messages shown in the channel are affected.
    final affectedMessages = messages.where(_isShownInChannel);

    // If there are no affected messages, return early.
    if (affectedMessages.isEmpty) return;

    final channelMessages = [...this.messages];
    final updatedChannelMessages = _removeMessagesFromExisting(
      existing: channelMessages,
      toRemove: affectedMessages,
    );

    _channelState = _channelState.copyWith(
      messages: updatedChannelMessages.toList(),
    );
  }

  void _removePinnedMessages(Iterable<Message> messages) {
    if (messages.isEmpty) return;

    final pinnedMessages = [...this.pinnedMessages];
    final updatedPinnedMessages = _removePinnedMessagesFromExisting(
      existing: pinnedMessages,
      toRemove: messages,
    );

    _channelState = _channelState.copyWith(
      pinnedMessages: updatedPinnedMessages.toList(),
    );
  }

  void _removeActiveLiveLocations(Iterable<Message> messages) {
    if (messages.isEmpty) return;

    final activeLiveLocations = [...this.activeLiveLocations];
    final updatedActiveLiveLocations = _removeActiveLocationsFromExisting(
      existing: activeLiveLocations,
      toRemove: messages,
    );

    _channelState = _channelState.copyWith(
      activeLiveLocations: updatedActiveLiveLocations.toList(),
    );
  }

  Iterable<Location> _removeActiveLocationsFromExisting({
    required Iterable<Location> existing,
    required Iterable<Message> toRemove,
  }) {
    if (toRemove.isEmpty) return existing;

    final toRemoveIds = toRemove.map((m) => m.id).toSet();
    final updatedLocations = existing.where(
      // Remove the location if its attached message is in the toRemove list.
      (it) => !toRemoveIds.contains(it.messageId),
    );

    return updatedLocations;
  }

  Iterable<Message> _removePinnedMessagesFromExisting({
    required Iterable<Message> existing,
    required Iterable<Message> toRemove,
  }) {
    return _removeMessagesFromExisting(
      existing: existing,
      toRemove: toRemove,
    ).where(_pinIsValid);
  }

  Iterable<Message> _removeMessagesFromExisting({
    required Iterable<Message> existing,
    required Iterable<Message> toRemove,
  }) {
    if (toRemove.isEmpty) return existing;

    final toRemoveIds = toRemove.map((m) => m.id).toSet();
    final updatedMessages = existing
        .where((it) {
          // Remove the message if it's in the toRemove list.
          return !toRemoveIds.contains(it.id);
        })
        .map((it) {
          // Continue if the message doesn't quote any of the deleted messages.
          if (!toRemoveIds.contains(it.quotedMessageId)) return it;

          // Setting it to null will remove the quoted message from the message.
          return it.copyWith(quotedMessageId: null, quotedMessage: null);
        });

    return updatedMessages;
  }

  // Listens to user message deleted events and marks messages from that user
  // as either soft or hard deleted based on the event data.
  void _listenUserMessagesDeleted() {
    _subscriptions.add(
      _channel.on(EventType.userMessagesDeleted).listen((event) async {
        final user = event.user;
        if (user == null) return;

        return _deleteMessagesFromUser(
          userId: user.id,
          hardDelete: event.hardDelete ?? false,
          deletedAt: event.createdAt,
        );
      }),
    );
  }

  /// Call this method to dispose this object.
  void dispose() {
    _debouncedUpdatePersistenceChannelThreads.cancel();
    _debouncedUpdatePersistenceChannelState.cancel();
    _retryQueue.dispose();
    _subscriptions.cancel();
    _channelStateController.close();
    _isUpToDateController.close();
    _threadsController.close();
    _staleTypingEventsCleanerTimer?.cancel();
    _stalePinnedMessagesCleanerTimer?.cancel();
    _staleLiveLocationsCleanerTimer?.cancel();
    _typingEventsController.close();
  }
}

bool _isShownInChannel(Message message) {
  // Non-thread messages are always shown in the channel.
  if (message.parentId == null) return true;

  // Thread messages are only shown if explicitly marked.
  return message.showInChannel == true;
}

bool _pinIsValid(Message message) {
  // If the message is deleted, the pin is not valid.
  if (message.isDeleted) return false;

  // If the message is not pinned, it's not valid.
  if (message.pinned != true) return false;

  // If there's no expiration, the pin is valid.
  final pinExpires = message.pinExpires;
  if (pinExpires == null) return true;

  // If there's an expiration, check if it's still valid.
  return pinExpires.isAfter(DateTime.now());
}
