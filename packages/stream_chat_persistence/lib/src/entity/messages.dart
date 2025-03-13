// coverage:ignore-file
import 'package:drift/drift.dart';
import 'package:stream_chat_persistence/src/converter/list_converter.dart';
import 'package:stream_chat_persistence/src/converter/map_converter.dart';
import 'package:stream_chat_persistence/src/entity/channels.dart';

/// Represents a [Messages] table in [MoorChatDatabase].
@DataClassName('MessageEntity')
class Messages extends Table {
  /// The message id
  TextColumn get id => text()();

  /// The text of this message
  TextColumn get messageText => text().nullable()();

  /// The list of attachments, either provided by the user
  /// or generated from a command or as a result of URL scraping.
  TextColumn get attachments => text().map(ListConverter<String>())();

  /// The current state of the message.
  TextColumn get state => text()();

  /// The message type
  TextColumn get type => text().withDefault(const Constant('regular'))();

  /// The list of user mentioned in the message
  TextColumn get mentionedUsers => text().map(ListConverter<String>())();

  /// A map describing the count of number of every reaction
  TextColumn get reactionCounts => text().nullable().map(MapConverter<int>())();

  /// A map describing the count of score of every reaction
  TextColumn get reactionScores => text().nullable().map(MapConverter<int>())();

  /// The ID of the parent message, if the message is a thread reply.
  TextColumn get parentId => text().nullable()();

  /// The ID of the quoted message, if the message is a quoted reply.
  TextColumn get quotedMessageId => text().nullable()();

  /// The ID of the poll, if the message is a poll.
  TextColumn get pollId => text().nullable()();

  /// Number of replies for this message.
  IntColumn get replyCount => integer().nullable()();

  /// Check if this message needs to show in the channel.
  BoolColumn get showInChannel => boolean().nullable()();

  /// If true the message is shadowed
  BoolColumn get shadowed => boolean().withDefault(const Constant(false))();

  /// A used command name.
  TextColumn get command => text().nullable()();

  /// The DateTime on which the message was created.
  ///
  /// Returns the latest between [localCreatedAt] and [remoteCreatedAt].
  /// If both are null, returns [currentDateAndTime].
  Expression<DateTime> get createdAt {
    return coalesce<DateTime>(
      [remoteCreatedAt, localCreatedAt, currentDateAndTime],
    );
  }

  /// The DateTime on which the message was created on the client.
  DateTimeColumn get localCreatedAt => dateTime().nullable()();

  /// The DateTime on which the message was created on the server.
  DateTimeColumn get remoteCreatedAt => dateTime().nullable()();

  /// The DateTime on which the message was updated last time.
  ///
  /// Returns the latest between [localUpdatedAt] and [remoteUpdatedAt].
  /// If both are null, returns [createdAt].
  Expression<DateTime> get updatedAt {
    return coalesce<DateTime>(
      [remoteUpdatedAt, localUpdatedAt, createdAt],
    );
  }

  /// The DateTime on which the message was updated on the client.
  DateTimeColumn get localUpdatedAt => dateTime().nullable()();

  /// The DateTime on which the message was updated on the server.
  DateTimeColumn get remoteUpdatedAt => dateTime().nullable()();

  /// The DateTime on which the message was deleted.
  ///
  /// Returns the latest between [localDeletedAt] and [remoteDeletedAt].
  Expression<DateTime> get deletedAt {
    return coalesce<DateTime>(
      [remoteDeletedAt, localDeletedAt],
    );
  }

  /// The DateTime on which the message was deleted on the client.
  DateTimeColumn get localDeletedAt => dateTime().nullable()();

  /// The DateTime on which the message was deleted on the server.
  DateTimeColumn get remoteDeletedAt => dateTime().nullable()();

  /// The DateTime at which the message text was edited
  DateTimeColumn get messageTextUpdatedAt => dateTime().nullable()();

  /// Id of the User who sent the message
  TextColumn get userId => text().nullable()();

  /// Whether the message is pinned or not
  BoolColumn get pinned => boolean().withDefault(const Constant(false))();

  /// The DateTime at which the message was pinned
  DateTimeColumn get pinnedAt => dateTime().nullable()();

  /// The DateTime on which the message pin expires
  DateTimeColumn get pinExpires => dateTime().nullable()();

  /// Id of the User who pinned the message
  TextColumn get pinnedByUserId => text().nullable()();

  /// The channel cid of which this message is part of
  TextColumn get channelCid =>
      text().references(Channels, #cid, onDelete: KeyAction.cascade)();

  /// A Map of [messageText] translations.
  TextColumn get i18n =>
      text().nullable().map(NullableMapConverter<String>())();

  /// The list of user ids that should be able to see the message.
  TextColumn get restrictedVisibility =>
      text().nullable().map(ListConverter<String>())();

  /// Message custom extraData
  TextColumn get extraData => text().nullable().map(MapConverter())();

  @override
  Set<Column> get primaryKey => {id};
}
