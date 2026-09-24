library stream_chat;

export 'package:async/async.dart' hide Result;
export 'package:dio/dio.dart'
    show
        DioException,
        DioExceptionType,
        RequestOptions,
        CancelToken,
        Interceptor,
        InterceptorsWrapper,
        MultipartFile,
        Options,
        ProgressCallback;
export 'package:rate_limiter/rate_limiter.dart';
// Re-exported with a `show` allowlist rather than wholesale: `stream_core`
// also declares names this barrel defines — `AttachmentFile`, `User` — so a
// blanket export would not compile.
//
// `Filter`'s operator subclasses stay out of the list: a filter is read with
// `toJson`. `EvaluationOperator` and `LogicalOperator` are the exception,
// because `searchQueryLength` needs to tell a text search from a compound
// filter without re-parsing the JSON.
export 'package:stream_core/stream_core.dart'
    show
        CompositeComparator,
        ConnectionIdGetter,
        CurrentPlatform,
        Distance,
        EvaluationOperator,
        Failure,
        Filter,
        HealthCheckInfo,
        FilterField,
        FilterOperator,
        LocationCoordinate,
        LogicalOperator,
        NullOrdering,
        PlatformType,
        PatternMatching,
        Result,
        Sort,
        SortDirection,
        SortField,
        SortedListExtensions,
        StreamApiError,
        StreamApiException,
        StreamAuthenticationException,
        StreamClientException,
        StreamErrorCode,
        StreamException,
        StreamLogConfig,
        StreamLogFilter,
        StreamLogHandler,
        StreamLogPriority,
        StreamLogRecord,
        StreamLogger,
        StreamNetworkException,
        Success,
        SystemEnvironment,
        TokenManager,
        TokenProvider,
        UserToken,
        UserTokenLoader,
        WsEvent;

export 'package:uuid/uuid.dart';

export 'open_api/models.dart'
    show
        BanRequestDeleteMessages,
        CreateDeviceRequestPushProvider,
        DeviceResponse,
        ListDevicesResponse,
        Role,
        SearchRolesResponse;

export 'src/client/channel/channel.dart';
export 'src/client/channel/channel_capability_check.dart';
export 'src/client/channel/channel_client_state.dart';
export 'src/client/channel/channel_read_helper.dart';
export 'src/client/channel_delivery_reporter.dart';
export 'src/client/client.dart';
export 'src/client/key_stroke_handler.dart';
export 'src/client/moderation_client.dart';
export 'src/client/query_channels_result.dart';
export 'src/client/retry_policy.dart';
export 'src/core/api/attachment_file_uploader.dart';
export 'src/core/api/requests.dart';
export 'src/core/api/responses.dart';
export 'src/core/api/stream_chat_api.dart';
export 'src/core/error/stream_chat_exception.dart';
export 'src/core/http/stream_http_client.dart';
export 'src/core/models/action.dart';
export 'src/core/models/app_settings.dart';
export 'src/core/models/attachment.dart';
export 'src/core/models/attachment_file.dart';
export 'src/core/models/attachment_giphy_info.dart';
export 'src/core/models/banned_user.dart';
export 'src/core/models/channel_config.dart';
export 'src/core/models/channel_model.dart';
export 'src/core/models/channel_mute.dart';
export 'src/core/models/channel_state.dart';
export 'src/core/models/chat_preferences.dart';
export 'src/core/models/command.dart';
export 'src/core/models/draft.dart';
export 'src/core/models/draft_message.dart';
export 'src/core/models/location.dart';
export 'src/core/models/member.dart';
export 'src/core/models/message.dart';
export 'src/core/models/message_delete_scope.dart';
export 'src/core/models/message_delivery.dart';
export 'src/core/models/message_reminder.dart';
export 'src/core/models/message_state.dart';
export 'src/core/models/moderation.dart';
export 'src/core/models/mute.dart';
export 'src/core/models/own_user.dart';
export 'src/core/models/poll.dart';
export 'src/core/models/poll_option.dart';
export 'src/core/models/poll_vote.dart';
export 'src/core/models/poll_voting_mode.dart';
export 'src/core/models/predefined_filter.dart';
export 'src/core/models/privacy_settings.dart';
export 'src/core/models/push_level.dart';
export 'src/core/models/push_preference.dart';
export 'src/core/models/reaction.dart';
export 'src/core/models/reaction_group.dart';
export 'src/core/models/read.dart';
export 'src/core/models/role_type.dart';
export 'src/core/models/thread.dart';
export 'src/core/models/thread_participant.dart';
export 'src/core/models/unread_counts.dart';
export 'src/core/models/user.dart';
export 'src/core/models/user_block.dart';
export 'src/core/models/user_group.dart';
export 'src/core/models/user_group_member.dart';
export 'src/core/util/extension.dart';
export 'src/core/util/message_rules.dart';
export 'src/db/chat_persistence_client.dart';
export 'src/event_type.dart';
export 'src/ws/connection_status.dart' show ConnectionStatus;
export 'src/ws/events/event.dart';
