// coverage:ignore-file
import 'package:drift/drift.dart';
import 'package:stream_chat_persistence/src/converter/converter.dart';
import 'package:stream_chat_persistence/src/entity/channels.dart';
import 'package:stream_chat_persistence/src/entity/messages.dart';

/// Represents a [DraftMessages] table in [MoorChatDatabase].
@DataClassName('DraftMessageEntity')
class DraftMessages extends Table {
  /// The message id
  TextColumn get id => text()();

  /// The text of this message
  TextColumn get messageText => text().nullable()();

  /// The list of attachments, either provided by the user
  /// or generated from a command or as a result of URL scraping.
  TextColumn get attachments => text().map(ListConverter<String>())();

  /// The message type
  TextColumn get type => text().withDefault(const Constant('regular'))();

  /// The list of user mentioned in the message
  TextColumn get mentionedUsers => text().map(ListConverter<String>())();

  /// The ID of the parent message, if the message is a thread reply.
  TextColumn get parentId => text()
      .nullable()
      .references(Messages, #id, onDelete: KeyAction.cascade)();

  /// The ID of the quoted message, if the message is a quoted reply.
  TextColumn get quotedMessageId => text().nullable()();

  /// The ID of the poll, if the message is a poll.
  TextColumn get pollId => text().nullable()();

  /// Check if this message needs to show in the channel.
  BoolColumn get showInChannel => boolean().nullable()();

  /// A used command name.
  TextColumn get command => text().nullable()();

  /// If true the message is silent
  BoolColumn get silent => boolean().withDefault(const Constant(false))();

  /// The DateTime on which the message was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// The channel cid of which this message is part of
  TextColumn get channelCid =>
      text().references(Channels, #cid, onDelete: KeyAction.cascade)();

  /// Message custom extraData
  TextColumn get extraData => text().nullable().map(MapConverter())();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
