import '../../../open_api/api.dart' as api;
import '../../core/models/response/get_thread_response.dart';
import '../../core/models/response/query_threads_response.dart';
import '../../core/models/response/update_thread_partial_response.dart';
import '../../core/models/thread.dart';
import '../../core/models/thread_participant.dart';
import 'channel_mapper.dart';
import 'drafts_mapper.dart';
import 'message_mapper.dart';
import 'user_mapper.dart';

/// Maps a generated [api.QueryThreadsResponse] to a [QueryThreadsResponse].
extension QueryThreadsResponseMapper on api.QueryThreadsResponse {
  /// Converts this response into a [QueryThreadsResponse].
  QueryThreadsResponse toModel() => QueryThreadsResponse(
    duration: duration,
    threads: [for (final thread in threads) thread.toModel()],
    next: next,
    prev: prev,
  );
}

/// Maps a generated [api.GetThreadResponse] to a [GetThreadResponse].
extension GetThreadResponseMapper on api.GetThreadResponse {
  /// Converts this response into a [GetThreadResponse].
  GetThreadResponse toModel() => GetThreadResponse(duration: duration, thread: thread.toModel());
}

/// Maps a generated [api.UpdateThreadPartialResponse] to an [UpdateThreadPartialResponse].
extension UpdateThreadPartialResponseMapper on api.UpdateThreadPartialResponse {
  /// Converts this response into an [UpdateThreadPartialResponse].
  UpdateThreadPartialResponse toModel() => UpdateThreadPartialResponse(duration: duration, thread: thread.toModel());
}

/// Maps a generated [api.ThreadStateResponse] to a [Thread].
extension ThreadStateResponseMapper on api.ThreadStateResponse {
  /// Converts this response into a [Thread].
  ///
  /// Custom data named like one of the thread's own fields is left out of [Thread.extraData].
  Thread toModel() => Thread(
    activeParticipantCount: activeParticipantCount,
    channel: channel?.toModel(),
    channelCid: channelCid,
    parentMessageId: parentMessageId,
    parentMessage: parentMessage?.toModel(),
    createdByUserId: createdByUserId,
    createdBy: createdBy?.toModel(),
    replyCount: replyCount,
    participantCount: participantCount,
    threadParticipants: threadParticipants?.map((participant) => participant.toModel()).toList() ?? const [],
    lastMessageAt: lastMessageAt,
    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
    title: title,
    latestReplies: [for (final reply in latestReplies) reply.toModel()],
    read: read?.map((read) => read.toModel()).toList() ?? const [],
    draft: draft?.toModel(),
    extraData: _threadExtraData(custom),
  );
}

/// Maps a generated [api.ThreadResponse] to a [Thread].
extension ThreadResponseMapper on api.ThreadResponse {
  /// Converts this response into a [Thread] without latest replies, reads or a draft.
  ///
  /// Custom data named like one of the thread's own fields is left out of [Thread.extraData].
  Thread toModel() => Thread(
    activeParticipantCount: activeParticipantCount,
    channel: channel?.toModel(),
    channelCid: channelCid,
    parentMessageId: parentMessageId,
    parentMessage: parentMessage?.toModel(),
    createdByUserId: createdByUserId,
    createdBy: createdBy?.toModel(),
    replyCount: replyCount,
    participantCount: participantCount,
    threadParticipants: threadParticipants?.map((participant) => participant.toModel()).toList() ?? const [],
    lastMessageAt: lastMessageAt,
    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
    title: title,
    extraData: _threadExtraData(custom),
  );
}

/// Maps a generated [api.ThreadParticipant] to a [ThreadParticipant].
extension ThreadParticipantMapper on api.ThreadParticipant {
  /// Converts this participant into a [ThreadParticipant].
  ThreadParticipant toModel() => ThreadParticipant(
    channelCid: channelCid,
    createdAt: createdAt,
    lastReadAt: lastReadAt,
    lastThreadMessageAt: lastThreadMessageAt,
    leftThreadAt: leftThreadAt,
    threadId: threadId,
    userId: userId,
    user: user?.toModel(),
  );
}

Map<String, Object?> _threadExtraData(Map<String, Object?> custom) =>
    {...custom}..removeWhere((key, _) => Thread.topLevelFields.contains(key));
