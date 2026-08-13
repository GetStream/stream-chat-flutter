import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/pinned_messages.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import 'package:stream_chat_persistence/src/mapper/mapper.dart';

part 'pinned_message_dao.g.dart';

/// The Data Access Object for operations in [Messages] table.
@DriftAccessor(tables: [PinnedMessages, Users])
class PinnedMessageDao extends DatabaseAccessor<DriftChatDatabase> with _$PinnedMessageDaoMixin {
  /// Creates a new message dao instance
  PinnedMessageDao(this._db) : super(_db);

  final DriftChatDatabase _db;

  $UsersTable get _users => alias(users, 'users');

  $UsersTable get _pinnedByUsers => alias(users, 'pinnedByUsers');

  /// Removes all the messages by matching [PinnedMessages.id] in [messageIds]
  ///
  /// This will automatically delete the following linked records
  /// 1. Message Reactions
  Future<void> deleteMessageByIds(List<String> messageIds) =>
      (delete(pinnedMessages)..where((tbl) => tbl.id.isIn(messageIds))).go();

  /// Removes all the messages by matching [PinnedMessages.channelCid] in [cids]
  ///
  /// This will automatically delete the following linked records
  /// 1. Message Reactions
  Future<void> deleteMessageByCids(List<String> cids) async =>
      (delete(pinnedMessages)..where((tbl) => tbl.channelCid.isIn(cids))).go();

  /// Hydrates `rows` (from the pinned-messages table) into `Message`s using
  /// batched lookups for related entities.
  Future<List<Message>> _messagesFromJoinRows(
    List<TypedResult> rows, {
    bool fetchDraft = false,
    bool fetchQuotedMessage = true,
    bool fetchSharedLocation = false,
  }) async {
    if (rows.isEmpty) return const [];

    final messageIds = <String>[];
    final quotedIds = <String>[];
    final pollIds = <String>[];
    // note: While possible, in real case scenarios this will NOT hold more than
    // a single value.
    final cids = <String>{};
    for (final row in rows) {
      final msg = row.readTable(pinnedMessages);
      messageIds.add(msg.id);
      if (msg.quotedMessageId case final id?) quotedIds.add(id);
      if (msg.pollId case final id?) pollIds.add(id);
      cids.add(msg.channelCid);
    }

    final results = await Future.wait([
      // Reactions. We fetch every reaction for these messages once; own
      // reactions are the current-user subset and are derived in-memory below
      // instead of issuing a second, near-identical table scan.
      _db.pinnedMessageReactionDao.getReactionsForMessages(messageIds),
      // Polls
      if (pollIds.isNotEmpty) _db.pollDao.getPollsByIds(pollIds) else Future.value(const <String, Poll?>{}),
      // Drafts
      if (fetchDraft)
        Future.wait([
          for (final cid in cids)
            _db.draftMessageDao.getDraftMessagesByParentIds(cid, messageIds).then((map) => MapEntry(cid, map)),
        ]).then(Map.fromEntries)
      else
        Future.value(const <String, Map<String, Draft?>>{}),
      // Locations
      if (fetchSharedLocation)
        _db.locationDao.getLocationsByMessageIds(messageIds)
      else
        Future.value(const <String, Location>{}),
    ]);

    final latestReactionsByMsg = results[0] as Map<String, List<Reaction>>;
    final pollsById = results[1] as Map<String, Poll?>;
    final draftsByCidByParentId = results[2] as Map<String, Map<String, Draft?>>;
    final locationsByMsg = results[3] as Map<String, Location>;

    final ownReactionsByMsg = _ownReactionsFrom(latestReactionsByMsg);

    final quotedById = fetchQuotedMessage && quotedIds.isNotEmpty
        ? await _resolveQuotedMessages(
            rows,
            messageIds,
            quotedIds,
            latestReactionsByMsg: latestReactionsByMsg,
            ownReactionsByMsg: ownReactionsByMsg,
            pollsById: pollsById,
            locationsByMsg: locationsByMsg,
            fetchSharedLocation: fetchSharedLocation,
          )
        : const <String, Message>{};

    return [
      for (final row in rows)
        _buildMessage(
          row,
          latestReactionsByMsg: latestReactionsByMsg,
          ownReactionsByMsg: ownReactionsByMsg,
          pollsById: pollsById,
          quotedById: quotedById,
          draftsByCidByParentId: draftsByCidByParentId,
          locationsByMsg: locationsByMsg,
        ),
    ];
  }

