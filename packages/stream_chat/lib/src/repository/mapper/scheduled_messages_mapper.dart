import '../../../open_api/api.dart' as api;
import '../../core/models/channel_model.dart';
import '../../core/models/location.dart';
import '../../core/models/message.dart';
import '../../core/models/scheduled_message.dart';
import '../../core/models/user.dart';
import '../../core/util/message_decoding.dart';
import 'attachments_mapper.dart';
import 'users_mapper.dart';

// TODO(openapi-migration): move this mapper into the group that migrates the
// scheduled message calls.

/// Maps a generated [api.ScheduledMessageResponse] to a [ScheduledMessage].
extension ScheduledMessageResponseMapper on api.ScheduledMessageResponse {
  /// Converts this response into a [ScheduledMessage].
  ///
  /// Its message takes the ID, the sender and the times of the scheduled
  /// message, as [ScheduledMessage.message] describes.
  ScheduledMessage toModel() {
    final sender = user.toModel();

    return ScheduledMessage(
      id: id,
      cid: cid,
      channel: channel?.toModel(),
      user: sender,
      message: message.toModel().copyWith(
        id: id,
        user: sender,
        createdAt: scheduledAt,
        updatedAt: updatedAt,
      ),
      scheduledAt: scheduledAt,
      status: ScheduledMessageStatus(status),
      failureReason: switch (failureReason) {
        final reason? => ScheduledMessageFailureReason(reason),
        null => null,
      },
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Maps a generated [api.ScheduledMessageChannelResponse] to a [ChannelModel].
extension ScheduledMessageChannelResponseMapper on api.ScheduledMessageChannelResponse {
  /// Converts this summary into a [ChannelModel] carrying the name and image
  /// it has.
  ChannelModel toModel() => ChannelModel(
    id: id,
    type: type,
    cid: cid,
    custom: {
      if (name case final name?) 'name': name,
      if (image case final image?) 'image': image,
    },
  );
}

/// Maps a generated [api.ScheduledMessageContentResponse] to a [Message].
extension ScheduledMessageContentResponseMapper on api.ScheduledMessageContentResponse {
  /// Converts this content into a [Message].
  ///
  /// A mentioned user carries only its ID.
  Message toModel() => Message(
    text: text,
    type: type ?? MessageType.regular,
    attachments: [for (final attachment in attachments ?? const <api.Attachment>[]) attachment.toModel()],
    mentionedChannel: mentionedChannel,
    mentionedGroupIds: mentionedGroupIds,
    mentionedHere: mentionedHere,
    mentionedRoles: mentionedRoles,
    mentionedUsers: [for (final id in mentionedUsers ?? const <String>[]) User(id: id)],
    silent: silent ?? false,
    parentId: parentId,
    quotedMessageId: quotedMessageId,
    showInChannel: showInChannel,
    pinned: pinned ?? false,
    pinExpires: pinExpires,
    pollId: pollId,
    custom: custom,
    restrictedVisibility: restrictedVisibility,
    sharedLocation: switch (sharedLocation) {
      final location? => Location(
        latitude: location.latitude ?? 0,
        longitude: location.longitude ?? 0,
        createdByDeviceId: location.createdByDeviceId,
        endAt: location.endAt,
      ),
      null => null,
    },
    html: html,
    mml: mml,
  ).withDerivedState();
}
