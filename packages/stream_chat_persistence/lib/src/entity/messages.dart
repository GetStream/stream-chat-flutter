import 'package:moor/moor.dart';
import 'package:stream_chat_persistence/src/converter/list_converter.dart';
import 'package:stream_chat_persistence/src/converter/map_converter.dart';
import 'package:stream_chat_persistence/src/converter/message_sending_status_converter.dart';

/// Represents a [Messages] table in [MoorChatDatabase].
@DataClassName('MessageEntity')
class Messages extends Table {
  /// The message id
  TextColumn get id => text()();

  /// The text of this message
  TextColumn get messageText => text().nullable()();

  /// The list of attachments, either provided by the user
  /// or generated from a command or as a result of URL scraping.
  TextColumn get attachments =>
      text().nullable().map(ListConverter<String>())();

  /// The status of a sending message
  IntColumn get status =>
      integer().nullable().map(MessageSendingStatusConverter())();

  /// The message type
  TextColumn get type => text().nullable()();

  /// The list of user mentioned in the message
  TextColumn get mentionedUsers =>
      text().nullable().map(ListConverter<String>())();

  /// A map describing the count of number of every reaction
  TextColumn get reactionCounts => text().nullable().map(MapConverter<int>())();

  /// A map describing the count of score of every reaction
  TextColumn get reactionScores => text().nullable().map(MapConverter<int>())();

  /// The ID of the parent message, if the message is a thread reply.
  TextColumn get parentId => text().nullable()();

  /// The ID of the quoted message, if the message is a quoted reply.
  TextColumn get quotedMessageId => text().nullable()();

  /// Number of replies for this message.
  IntColumn get replyCount => integer().nullable()();

  /// Check if this message needs to show in the channel.
  BoolColumn get showInChannel => boolean().nullable()();

  /// If true the message is shadowed
  BoolColumn get shadowed => boolean().nullable()();

  /// A used command name.
  TextColumn get command => text().nullable()();

  /// The DateTime when the message was created.
  DateTimeColumn get createdAt => dateTime()();

  /// The DateTime when the message was updated last time.
  DateTimeColumn get updatedAt => dateTime().nullable()();

  /// The DateTime when the message was deleted.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// Id of the User who sent the message
  TextColumn get userId => text().nullable()();

  /// The channel cid of which this message is part of
  TextColumn get channelCid => text().nullable().customConstraint(
      'NULLABLE REFERENCES channels(cid) ON DELETE CASCADE')();

  /// Message custom extraData
  TextColumn get extraData => text().nullable().map(MapConverter<Object>())();

  @override
  Set<Column> get primaryKey => {id};
}