  Message _buildMessage(
    TypedResult row, {
    required Map<String, List<Reaction>> latestReactionsByMsg,
    required Map<String, List<Reaction>> ownReactionsByMsg,
    required Map<String, Poll?> pollsById,
    required Map<String, Message> quotedById,
    required Map<String, Map<String, Draft?>> draftsByCidByParentId,
    required Map<String, Location> locationsByMsg,
  }) {
    final userEntity = row.readTableOrNull(_users);
    final pinnedByEntity = row.readTableOrNull(_pinnedByUsers);
    final msgEntity = row.readTable(pinnedMessages);

    final quotedMessage = switch (msgEntity.quotedMessageId) {
      final id? => quotedById[id],
      _ => null,
    };
    final poll = switch (msgEntity.pollId) {
      final id? => pollsById[id],
      _ => null,
    };
    final draft = draftsByCidByParentId[msgEntity.channelCid]?[msgEntity.id];
    final sharedLocation = locationsByMsg[msgEntity.id];

    return msgEntity.toMessage(
      user: userEntity?.toUser(),
      pinnedBy: pinnedByEntity?.toUser(),
      latestReactions: latestReactionsByMsg[msgEntity.id] ?? const [],
      ownReactions: ownReactionsByMsg[msgEntity.id] ?? const [],
      quotedMessage: quotedMessage,
      poll: poll,
      draft: draft,
      sharedLocation: sharedLocation,
    );
  }

  /// Derives each message's own reactions — those authored by the current
  /// user — from the already-fetched [latestReactionsByMsg], avoiding a second,
  /// near-identical table scan.
  Map<String, List<Reaction>> _ownReactionsFrom(
    Map<String, List<Reaction>> latestReactionsByMsg,
  ) {
    return {
      for (final MapEntry(:key, :value) in latestReactionsByMsg.entries)
        key: [
          for (final reaction in value)
            if (reaction.userId == _db.userId) reaction,
        ],
    };
  }

  /// Resolves the quoted-message previews referenced by a page of pinned
  /// messages, keyed by quoted-message id.
  ///
  /// Quotes already present in [rows] are rebuilt from the maps already loaded
  /// for the page (no extra queries); only quotes outside the page are fetched
  /// from the DB. Either way a quote is hydrated a single level deep and never
  /// carries a draft, and always includes its shared location.
  Future<Map<String, Message>> _resolveQuotedMessages(
    List<TypedResult> rows,
    List<String> messageIds,
    List<String> quotedIds, {
    required Map<String, List<Reaction>> latestReactionsByMsg,
    required Map<String, List<Reaction>> ownReactionsByMsg,
    required Map<String, Poll?> pollsById,
    required Map<String, Location> locationsByMsg,
    required bool fetchSharedLocation,
  }) async {
    final quotedById = <String, Message>{};
    final pageIds = messageIds.toSet();

    // A quote already in this page can be rebuilt from the maps we loaded for
    // the page instead of re-querying it — but only when the page fetched
    // everything the quote needs. Reactions and polls are always loaded for the
    // page; the shared location is only loaded when [fetchSharedLocation] is
    // set, and that location is the one field a rebuilt quote relies on. So
    // reuse in-page quotes only in that case; otherwise let the DB branch below
    // fetch them (it always loads locations — quotes keep their location even
    // when the caller opted out of locations for the page).
    final inPageQuotedIds = fetchSharedLocation ? quotedIds.where(pageIds.contains).toSet() : const <String>{};
    if (inPageQuotedIds.isNotEmpty) {
      final rowById = {
        for (final row in rows) row.readTable(pinnedMessages).id: row,
      };
      for (final id in inPageQuotedIds) {
        final row = rowById[id];
        if (row == null) continue;
        quotedById[id] = _buildMessage(
          row,
          latestReactionsByMsg: latestReactionsByMsg,
          ownReactionsByMsg: ownReactionsByMsg,
          pollsById: pollsById,
          quotedById: const {}, // quotes are hydrated a single level only
          draftsByCidByParentId: const {}, // quotes never carry a draft
          locationsByMsg: locationsByMsg,
        );
      }
    }

    // Everything not rebuilt above — including all quotes when
    // fetchSharedLocation is false — is fetched + hydrated from the DB.
    final outOfPageQuotedIds = quotedIds.toSet().difference(inPageQuotedIds).toList();
    if (outOfPageQuotedIds.isNotEmpty) {
      final quoteRows = await (select(pinnedMessages).join([
        leftOuterJoin(_users, pinnedMessages.userId.equalsExp(_users.id)),
        leftOuterJoin(
          _pinnedByUsers,
          pinnedMessages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
        ),
      ])..where(pinnedMessages.id.isIn(outOfPageQuotedIds))).get();
      final quotedMessages = await _messagesFromJoinRows(
        quoteRows,
        fetchQuotedMessage: false,
        fetchSharedLocation: true,
      );
      for (final m in quotedMessages) {
        quotedById[m.id] = m;
      }
    }

    return quotedById;
  }

  /// Returns a single message by matching the [PinnedMessages.id] with [id]
  Future<Message?> getMessageById(
    String id, {
    bool fetchDraft = true,
    bool fetchSharedLocation = true,
  }) async {
    final query = select(pinnedMessages).join([
      leftOuterJoin(_users, pinnedMessages.userId.equalsExp(_users.id)),
      leftOuterJoin(
        _pinnedByUsers,
        pinnedMessages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
      ),
    ])..where(pinnedMessages.id.equals(id));

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    final hydrated = await _messagesFromJoinRows(
      [result],
      fetchDraft: fetchDraft,
      fetchSharedLocation: fetchSharedLocation,
    );
    return hydrated.firstOrNull;
  }

  /// Returns all the messages of a channel by matching
  /// [PinnedMessages.channelCid] with [parentId]
  Future<List<Message>> getMessagesByCid(
    String cid, {
    bool fetchDraft = true,
    bool fetchSharedLocation = true,
    PaginationParams? messagePagination,
  }) async {
    final (
      lessThanCursor,
      lessThanOrEqualCursor,
      greaterThanCursor,
      greaterThanOrEqualCursor,
    ) = await (
      _lookupCursor(messagePagination?.lessThan),
      _lookupCursor(messagePagination?.lessThanOrEqual),
      _lookupCursor(messagePagination?.greaterThan),
      _lookupCursor(messagePagination?.greaterThanOrEqual),
    ).wait;

    // When the caller is paginating forward (greaterThan / greaterThanOrEqual
    // only), order ASC so the SQL `LIMIT` retains the N messages immediately
    // AFTER the cursor. Otherwise order DESC so `LIMIT` retains the N most
    // recent (closest to a `lessThan` cursor, or the channel tail when no
    // cursor is set). The final result is always reshaped to ASC for display.
    final isForwardPagination =
        (greaterThanCursor != null || greaterThanOrEqualCursor != null) &&
        lessThanCursor == null &&
        lessThanOrEqualCursor == null;

    final orderBy = isForwardPagination
        ? [
            OrderingTerm.asc(pinnedMessages.createdAt),
            OrderingTerm.asc(pinnedMessages.id),
          ]
        : [
            OrderingTerm.desc(pinnedMessages.createdAt),
            OrderingTerm.desc(pinnedMessages.id),
          ];

    final query =
        select(pinnedMessages).join([
            leftOuterJoin(_users, pinnedMessages.userId.equalsExp(_users.id)),
            leftOuterJoin(
              _pinnedByUsers,
              pinnedMessages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
            ),
          ])
          ..where(pinnedMessages.channelCid.equals(cid))
          ..where(pinnedMessages.parentId.isNull() | pinnedMessages.showInChannel.equals(true))
          ..orderBy(orderBy);

    // Cursor predicates compare the full `(createdAt, id)` tuple — the same
    // key used in ORDER BY — so messages sharing a `createdAt` with the cursor
    // fall on the correct side of the boundary. Filtering on `createdAt` alone
    // would skip or repeat those siblings across pages.
    if (lessThanCursor case final c?) {
      query.where(
        pinnedMessages.createdAt.isSmallerThanValue(c.createdAt) |
            (pinnedMessages.createdAt.equals(c.createdAt) & pinnedMessages.id.isSmallerThanValue(c.id)),
      );
    }
    if (lessThanOrEqualCursor case final c?) {
      query.where(
        pinnedMessages.createdAt.isSmallerThanValue(c.createdAt) |
            (pinnedMessages.createdAt.equals(c.createdAt) & pinnedMessages.id.isSmallerOrEqualValue(c.id)),
      );
    }
    if (greaterThanCursor case final c?) {
      query.where(
        pinnedMessages.createdAt.isBiggerThanValue(c.createdAt) |
            (pinnedMessages.createdAt.equals(c.createdAt) & pinnedMessages.id.isBiggerThanValue(c.id)),
      );
    }
    if (greaterThanOrEqualCursor case final c?) {
      query.where(
        pinnedMessages.createdAt.isBiggerThanValue(c.createdAt) |
            (pinnedMessages.createdAt.equals(c.createdAt) & pinnedMessages.id.isBiggerOrEqualValue(c.id)),
      );
    }

    if (messagePagination != null) {
      query.limit(messagePagination.limit);
    }

    final rows = await query.get();
    final orderedRows = isForwardPagination ? rows : rows.reversed.toList();
    return _messagesFromJoinRows(
      orderedRows,
      fetchDraft: fetchDraft,
      fetchSharedLocation: fetchSharedLocation,
    );
  }

  /// Deletes all pinned messages sent by a user with the given [userId].
  ///
  /// If [hardDelete] is `true`, permanently removes pinned messages from the
  /// database. Otherwise, soft-deletes them by updating their type, deletion
  /// timestamp, and state.
  ///
  /// If [cid] is provided, only deletes pinned messages in that channel.
  /// Otherwise, deletes pinned messages across all channels.
  ///
  /// The [deletedAt] timestamp is used for soft deletes. Defaults to the
  /// current time if not provided.
  ///
  /// Returns the number of rows affected.
  Future<int> deleteMessagesByUser({
    String? cid,
    required String userId,
    bool hardDelete = false,
    DateTime? deletedAt,
  }) async {
    if (hardDelete) {
      // Hard delete: remove from database
      final deleteQuery = delete(pinnedMessages)..where((tbl) => tbl.userId.equals(userId));

      if (cid != null) {
        deleteQuery.where((tbl) => tbl.channelCid.equals(cid));
      }

      return deleteQuery.go();
    }

    // Soft delete: update messages to mark as deleted
    final updateQuery = update(pinnedMessages)..where((tbl) => tbl.userId.equals(userId));

    if (cid != null) {
      updateQuery.where((tbl) => tbl.channelCid.equals(cid));
    }

    return updateQuery.write(
      PinnedMessagesCompanion(
        type: const Value('deleted'),
        remoteDeletedAt: Value(deletedAt ?? DateTime.now()),
        state: Value(jsonEncode(MessageState.softDeleted)),
      ),
    );
  }

  /// Bulk updates the message data of multiple channels
  Future<void> bulkUpdateMessages(
    Map<String, List<Message>?> channelWithMessages,
  ) {
    final entities = channelWithMessages.entries
        .map(
          (entry) =>
              entry.value?.map(
                (message) => message.toPinnedEntity(cid: entry.key),
              ) ??
              [],
        )
        .expand((it) => it)
        .toList(growable: false);
    return batch(
      (batch) => batch.insertAllOnConflictUpdate(pinnedMessages, entities),
    );
  }

  /// Returns the `(createdAt, id)` cursor for the pinned message with [id] in
  /// the local cache, or `null` if [id] is null, the message isn't cached, or
  /// isn't visible in the channel (i.e. a thread reply with
  /// `showInChannel = false`).
  Future<({DateTime createdAt, String id})?> _lookupCursor(String? id) async {
    if (id == null) return null;
    final createdAt =
        await (selectOnly(pinnedMessages)
              ..addColumns([pinnedMessages.createdAt])
              ..where(pinnedMessages.id.equals(id))
              ..where(
                pinnedMessages.parentId.isNull() | pinnedMessages.showInChannel.equals(true),
              ))
            .map((row) => row.read(pinnedMessages.createdAt))
            .getSingleOrNull();
    if (createdAt == null) return null;
    return (createdAt: createdAt, id: id);
  }
}
