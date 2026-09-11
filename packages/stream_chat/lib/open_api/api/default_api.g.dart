// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_api.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _DefaultApi implements DefaultApi {
  _DefaultApi(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  Future<AddUserGroupMembersResponse> _addUserGroupMembers({
    required String id,
    required AddUserGroupMembersRequest addUserGroupMembersRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(addUserGroupMembersRequest.toJson());
    final _options = _setStreamType<Result<AddUserGroupMembersResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/usergroups/${id}/members',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AddUserGroupMembersResponse _value;
    try {
      _value = AddUserGroupMembersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<AddUserGroupMembersResponse>> addUserGroupMembers({
    required String id,
    required AddUserGroupMembersRequest addUserGroupMembersRequest,
  }) {
    return _ResultCallAdapter<AddUserGroupMembersResponse>().adapt(
      () => _addUserGroupMembers(
        id: id,
        addUserGroupMembersRequest: addUserGroupMembersRequest,
      ),
    );
  }

  Future<AppealResponse> _appeal({required AppealRequest appealRequest}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(appealRequest.toJson());
    final _options = _setStreamType<Result<AppealResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/appeal',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AppealResponse _value;
    try {
      _value = AppealResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<AppealResponse>> appeal({
    required AppealRequest appealRequest,
  }) {
    return _ResultCallAdapter<AppealResponse>().adapt(
      () => _appeal(appealRequest: appealRequest),
    );
  }

  Future<ModerationBanResponse> _ban({required BanRequest banRequest}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(banRequest.toJson());
    final _options = _setStreamType<Result<ModerationBanResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/ban',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ModerationBanResponse _value;
    try {
      _value = ModerationBanResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ModerationBanResponse>> ban({required BanRequest banRequest}) {
    return _ResultCallAdapter<ModerationBanResponse>().adapt(
      () => _ban(banRequest: banRequest),
    );
  }

  Future<BlockUsersResponse> _blockUsers({
    required BlockUsersRequest blockUsersRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(blockUsersRequest.toJson());
    final _options = _setStreamType<Result<BlockUsersResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/users/block',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BlockUsersResponse _value;
    try {
      _value = BlockUsersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<BlockUsersResponse>> blockUsers({
    required BlockUsersRequest blockUsersRequest,
  }) {
    return _ResultCallAdapter<BlockUsersResponse>().adapt(
      () => _blockUsers(blockUsersRequest: blockUsersRequest),
    );
  }

  Future<BulkActionAppealsResponse> _bulkActionAppeals({
    required BulkActionAppealsRequest bulkActionAppealsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(bulkActionAppealsRequest.toJson());
    final _options = _setStreamType<Result<BulkActionAppealsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/appeals/bulk_action',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BulkActionAppealsResponse _value;
    try {
      _value = BulkActionAppealsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<BulkActionAppealsResponse>> bulkActionAppeals({
    required BulkActionAppealsRequest bulkActionAppealsRequest,
  }) {
    return _ResultCallAdapter<BulkActionAppealsResponse>().adapt(
      () => _bulkActionAppeals(
        bulkActionAppealsRequest: bulkActionAppealsRequest,
      ),
    );
  }

  Future<BulkDeleteActionConfigResponse> _bulkDeleteActionConfig({
    required BulkDeleteActionConfigRequest bulkDeleteActionConfigRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(bulkDeleteActionConfigRequest.toJson());
    final _options = _setStreamType<Result<BulkDeleteActionConfigResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/action_config/bulk_delete',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BulkDeleteActionConfigResponse _value;
    try {
      _value = BulkDeleteActionConfigResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<BulkDeleteActionConfigResponse>> bulkDeleteActionConfig({
    required BulkDeleteActionConfigRequest bulkDeleteActionConfigRequest,
  }) {
    return _ResultCallAdapter<BulkDeleteActionConfigResponse>().adapt(
      () => _bulkDeleteActionConfig(
        bulkDeleteActionConfigRequest: bulkDeleteActionConfigRequest,
      ),
    );
  }

  Future<BulkUpsertActionConfigResponse> _bulkUpsertActionConfig({
    required BulkUpsertActionConfigRequest bulkUpsertActionConfigRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(bulkUpsertActionConfigRequest.toJson());
    final _options = _setStreamType<Result<BulkUpsertActionConfigResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/action_config/bulk',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BulkUpsertActionConfigResponse _value;
    try {
      _value = BulkUpsertActionConfigResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<BulkUpsertActionConfigResponse>> bulkUpsertActionConfig({
    required BulkUpsertActionConfigRequest bulkUpsertActionConfigRequest,
  }) {
    return _ResultCallAdapter<BulkUpsertActionConfigResponse>().adapt(
      () => _bulkUpsertActionConfig(
        bulkUpsertActionConfigRequest: bulkUpsertActionConfigRequest,
      ),
    );
  }

  Future<PollVoteResponse> _castPollVote({
    required String messageId,
    required String pollId,
    CastPollVoteRequest? castPollVoteRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(castPollVoteRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<PollVoteResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/messages/${messageId}/polls/${pollId}/vote',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollVoteResponse _value;
    try {
      _value = PollVoteResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollVoteResponse>> castPollVote({
    required String messageId,
    required String pollId,
    CastPollVoteRequest? castPollVoteRequest,
  }) {
    return _ResultCallAdapter<PollVoteResponse>().adapt(
      () => _castPollVote(
        messageId: messageId,
        pollId: pollId,
        castPollVoteRequest: castPollVoteRequest,
      ),
    );
  }

  Future<CreateBlockListResponse> _createBlockList({
    required CreateBlockListRequest createBlockListRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createBlockListRequest.toJson());
    final _options = _setStreamType<Result<CreateBlockListResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/blocklists',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CreateBlockListResponse _value;
    try {
      _value = CreateBlockListResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<CreateBlockListResponse>> createBlockList({
    required CreateBlockListRequest createBlockListRequest,
  }) {
    return _ResultCallAdapter<CreateBlockListResponse>().adapt(
      () => _createBlockList(createBlockListRequest: createBlockListRequest),
    );
  }

  Future<DurationResponse> _createDevice({
    required CreateDeviceRequest createDeviceRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createDeviceRequest.toJson());
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/devices',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> createDevice({
    required CreateDeviceRequest createDeviceRequest,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _createDevice(createDeviceRequest: createDeviceRequest),
    );
  }

  Future<CreateDraftResponse> _createDraft({
    required String type,
    required String id,
    required CreateDraftRequest createDraftRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createDraftRequest.toJson());
    final _options = _setStreamType<Result<CreateDraftResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/draft',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CreateDraftResponse _value;
    try {
      _value = CreateDraftResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<CreateDraftResponse>> createDraft({
    required String type,
    required String id,
    required CreateDraftRequest createDraftRequest,
  }) {
    return _ResultCallAdapter<CreateDraftResponse>().adapt(
      () => _createDraft(
        type: type,
        id: id,
        createDraftRequest: createDraftRequest,
      ),
    );
  }

  Future<CreateGuestResponse> _createGuest({
    required CreateGuestRequest createGuestRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createGuestRequest.toJson());
    final _options = _setStreamType<Result<CreateGuestResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/guest',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CreateGuestResponse _value;
    try {
      _value = CreateGuestResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<CreateGuestResponse>> createGuest({
    required CreateGuestRequest createGuestRequest,
  }) {
    return _ResultCallAdapter<CreateGuestResponse>().adapt(
      () => _createGuest(createGuestRequest: createGuestRequest),
    );
  }

  Future<PollResponse> _createPoll({
    required CreatePollRequest createPollRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createPollRequest.toJson());
    final _options = _setStreamType<Result<PollResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollResponse _value;
    try {
      _value = PollResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollResponse>> createPoll({
    required CreatePollRequest createPollRequest,
  }) {
    return _ResultCallAdapter<PollResponse>().adapt(
      () => _createPoll(createPollRequest: createPollRequest),
    );
  }

  Future<PollOptionResponse> _createPollOption({
    required String pollId,
    required CreatePollOptionRequest createPollOptionRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createPollOptionRequest.toJson());
    final _options = _setStreamType<Result<PollOptionResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/${pollId}/options',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollOptionResponse _value;
    try {
      _value = PollOptionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollOptionResponse>> createPollOption({
    required String pollId,
    required CreatePollOptionRequest createPollOptionRequest,
  }) {
    return _ResultCallAdapter<PollOptionResponse>().adapt(
      () => _createPollOption(
        pollId: pollId,
        createPollOptionRequest: createPollOptionRequest,
      ),
    );
  }

  Future<QueueResponse> _createQueue({
    required CreateQueueRequest createQueueRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createQueueRequest.toJson());
    final _options = _setStreamType<Result<QueueResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/queues',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueueResponse _value;
    try {
      _value = QueueResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueueResponse>> createQueue({
    required CreateQueueRequest createQueueRequest,
  }) {
    return _ResultCallAdapter<QueueResponse>().adapt(
      () => _createQueue(createQueueRequest: createQueueRequest),
    );
  }

  Future<ReminderResponseData> _createReminder({
    required String messageId,
    CreateReminderRequest? createReminderRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createReminderRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<ReminderResponseData>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/messages/${messageId}/reminders',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ReminderResponseData _value;
    try {
      _value = ReminderResponseData.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ReminderResponseData>> createReminder({
    required String messageId,
    CreateReminderRequest? createReminderRequest,
  }) {
    return _ResultCallAdapter<ReminderResponseData>().adapt(
      () => _createReminder(
        messageId: messageId,
        createReminderRequest: createReminderRequest,
      ),
    );
  }

  Future<CreateUserGroupResponse> _createUserGroup({
    required CreateUserGroupRequest createUserGroupRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createUserGroupRequest.toJson());
    final _options = _setStreamType<Result<CreateUserGroupResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/usergroups',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CreateUserGroupResponse _value;
    try {
      _value = CreateUserGroupResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<CreateUserGroupResponse>> createUserGroup({
    required CreateUserGroupRequest createUserGroupRequest,
  }) {
    return _ResultCallAdapter<CreateUserGroupResponse>().adapt(
      () => _createUserGroup(createUserGroupRequest: createUserGroupRequest),
    );
  }

  Future<DeleteActionConfigResponse> _deleteActionConfig({
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DeleteActionConfigResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/action_config/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DeleteActionConfigResponse _value;
    try {
      _value = DeleteActionConfigResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DeleteActionConfigResponse>> deleteActionConfig({
    required String id,
  }) {
    return _ResultCallAdapter<DeleteActionConfigResponse>().adapt(
      () => _deleteActionConfig(id: id),
    );
  }

  Future<DurationResponse> _deleteBlockList({
    required String name,
    String? team,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'team': team};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/blocklists/${name}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteBlockList({
    required String name,
    String? team,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteBlockList(name: name, team: team),
    );
  }

  Future<DeleteChannelResponse> _deleteChannel({
    required String type,
    required String id,
    bool? hardDelete,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'hard_delete': hardDelete};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DeleteChannelResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DeleteChannelResponse _value;
    try {
      _value = DeleteChannelResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DeleteChannelResponse>> deleteChannel({
    required String type,
    required String id,
    bool? hardDelete,
  }) {
    return _ResultCallAdapter<DeleteChannelResponse>().adapt(
      () => _deleteChannel(type: type, id: id, hardDelete: hardDelete),
    );
  }

  Future<DurationResponse> _deleteChannelFile({
    required String type,
    required String id,
    String? url,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'url': url};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/file',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteChannelFile({
    required String type,
    required String id,
    String? url,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteChannelFile(type: type, id: id, url: url),
    );
  }

  Future<DurationResponse> _deleteChannelImage({
    required String type,
    required String id,
    String? url,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'url': url};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/image',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteChannelImage({
    required String type,
    required String id,
    String? url,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteChannelImage(type: type, id: id, url: url),
    );
  }

  Future<DeleteChannelsResponse> _deleteChannels({
    required DeleteChannelsRequest deleteChannelsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(deleteChannelsRequest.toJson());
    final _options = _setStreamType<Result<DeleteChannelsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/delete',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DeleteChannelsResponse _value;
    try {
      _value = DeleteChannelsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DeleteChannelsResponse>> deleteChannels({
    required DeleteChannelsRequest deleteChannelsRequest,
  }) {
    return _ResultCallAdapter<DeleteChannelsResponse>().adapt(
      () => _deleteChannels(deleteChannelsRequest: deleteChannelsRequest),
    );
  }

  Future<DeleteModerationConfigResponse> _deleteConfig({
    required String key,
    String? team,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'team': team};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DeleteModerationConfigResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/config/${key}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DeleteModerationConfigResponse _value;
    try {
      _value = DeleteModerationConfigResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DeleteModerationConfigResponse>> deleteConfig({
    required String key,
    String? team,
  }) {
    return _ResultCallAdapter<DeleteModerationConfigResponse>().adapt(
      () => _deleteConfig(key: key, team: team),
    );
  }

  Future<DurationResponse> _deleteDevice({required String id}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'id': id};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/devices',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteDevice({required String id}) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteDevice(id: id),
    );
  }

  Future<DurationResponse> _deleteDraft({
    required String type,
    required String id,
    String? parentId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'parent_id': parentId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/draft',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteDraft({
    required String type,
    required String id,
    String? parentId,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteDraft(type: type, id: id, parentId: parentId),
    );
  }

  Future<DurationResponse> _deleteFile({String? url}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'url': url};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/uploads/file',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteFile({String? url}) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteFile(url: url),
    );
  }

  Future<DurationResponse> _deleteImage({String? url}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'url': url};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/uploads/image',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteImage({String? url}) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteImage(url: url),
    );
  }

  Future<DeleteMessageResponse> _deleteMessage({
    required String id,
    bool? hard,
    bool? deleteForMe,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'hard': hard,
      r'delete_for_me': deleteForMe,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DeleteMessageResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/messages/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DeleteMessageResponse _value;
    try {
      _value = DeleteMessageResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DeleteMessageResponse>> deleteMessage({
    required String id,
    bool? hard,
    bool? deleteForMe,
  }) {
    return _ResultCallAdapter<DeleteMessageResponse>().adapt(
      () => _deleteMessage(id: id, hard: hard, deleteForMe: deleteForMe),
    );
  }

  Future<DurationResponse> _deletePoll({required String pollId}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/${pollId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deletePoll({required String pollId}) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deletePoll(pollId: pollId),
    );
  }

  Future<DurationResponse> _deletePollOption({
    required String pollId,
    required String optionId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/${pollId}/options/${optionId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deletePollOption({
    required String pollId,
    required String optionId,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deletePollOption(pollId: pollId, optionId: optionId),
    );
  }

  Future<PollVoteResponse> _deletePollVote({
    required String messageId,
    required String pollId,
    required String voteId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<PollVoteResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/messages/${messageId}/polls/${pollId}/vote/${voteId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollVoteResponse _value;
    try {
      _value = PollVoteResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollVoteResponse>> deletePollVote({
    required String messageId,
    required String pollId,
    required String voteId,
  }) {
    return _ResultCallAdapter<PollVoteResponse>().adapt(
      () =>
          _deletePollVote(messageId: messageId, pollId: pollId, voteId: voteId),
    );
  }

  Future<QueueResponse> _deleteQueue({required String id}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<QueueResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/queues/${id}/delete',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueueResponse _value;
    try {
      _value = QueueResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueueResponse>> deleteQueue({required String id}) {
    return _ResultCallAdapter<QueueResponse>().adapt(
      () => _deleteQueue(id: id),
    );
  }

  Future<DeleteReactionResponse> _deleteReaction({
    required String id,
    required String type,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DeleteReactionResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/messages/${id}/reaction/${type}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DeleteReactionResponse _value;
    try {
      _value = DeleteReactionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DeleteReactionResponse>> deleteReaction({
    required String id,
    required String type,
  }) {
    return _ResultCallAdapter<DeleteReactionResponse>().adapt(
      () => _deleteReaction(id: id, type: type),
    );
  }

  Future<DeleteReminderResponse> _deleteReminder({
    required String messageId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DeleteReminderResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/messages/${messageId}/reminders',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DeleteReminderResponse _value;
    try {
      _value = DeleteReminderResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DeleteReminderResponse>> deleteReminder({
    required String messageId,
  }) {
    return _ResultCallAdapter<DeleteReminderResponse>().adapt(
      () => _deleteReminder(messageId: messageId),
    );
  }

  Future<DurationResponse> _deleteUserGroup({
    required String id,
    String? teamId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'team_id': teamId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/usergroups/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteUserGroup({
    required String id,
    String? teamId,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteUserGroup(id: id, teamId: teamId),
    );
  }

  Future<FlagItemResponse> _flag({required FlagRequest flagRequest}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(flagRequest.toJson());
    final _options = _setStreamType<Result<FlagItemResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/flag',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late FlagItemResponse _value;
    try {
      _value = FlagItemResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<FlagItemResponse>> flag({required FlagRequest flagRequest}) {
    return _ResultCallAdapter<FlagItemResponse>().adapt(
      () => _flag(flagRequest: flagRequest),
    );
  }

  Future<GetActionConfigResponse> _getActionConfig({
    String? queueType,
    String? entityType,
    bool? excludeDefaults,
    bool? onlyDefaults,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'queue_type': queueType,
      r'entity_type': entityType,
      r'exclude_defaults': excludeDefaults,
      r'only_defaults': onlyDefaults,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetActionConfigResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/action_config',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetActionConfigResponse _value;
    try {
      _value = GetActionConfigResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetActionConfigResponse>> getActionConfig({
    String? queueType,
    String? entityType,
    bool? excludeDefaults,
    bool? onlyDefaults,
  }) {
    return _ResultCallAdapter<GetActionConfigResponse>().adapt(
      () => _getActionConfig(
        queueType: queueType,
        entityType: entityType,
        excludeDefaults: excludeDefaults,
        onlyDefaults: onlyDefaults,
      ),
    );
  }

  Future<GetApplicationResponse> _getApp() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetApplicationResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/app',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetApplicationResponse _value;
    try {
      _value = GetApplicationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetApplicationResponse>> getApp() {
    return _ResultCallAdapter<GetApplicationResponse>().adapt(() => _getApp());
  }

  Future<GetAppealResponse> _getAppeal({required String id}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetAppealResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/appeal/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetAppealResponse _value;
    try {
      _value = GetAppealResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetAppealResponse>> getAppeal({required String id}) {
    return _ResultCallAdapter<GetAppealResponse>().adapt(
      () => _getAppeal(id: id),
    );
  }

  Future<GetBlockedUsersResponse> _getBlockedUsers() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetBlockedUsersResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/users/block',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetBlockedUsersResponse _value;
    try {
      _value = GetBlockedUsersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetBlockedUsersResponse>> getBlockedUsers() {
    return _ResultCallAdapter<GetBlockedUsersResponse>().adapt(
      () => _getBlockedUsers(),
    );
  }

  Future<ChannelStateResponse> _getChannel({
    required String type,
    required String id,
    bool? state,
    int? messagesLimit,
    int? membersLimit,
    int? watchersLimit,
    String? messagesIdLt,
    String? messagesIdLte,
    String? messagesIdGt,
    String? messagesIdGte,
    String? messagesIdAround,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'state': state,
      r'messages_limit': messagesLimit,
      r'members_limit': membersLimit,
      r'watchers_limit': watchersLimit,
      r'messages_id_lt': messagesIdLt,
      r'messages_id_lte': messagesIdLte,
      r'messages_id_gt': messagesIdGt,
      r'messages_id_gte': messagesIdGte,
      r'messages_id_around': messagesIdAround,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<ChannelStateResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ChannelStateResponse _value;
    try {
      _value = ChannelStateResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ChannelStateResponse>> getChannel({
    required String type,
    required String id,
    bool? state,
    int? messagesLimit,
    int? membersLimit,
    int? watchersLimit,
    String? messagesIdLt,
    String? messagesIdLte,
    String? messagesIdGt,
    String? messagesIdGte,
    String? messagesIdAround,
  }) {
    return _ResultCallAdapter<ChannelStateResponse>().adapt(
      () => _getChannel(
        type: type,
        id: id,
        state: state,
        messagesLimit: messagesLimit,
        membersLimit: membersLimit,
        watchersLimit: watchersLimit,
        messagesIdLt: messagesIdLt,
        messagesIdLte: messagesIdLte,
        messagesIdGt: messagesIdGt,
        messagesIdGte: messagesIdGte,
        messagesIdAround: messagesIdAround,
      ),
    );
  }

  Future<GetConfigResponse> _getConfig({
    required String key,
    String? team,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'team': team};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetConfigResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/config/${key}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetConfigResponse _value;
    try {
      _value = GetConfigResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetConfigResponse>> getConfig({
    required String key,
    String? team,
  }) {
    return _ResultCallAdapter<GetConfigResponse>().adapt(
      () => _getConfig(key: key, team: team),
    );
  }

  Future<GetDraftResponse> _getDraft({
    required String type,
    required String id,
    String? parentId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'parent_id': parentId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetDraftResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/draft',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetDraftResponse _value;
    try {
      _value = GetDraftResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetDraftResponse>> getDraft({
    required String type,
    required String id,
    String? parentId,
  }) {
    return _ResultCallAdapter<GetDraftResponse>().adapt(
      () => _getDraft(type: type, id: id, parentId: parentId),
    );
  }

  Future<GetManyMessagesResponse> _getManyMessages({
    required String type,
    required String id,
    required List<String> ids,
    List<String>? memberCustomInclude,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'ids': ids,
      r'member_custom_include': memberCustomInclude,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetManyMessagesResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/messages',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetManyMessagesResponse _value;
    try {
      _value = GetManyMessagesResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetManyMessagesResponse>> getManyMessages({
    required String type,
    required String id,
    required List<String> ids,
    List<String>? memberCustomInclude,
  }) {
    return _ResultCallAdapter<GetManyMessagesResponse>().adapt(
      () => _getManyMessages(
        type: type,
        id: id,
        ids: ids,
        memberCustomInclude: memberCustomInclude,
      ),
    );
  }

  Future<GetMessageResponse> _getMessage({required String id}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetMessageResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/messages/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetMessageResponse _value;
    try {
      _value = GetMessageResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetMessageResponse>> getMessage({required String id}) {
    return _ResultCallAdapter<GetMessageResponse>().adapt(
      () => _getMessage(id: id),
    );
  }

  Future<GetOGResponse> _getOG({required String url}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'url': url};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetOGResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/og',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetOGResponse _value;
    try {
      _value = GetOGResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetOGResponse>> getOG({required String url}) {
    return _ResultCallAdapter<GetOGResponse>().adapt(() => _getOG(url: url));
  }

  Future<ChannelStateResponse> _getOrCreateChannel({
    required String type,
    required String id,
    ChannelGetOrCreateRequest? channelGetOrCreateRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(channelGetOrCreateRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<ChannelStateResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/query',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ChannelStateResponse _value;
    try {
      _value = ChannelStateResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ChannelStateResponse>> getOrCreateChannel({
    required String type,
    required String id,
    ChannelGetOrCreateRequest? channelGetOrCreateRequest,
  }) {
    return _ResultCallAdapter<ChannelStateResponse>().adapt(
      () => _getOrCreateChannel(
        type: type,
        id: id,
        channelGetOrCreateRequest: channelGetOrCreateRequest,
      ),
    );
  }

  Future<ChannelStateResponse> _getOrCreateDistinctChannel({
    required String type,
    ChannelGetOrCreateRequest? channelGetOrCreateRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(channelGetOrCreateRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<ChannelStateResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/query',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ChannelStateResponse _value;
    try {
      _value = ChannelStateResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ChannelStateResponse>> getOrCreateDistinctChannel({
    required String type,
    ChannelGetOrCreateRequest? channelGetOrCreateRequest,
  }) {
    return _ResultCallAdapter<ChannelStateResponse>().adapt(
      () => _getOrCreateDistinctChannel(
        type: type,
        channelGetOrCreateRequest: channelGetOrCreateRequest,
      ),
    );
  }

  Future<GetPinnedMessagesResponse> _getPinnedMessages({
    required String type,
    required String id,
    int? limit,
    int? offset,
    String? idGte,
    String? idGt,
    String? idLte,
    String? idLt,
    DateTime? pinnedAtAfterOrEqual,
    DateTime? pinnedAtAfter,
    DateTime? pinnedAtBeforeOrEqual,
    DateTime? pinnedAtBefore,
    String? idAround,
    DateTime? pinnedAtAround,
    List<SortParamRequest>? sort,
    List<String>? memberCustomInclude,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'limit': limit,
      r'offset': offset,
      r'id_gte': idGte,
      r'id_gt': idGt,
      r'id_lte': idLte,
      r'id_lt': idLt,
      r'pinned_at_after_or_equal': pinnedAtAfterOrEqual?.toIso8601String(),
      r'pinned_at_after': pinnedAtAfter?.toIso8601String(),
      r'pinned_at_before_or_equal': pinnedAtBeforeOrEqual?.toIso8601String(),
      r'pinned_at_before': pinnedAtBefore?.toIso8601String(),
      r'id_around': idAround,
      r'pinned_at_around': pinnedAtAround?.toIso8601String(),
      r'sort': sort,
      r'member_custom_include': memberCustomInclude,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetPinnedMessagesResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/pinned_messages',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetPinnedMessagesResponse _value;
    try {
      _value = GetPinnedMessagesResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetPinnedMessagesResponse>> getPinnedMessages({
    required String type,
    required String id,
    int? limit,
    int? offset,
    String? idGte,
    String? idGt,
    String? idLte,
    String? idLt,
    DateTime? pinnedAtAfterOrEqual,
    DateTime? pinnedAtAfter,
    DateTime? pinnedAtBeforeOrEqual,
    DateTime? pinnedAtBefore,
    String? idAround,
    DateTime? pinnedAtAround,
    List<SortParamRequest>? sort,
    List<String>? memberCustomInclude,
  }) {
    return _ResultCallAdapter<GetPinnedMessagesResponse>().adapt(
      () => _getPinnedMessages(
        type: type,
        id: id,
        limit: limit,
        offset: offset,
        idGte: idGte,
        idGt: idGt,
        idLte: idLte,
        idLt: idLt,
        pinnedAtAfterOrEqual: pinnedAtAfterOrEqual,
        pinnedAtAfter: pinnedAtAfter,
        pinnedAtBeforeOrEqual: pinnedAtBeforeOrEqual,
        pinnedAtBefore: pinnedAtBefore,
        idAround: idAround,
        pinnedAtAround: pinnedAtAround,
        sort: sort,
        memberCustomInclude: memberCustomInclude,
      ),
    );
  }

  Future<PollResponse> _getPoll({required String pollId}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<PollResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/${pollId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollResponse _value;
    try {
      _value = PollResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollResponse>> getPoll({required String pollId}) {
    return _ResultCallAdapter<PollResponse>().adapt(
      () => _getPoll(pollId: pollId),
    );
  }

  Future<PollOptionResponse> _getPollOption({
    required String pollId,
    required String optionId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<PollOptionResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/${pollId}/options/${optionId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollOptionResponse _value;
    try {
      _value = PollOptionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollOptionResponse>> getPollOption({
    required String pollId,
    required String optionId,
  }) {
    return _ResultCallAdapter<PollOptionResponse>().adapt(
      () => _getPollOption(pollId: pollId, optionId: optionId),
    );
  }

  Future<QueueResponse> _getQueue({required String id}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<QueueResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/queues/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueueResponse _value;
    try {
      _value = QueueResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueueResponse>> getQueue({required String id}) {
    return _ResultCallAdapter<QueueResponse>().adapt(() => _getQueue(id: id));
  }

  Future<GetReactionsResponse> _getReactions({
    required String id,
    int? limit,
    int? offset,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'limit': limit,
      r'offset': offset,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetReactionsResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/messages/${id}/reactions',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetReactionsResponse _value;
    try {
      _value = GetReactionsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetReactionsResponse>> getReactions({
    required String id,
    int? limit,
    int? offset,
  }) {
    return _ResultCallAdapter<GetReactionsResponse>().adapt(
      () => _getReactions(id: id, limit: limit, offset: offset),
    );
  }

  Future<GetRepliesResponse> _getReplies({
    required String parentId,
    int? limit,
    String? idGte,
    String? idGt,
    String? idLte,
    String? idLt,
    String? idAround,
    List<SortParamRequest>? sort,
    List<String>? memberCustomInclude,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'limit': limit,
      r'id_gte': idGte,
      r'id_gt': idGt,
      r'id_lte': idLte,
      r'id_lt': idLt,
      r'id_around': idAround,
      r'sort': sort,
      r'member_custom_include': memberCustomInclude,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetRepliesResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/messages/${parentId}/replies',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetRepliesResponse _value;
    try {
      _value = GetRepliesResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetRepliesResponse>> getReplies({
    required String parentId,
    int? limit,
    String? idGte,
    String? idGt,
    String? idLte,
    String? idLt,
    String? idAround,
    List<SortParamRequest>? sort,
    List<String>? memberCustomInclude,
  }) {
    return _ResultCallAdapter<GetRepliesResponse>().adapt(
      () => _getReplies(
        parentId: parentId,
        limit: limit,
        idGte: idGte,
        idGt: idGt,
        idLte: idLte,
        idLt: idLt,
        idAround: idAround,
        sort: sort,
        memberCustomInclude: memberCustomInclude,
      ),
    );
  }

  Future<GetThreadResponse> _getThread({
    required String messageId,
    bool? watch,
    int? replyLimit,
    int? participantLimit,
    int? memberLimit,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'watch': watch,
      r'reply_limit': replyLimit,
      r'participant_limit': participantLimit,
      r'member_limit': memberLimit,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetThreadResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/threads/${messageId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetThreadResponse _value;
    try {
      _value = GetThreadResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetThreadResponse>> getThread({
    required String messageId,
    bool? watch,
    int? replyLimit,
    int? participantLimit,
    int? memberLimit,
  }) {
    return _ResultCallAdapter<GetThreadResponse>().adapt(
      () => _getThread(
        messageId: messageId,
        watch: watch,
        replyLimit: replyLimit,
        participantLimit: participantLimit,
        memberLimit: memberLimit,
      ),
    );
  }

  Future<GetUserGroupResponse> _getUserGroup({
    required String id,
    String? teamId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'team_id': teamId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<GetUserGroupResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/usergroups/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetUserGroupResponse _value;
    try {
      _value = GetUserGroupResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GetUserGroupResponse>> getUserGroup({
    required String id,
    String? teamId,
  }) {
    return _ResultCallAdapter<GetUserGroupResponse>().adapt(
      () => _getUserGroup(id: id, teamId: teamId),
    );
  }

  Future<SharedLocationsResponse> _getUserLiveLocations() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<SharedLocationsResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/users/live_locations',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SharedLocationsResponse _value;
    try {
      _value = SharedLocationsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<SharedLocationsResponse>> getUserLiveLocations() {
    return _ResultCallAdapter<SharedLocationsResponse>().adapt(
      () => _getUserLiveLocations(),
    );
  }

  Future<GroupedQueryChannelsResponse> _groupedQueryChannels({
    GroupedQueryChannelsRequest? groupedQueryChannelsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(groupedQueryChannelsRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<GroupedQueryChannelsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/grouped',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GroupedQueryChannelsResponse _value;
    try {
      _value = GroupedQueryChannelsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<GroupedQueryChannelsResponse>> groupedQueryChannels({
    GroupedQueryChannelsRequest? groupedQueryChannelsRequest,
  }) {
    return _ResultCallAdapter<GroupedQueryChannelsResponse>().adapt(
      () => _groupedQueryChannels(
        groupedQueryChannelsRequest: groupedQueryChannelsRequest,
      ),
    );
  }

  Future<HideChannelResponse> _hideChannel({
    required String type,
    required String id,
    HideChannelRequest? hideChannelRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(hideChannelRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<HideChannelResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/hide',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late HideChannelResponse _value;
    try {
      _value = HideChannelResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<HideChannelResponse>> hideChannel({
    required String type,
    required String id,
    HideChannelRequest? hideChannelRequest,
  }) {
    return _ResultCallAdapter<HideChannelResponse>().adapt(
      () => _hideChannel(
        type: type,
        id: id,
        hideChannelRequest: hideChannelRequest,
      ),
    );
  }

  Future<ImportBlockListResponse> _importBlockList({
    required String id,
    required ImportBlockListRequest importBlockListRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(importBlockListRequest.toJson());
    final _options = _setStreamType<Result<ImportBlockListResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/blocklists/${id}/import',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ImportBlockListResponse _value;
    try {
      _value = ImportBlockListResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ImportBlockListResponse>> importBlockList({
    required String id,
    required ImportBlockListRequest importBlockListRequest,
  }) {
    return _ResultCallAdapter<ImportBlockListResponse>().adapt(
      () => _importBlockList(
        id: id,
        importBlockListRequest: importBlockListRequest,
      ),
    );
  }

  Future<ListBlockListResponse> _listBlockLists({
    String? team,
    String? cursor,
    int? limit,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'team': team,
      r'cursor': cursor,
      r'limit': limit,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<ListBlockListResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/blocklists',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ListBlockListResponse _value;
    try {
      _value = ListBlockListResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ListBlockListResponse>> listBlockLists({
    String? team,
    String? cursor,
    int? limit,
  }) {
    return _ResultCallAdapter<ListBlockListResponse>().adapt(
      () => _listBlockLists(team: team, cursor: cursor, limit: limit),
    );
  }

  Future<ListDevicesResponse> _listDevices() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<ListDevicesResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/devices',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ListDevicesResponse _value;
    try {
      _value = ListDevicesResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ListDevicesResponse>> listDevices() {
    return _ResultCallAdapter<ListDevicesResponse>().adapt(
      () => _listDevices(),
    );
  }

  Future<ListQueuesResponse> _listQueues() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<ListQueuesResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/queues',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ListQueuesResponse _value;
    try {
      _value = ListQueuesResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ListQueuesResponse>> listQueues() {
    return _ResultCallAdapter<ListQueuesResponse>().adapt(() => _listQueues());
  }

  Future<ListUserGroupsResponse> _listUserGroups({
    int? limit,
    String? idGt,
    String? createdAtGt,
    String? teamId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'limit': limit,
      r'id_gt': idGt,
      r'created_at_gt': createdAtGt,
      r'team_id': teamId,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<ListUserGroupsResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/usergroups',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ListUserGroupsResponse _value;
    try {
      _value = ListUserGroupsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ListUserGroupsResponse>> listUserGroups({
    int? limit,
    String? idGt,
    String? createdAtGt,
    String? teamId,
  }) {
    return _ResultCallAdapter<ListUserGroupsResponse>().adapt(
      () => _listUserGroups(
        limit: limit,
        idGt: idGt,
        createdAtGt: createdAtGt,
        teamId: teamId,
      ),
    );
  }

  Future<void> _longPoll({WSAuthMessage? json}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'json': json?.toJson()};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<void>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/longpoll',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<Result<void>> longPoll({WSAuthMessage? json}) {
    return _ResultCallAdapter<void>().adapt(() => _longPoll(json: json));
  }

  Future<MarkReadResponse> _markChannelsRead({
    MarkChannelsReadRequest? markChannelsReadRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(markChannelsReadRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<MarkReadResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/read',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MarkReadResponse _value;
    try {
      _value = MarkReadResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<MarkReadResponse>> markChannelsRead({
    MarkChannelsReadRequest? markChannelsReadRequest,
  }) {
    return _ResultCallAdapter<MarkReadResponse>().adapt(
      () => _markChannelsRead(markChannelsReadRequest: markChannelsReadRequest),
    );
  }

  Future<MarkDeliveredResponse> _markDelivered({
    MarkDeliveredRequest? markDeliveredRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(markDeliveredRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<MarkDeliveredResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/delivered',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MarkDeliveredResponse _value;
    try {
      _value = MarkDeliveredResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<MarkDeliveredResponse>> markDelivered({
    MarkDeliveredRequest? markDeliveredRequest,
  }) {
    return _ResultCallAdapter<MarkDeliveredResponse>().adapt(
      () => _markDelivered(markDeliveredRequest: markDeliveredRequest),
    );
  }

  Future<MarkReadResponse> _markRead({
    required String type,
    required String id,
    MarkReadRequest? markReadRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(markReadRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<MarkReadResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/read',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MarkReadResponse _value;
    try {
      _value = MarkReadResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<MarkReadResponse>> markRead({
    required String type,
    required String id,
    MarkReadRequest? markReadRequest,
  }) {
    return _ResultCallAdapter<MarkReadResponse>().adapt(
      () => _markRead(type: type, id: id, markReadRequest: markReadRequest),
    );
  }

  Future<DurationResponse> _markUnread({
    required String type,
    required String id,
    MarkUnreadRequest? markUnreadRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(markUnreadRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/unread',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> markUnread({
    required String type,
    required String id,
    MarkUnreadRequest? markUnreadRequest,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () =>
          _markUnread(type: type, id: id, markUnreadRequest: markUnreadRequest),
    );
  }

  Future<MuteResponse> _mute({required MuteRequest muteRequest}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(muteRequest.toJson());
    final _options = _setStreamType<Result<MuteResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/mute',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MuteResponse _value;
    try {
      _value = MuteResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<MuteResponse>> mute({required MuteRequest muteRequest}) {
    return _ResultCallAdapter<MuteResponse>().adapt(
      () => _mute(muteRequest: muteRequest),
    );
  }

  Future<MuteChannelResponse> _muteChannel({
    MuteChannelRequest? muteChannelRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(muteChannelRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<MuteChannelResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/moderation/mute/channel',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MuteChannelResponse _value;
    try {
      _value = MuteChannelResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<MuteChannelResponse>> muteChannel({
    MuteChannelRequest? muteChannelRequest,
  }) {
    return _ResultCallAdapter<MuteChannelResponse>().adapt(
      () => _muteChannel(muteChannelRequest: muteChannelRequest),
    );
  }

  Future<QueryAppealsResponse> _queryAppeals({
    QueryAppealsRequest? queryAppealsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryAppealsRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<QueryAppealsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/appeals',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryAppealsResponse _value;
    try {
      _value = QueryAppealsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryAppealsResponse>> queryAppeals({
    QueryAppealsRequest? queryAppealsRequest,
  }) {
    return _ResultCallAdapter<QueryAppealsResponse>().adapt(
      () => _queryAppeals(queryAppealsRequest: queryAppealsRequest),
    );
  }

  Future<QueryBannedUsersResponse> _queryBannedUsers({
    QueryBannedUsersPayload? payload,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'payload': payload?.toJson()};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<QueryBannedUsersResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/query_banned_users',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryBannedUsersResponse _value;
    try {
      _value = QueryBannedUsersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryBannedUsersResponse>> queryBannedUsers({
    QueryBannedUsersPayload? payload,
  }) {
    return _ResultCallAdapter<QueryBannedUsersResponse>().adapt(
      () => _queryBannedUsers(payload: payload),
    );
  }

  Future<QueryChannelsResponse> _queryChannels({
    QueryChannelsRequest? queryChannelsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryChannelsRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<QueryChannelsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryChannelsResponse _value;
    try {
      _value = QueryChannelsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryChannelsResponse>> queryChannels({
    QueryChannelsRequest? queryChannelsRequest,
  }) {
    return _ResultCallAdapter<QueryChannelsResponse>().adapt(
      () => _queryChannels(queryChannelsRequest: queryChannelsRequest),
    );
  }

  Future<QueryDraftsResponse> _queryDrafts({
    QueryDraftsRequest? queryDraftsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryDraftsRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<QueryDraftsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/drafts/query',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryDraftsResponse _value;
    try {
      _value = QueryDraftsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryDraftsResponse>> queryDrafts({
    QueryDraftsRequest? queryDraftsRequest,
  }) {
    return _ResultCallAdapter<QueryDraftsResponse>().adapt(
      () => _queryDrafts(queryDraftsRequest: queryDraftsRequest),
    );
  }

  Future<QueryFutureChannelBansResponse> _queryFutureChannelBans({
    QueryFutureChannelBansPayload? payload,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'payload': payload?.toJson()};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<QueryFutureChannelBansResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/query_future_channel_bans',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryFutureChannelBansResponse _value;
    try {
      _value = QueryFutureChannelBansResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryFutureChannelBansResponse>> queryFutureChannelBans({
    QueryFutureChannelBansPayload? payload,
  }) {
    return _ResultCallAdapter<QueryFutureChannelBansResponse>().adapt(
      () => _queryFutureChannelBans(payload: payload),
    );
  }

  Future<MembersResponse> _queryMembers({QueryMembersPayload? payload}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'payload': payload?.toJson()};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<MembersResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/members',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MembersResponse _value;
    try {
      _value = MembersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<MembersResponse>> queryMembers({QueryMembersPayload? payload}) {
    return _ResultCallAdapter<MembersResponse>().adapt(
      () => _queryMembers(payload: payload),
    );
  }

  Future<QueryMessageFlagsResponse> _queryMessageFlags({
    QueryMessageFlagsPayload? payload,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'payload': payload?.toJson()};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<QueryMessageFlagsResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/moderation/flags/message',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryMessageFlagsResponse _value;
    try {
      _value = QueryMessageFlagsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryMessageFlagsResponse>> queryMessageFlags({
    QueryMessageFlagsPayload? payload,
  }) {
    return _ResultCallAdapter<QueryMessageFlagsResponse>().adapt(
      () => _queryMessageFlags(payload: payload),
    );
  }

  Future<QueryModerationConfigsResponse> _queryModerationConfigs({
    QueryModerationConfigsRequest? queryModerationConfigsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(
      queryModerationConfigsRequest?.toJson() ?? <String, dynamic>{},
    );
    final _options = _setStreamType<Result<QueryModerationConfigsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/configs',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryModerationConfigsResponse _value;
    try {
      _value = QueryModerationConfigsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryModerationConfigsResponse>> queryModerationConfigs({
    QueryModerationConfigsRequest? queryModerationConfigsRequest,
  }) {
    return _ResultCallAdapter<QueryModerationConfigsResponse>().adapt(
      () => _queryModerationConfigs(
        queryModerationConfigsRequest: queryModerationConfigsRequest,
      ),
    );
  }

  Future<PollVotesResponse> _queryPollVotes({
    required String pollId,
    QueryPollVotesRequest? queryPollVotesRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryPollVotesRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<PollVotesResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/${pollId}/votes',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollVotesResponse _value;
    try {
      _value = PollVotesResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollVotesResponse>> queryPollVotes({
    required String pollId,
    QueryPollVotesRequest? queryPollVotesRequest,
  }) {
    return _ResultCallAdapter<PollVotesResponse>().adapt(
      () => _queryPollVotes(
        pollId: pollId,
        queryPollVotesRequest: queryPollVotesRequest,
      ),
    );
  }

  Future<QueryPollsResponse> _queryPolls({
    QueryPollsRequest? queryPollsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryPollsRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<QueryPollsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/query',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryPollsResponse _value;
    try {
      _value = QueryPollsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryPollsResponse>> queryPolls({
    QueryPollsRequest? queryPollsRequest,
  }) {
    return _ResultCallAdapter<QueryPollsResponse>().adapt(
      () => _queryPolls(queryPollsRequest: queryPollsRequest),
    );
  }

  Future<QueryReactionsResponse> _queryReactions({
    required String id,
    QueryReactionsRequest? queryReactionsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryReactionsRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<QueryReactionsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/messages/${id}/reactions',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryReactionsResponse _value;
    try {
      _value = QueryReactionsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryReactionsResponse>> queryReactions({
    required String id,
    QueryReactionsRequest? queryReactionsRequest,
  }) {
    return _ResultCallAdapter<QueryReactionsResponse>().adapt(
      () =>
          _queryReactions(id: id, queryReactionsRequest: queryReactionsRequest),
    );
  }

  Future<QueryRemindersResponse> _queryReminders({
    QueryRemindersRequest? queryRemindersRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryRemindersRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<QueryRemindersResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/reminders/query',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryRemindersResponse _value;
    try {
      _value = QueryRemindersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryRemindersResponse>> queryReminders({
    QueryRemindersRequest? queryRemindersRequest,
  }) {
    return _ResultCallAdapter<QueryRemindersResponse>().adapt(
      () => _queryReminders(queryRemindersRequest: queryRemindersRequest),
    );
  }

  Future<QueryReviewQueueResponse> _queryReviewQueue({
    QueryReviewQueueRequest? queryReviewQueueRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryReviewQueueRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<QueryReviewQueueResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/review_queue',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryReviewQueueResponse _value;
    try {
      _value = QueryReviewQueueResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryReviewQueueResponse>> queryReviewQueue({
    QueryReviewQueueRequest? queryReviewQueueRequest,
  }) {
    return _ResultCallAdapter<QueryReviewQueueResponse>().adapt(
      () => _queryReviewQueue(queryReviewQueueRequest: queryReviewQueueRequest),
    );
  }

  Future<QueryThreadsResponse> _queryThreads({
    QueryThreadsRequest? queryThreadsRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(queryThreadsRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<QueryThreadsResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/threads',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryThreadsResponse _value;
    try {
      _value = QueryThreadsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryThreadsResponse>> queryThreads({
    QueryThreadsRequest? queryThreadsRequest,
  }) {
    return _ResultCallAdapter<QueryThreadsResponse>().adapt(
      () => _queryThreads(queryThreadsRequest: queryThreadsRequest),
    );
  }

  Future<QueryUsersResponse> _queryUsers({QueryUsersPayload? payload}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'payload': payload?.toJson()};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<QueryUsersResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/users',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueryUsersResponse _value;
    try {
      _value = QueryUsersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueryUsersResponse>> queryUsers({QueryUsersPayload? payload}) {
    return _ResultCallAdapter<QueryUsersResponse>().adapt(
      () => _queryUsers(payload: payload),
    );
  }

  Future<RemoveUserGroupMembersResponse> _removeUserGroupMembers({
    required String id,
    required RemoveUserGroupMembersRequest removeUserGroupMembersRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(removeUserGroupMembersRequest.toJson());
    final _options = _setStreamType<Result<RemoveUserGroupMembersResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/usergroups/${id}/members/delete',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RemoveUserGroupMembersResponse _value;
    try {
      _value = RemoveUserGroupMembersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<RemoveUserGroupMembersResponse>> removeUserGroupMembers({
    required String id,
    required RemoveUserGroupMembersRequest removeUserGroupMembersRequest,
  }) {
    return _ResultCallAdapter<RemoveUserGroupMembersResponse>().adapt(
      () => _removeUserGroupMembers(
        id: id,
        removeUserGroupMembersRequest: removeUserGroupMembersRequest,
      ),
    );
  }

  Future<MessageActionResponse> _runMessageAction({
    required String id,
    required MessageActionRequest messageActionRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(messageActionRequest.toJson());
    final _options = _setStreamType<Result<MessageActionResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/messages/${id}/action',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MessageActionResponse _value;
    try {
      _value = MessageActionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<MessageActionResponse>> runMessageAction({
    required String id,
    required MessageActionRequest messageActionRequest,
  }) {
    return _ResultCallAdapter<MessageActionResponse>().adapt(
      () =>
          _runMessageAction(id: id, messageActionRequest: messageActionRequest),
    );
  }

  Future<SearchResponse> _search({SearchPayload? payload}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'payload': payload?.toJson()};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<SearchResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/search',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SearchResponse _value;
    try {
      _value = SearchResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<SearchResponse>> search({SearchPayload? payload}) {
    return _ResultCallAdapter<SearchResponse>().adapt(
      () => _search(payload: payload),
    );
  }

  Future<SearchRolesResponse> _searchRoles({
    required String query,
    int? limit,
    String? nameGt,
    String? roleType,
    bool? includeGlobalRoles,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'query': query,
      r'limit': limit,
      r'name_gt': nameGt,
      r'role_type': roleType,
      r'include_global_roles': includeGlobalRoles,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<SearchRolesResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/roles/search',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SearchRolesResponse _value;
    try {
      _value = SearchRolesResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<SearchRolesResponse>> searchRoles({
    required String query,
    int? limit,
    String? nameGt,
    String? roleType,
    bool? includeGlobalRoles,
  }) {
    return _ResultCallAdapter<SearchRolesResponse>().adapt(
      () => _searchRoles(
        query: query,
        limit: limit,
        nameGt: nameGt,
        roleType: roleType,
        includeGlobalRoles: includeGlobalRoles,
      ),
    );
  }

  Future<SearchUserGroupsResponse> _searchUserGroups({
    required String query,
    int? limit,
    String? nameGt,
    String? idGt,
    String? teamId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'query': query,
      r'limit': limit,
      r'name_gt': nameGt,
      r'id_gt': idGt,
      r'team_id': teamId,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<SearchUserGroupsResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/usergroups/search',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SearchUserGroupsResponse _value;
    try {
      _value = SearchUserGroupsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<SearchUserGroupsResponse>> searchUserGroups({
    required String query,
    int? limit,
    String? nameGt,
    String? idGt,
    String? teamId,
  }) {
    return _ResultCallAdapter<SearchUserGroupsResponse>().adapt(
      () => _searchUserGroups(
        query: query,
        limit: limit,
        nameGt: nameGt,
        idGt: idGt,
        teamId: teamId,
      ),
    );
  }

  Future<EventResponse> _sendEvent({
    required String type,
    required String id,
    required SendEventRequest sendEventRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(sendEventRequest.toJson());
    final _options = _setStreamType<Result<EventResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/event',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late EventResponse _value;
    try {
      _value = EventResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<EventResponse>> sendEvent({
    required String type,
    required String id,
    required SendEventRequest sendEventRequest,
  }) {
    return _ResultCallAdapter<EventResponse>().adapt(
      () => _sendEvent(type: type, id: id, sendEventRequest: sendEventRequest),
    );
  }

  Future<SendMessageResponse> _sendMessage({
    required String type,
    required String id,
    required SendMessageRequest sendMessageRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(sendMessageRequest.toJson());
    final _options = _setStreamType<Result<SendMessageResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/message',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SendMessageResponse _value;
    try {
      _value = SendMessageResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<SendMessageResponse>> sendMessage({
    required String type,
    required String id,
    required SendMessageRequest sendMessageRequest,
  }) {
    return _ResultCallAdapter<SendMessageResponse>().adapt(
      () => _sendMessage(
        type: type,
        id: id,
        sendMessageRequest: sendMessageRequest,
      ),
    );
  }

  Future<SendReactionResponse> _sendReaction({
    required String id,
    required SendReactionRequest sendReactionRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(sendReactionRequest.toJson());
    final _options = _setStreamType<Result<SendReactionResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/messages/${id}/reaction',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SendReactionResponse _value;
    try {
      _value = SendReactionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<SendReactionResponse>> sendReaction({
    required String id,
    required SendReactionRequest sendReactionRequest,
  }) {
    return _ResultCallAdapter<SendReactionResponse>().adapt(
      () => _sendReaction(id: id, sendReactionRequest: sendReactionRequest),
    );
  }

  Future<ShowChannelResponse> _showChannel({
    required String type,
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<ShowChannelResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/show',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ShowChannelResponse _value;
    try {
      _value = ShowChannelResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ShowChannelResponse>> showChannel({
    required String type,
    required String id,
  }) {
    return _ResultCallAdapter<ShowChannelResponse>().adapt(
      () => _showChannel(type: type, id: id),
    );
  }

  Future<DurationResponse> _stopWatchingChannel({
    required String type,
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/stop-watching',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> stopWatchingChannel({
    required String type,
    required String id,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _stopWatchingChannel(type: type, id: id),
    );
  }

  Future<SubmitActionResponse> _submitAction({
    required SubmitActionRequest submitActionRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(submitActionRequest.toJson());
    final _options = _setStreamType<Result<SubmitActionResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/submit_action',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SubmitActionResponse _value;
    try {
      _value = SubmitActionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<SubmitActionResponse>> submitAction({
    required SubmitActionRequest submitActionRequest,
  }) {
    return _ResultCallAdapter<SubmitActionResponse>().adapt(
      () => _submitAction(submitActionRequest: submitActionRequest),
    );
  }

  Future<SyncResponse> _sync({
    bool? withInaccessibleCids,
    bool? watch,
    required SyncRequest syncRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'with_inaccessible_cids': withInaccessibleCids,
      r'watch': watch,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(syncRequest.toJson());
    final _options = _setStreamType<Result<SyncResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/sync',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SyncResponse _value;
    try {
      _value = SyncResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<SyncResponse>> sync({
    bool? withInaccessibleCids,
    bool? watch,
    required SyncRequest syncRequest,
  }) {
    return _ResultCallAdapter<SyncResponse>().adapt(
      () => _sync(
        withInaccessibleCids: withInaccessibleCids,
        watch: watch,
        syncRequest: syncRequest,
      ),
    );
  }

  Future<MessageActionResponse> _translateMessage({
    required String id,
    required TranslateMessageRequest translateMessageRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(translateMessageRequest.toJson());
    final _options = _setStreamType<Result<MessageActionResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/messages/${id}/translate',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MessageActionResponse _value;
    try {
      _value = MessageActionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<MessageActionResponse>> translateMessage({
    required String id,
    required TranslateMessageRequest translateMessageRequest,
  }) {
    return _ResultCallAdapter<MessageActionResponse>().adapt(
      () => _translateMessage(
        id: id,
        translateMessageRequest: translateMessageRequest,
      ),
    );
  }

  Future<TruncateChannelResponse> _truncateChannel({
    required String type,
    required String id,
    TruncateChannelRequest? truncateChannelRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(truncateChannelRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<TruncateChannelResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/truncate',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TruncateChannelResponse _value;
    try {
      _value = TruncateChannelResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<TruncateChannelResponse>> truncateChannel({
    required String type,
    required String id,
    TruncateChannelRequest? truncateChannelRequest,
  }) {
    return _ResultCallAdapter<TruncateChannelResponse>().adapt(
      () => _truncateChannel(
        type: type,
        id: id,
        truncateChannelRequest: truncateChannelRequest,
      ),
    );
  }

  Future<UnblockUsersResponse> _unblockUsers({
    required UnblockUsersRequest unblockUsersRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(unblockUsersRequest.toJson());
    final _options = _setStreamType<Result<UnblockUsersResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/users/unblock',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UnblockUsersResponse _value;
    try {
      _value = UnblockUsersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UnblockUsersResponse>> unblockUsers({
    required UnblockUsersRequest unblockUsersRequest,
  }) {
    return _ResultCallAdapter<UnblockUsersResponse>().adapt(
      () => _unblockUsers(unblockUsersRequest: unblockUsersRequest),
    );
  }

  Future<UnmuteResponse> _unmute({required UnmuteRequest unmuteRequest}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(unmuteRequest.toJson());
    final _options = _setStreamType<Result<UnmuteResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/unmute',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UnmuteResponse _value;
    try {
      _value = UnmuteResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UnmuteResponse>> unmute({
    required UnmuteRequest unmuteRequest,
  }) {
    return _ResultCallAdapter<UnmuteResponse>().adapt(
      () => _unmute(unmuteRequest: unmuteRequest),
    );
  }

  Future<UnmuteResponse> _unmuteChannel({
    UnmuteChannelRequest? unmuteChannelRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(unmuteChannelRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<UnmuteResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/moderation/unmute/channel',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UnmuteResponse _value;
    try {
      _value = UnmuteResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UnmuteResponse>> unmuteChannel({
    UnmuteChannelRequest? unmuteChannelRequest,
  }) {
    return _ResultCallAdapter<UnmuteResponse>().adapt(
      () => _unmuteChannel(unmuteChannelRequest: unmuteChannelRequest),
    );
  }

  Future<WrappedUnreadCountsResponse> _unreadCounts() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<WrappedUnreadCountsResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/unread',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late WrappedUnreadCountsResponse _value;
    try {
      _value = WrappedUnreadCountsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<WrappedUnreadCountsResponse>> unreadCounts() {
    return _ResultCallAdapter<WrappedUnreadCountsResponse>().adapt(
      () => _unreadCounts(),
    );
  }

  Future<UpdateBlockListResponse> _updateBlockList({
    required String name,
    UpdateBlockListRequest? updateBlockListRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateBlockListRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<UpdateBlockListResponse>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/blocklists/${name}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateBlockListResponse _value;
    try {
      _value = UpdateBlockListResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateBlockListResponse>> updateBlockList({
    required String name,
    UpdateBlockListRequest? updateBlockListRequest,
  }) {
    return _ResultCallAdapter<UpdateBlockListResponse>().adapt(
      () => _updateBlockList(
        name: name,
        updateBlockListRequest: updateBlockListRequest,
      ),
    );
  }

  Future<UpdateChannelResponse> _updateChannel({
    required String type,
    required String id,
    UpdateChannelRequest? updateChannelRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateChannelRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<UpdateChannelResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateChannelResponse _value;
    try {
      _value = UpdateChannelResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateChannelResponse>> updateChannel({
    required String type,
    required String id,
    UpdateChannelRequest? updateChannelRequest,
  }) {
    return _ResultCallAdapter<UpdateChannelResponse>().adapt(
      () => _updateChannel(
        type: type,
        id: id,
        updateChannelRequest: updateChannelRequest,
      ),
    );
  }

  Future<UpdateChannelPartialResponse> _updateChannelPartial({
    required String type,
    required String id,
    UpdateChannelPartialRequest? updateChannelPartialRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateChannelPartialRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<UpdateChannelPartialResponse>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateChannelPartialResponse _value;
    try {
      _value = UpdateChannelPartialResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateChannelPartialResponse>> updateChannelPartial({
    required String type,
    required String id,
    UpdateChannelPartialRequest? updateChannelPartialRequest,
  }) {
    return _ResultCallAdapter<UpdateChannelPartialResponse>().adapt(
      () => _updateChannelPartial(
        type: type,
        id: id,
        updateChannelPartialRequest: updateChannelPartialRequest,
      ),
    );
  }

  Future<SharedLocationResponse> _updateLiveLocation({
    required UpdateLiveLocationRequest updateLiveLocationRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateLiveLocationRequest.toJson());
    final _options = _setStreamType<Result<SharedLocationResponse>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/users/live_locations',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SharedLocationResponse _value;
    try {
      _value = SharedLocationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<SharedLocationResponse>> updateLiveLocation({
    required UpdateLiveLocationRequest updateLiveLocationRequest,
  }) {
    return _ResultCallAdapter<SharedLocationResponse>().adapt(
      () => _updateLiveLocation(
        updateLiveLocationRequest: updateLiveLocationRequest,
      ),
    );
  }

  Future<UpdateMemberPartialResponse> _updateMemberPartial({
    required String type,
    required String id,
    UpdateMemberPartialRequest? updateMemberPartialRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateMemberPartialRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<UpdateMemberPartialResponse>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/member',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateMemberPartialResponse _value;
    try {
      _value = UpdateMemberPartialResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateMemberPartialResponse>> updateMemberPartial({
    required String type,
    required String id,
    UpdateMemberPartialRequest? updateMemberPartialRequest,
  }) {
    return _ResultCallAdapter<UpdateMemberPartialResponse>().adapt(
      () => _updateMemberPartial(
        type: type,
        id: id,
        updateMemberPartialRequest: updateMemberPartialRequest,
      ),
    );
  }

  Future<UpdateMessageResponse> _updateMessage({
    required String id,
    required UpdateMessageRequest updateMessageRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateMessageRequest.toJson());
    final _options = _setStreamType<Result<UpdateMessageResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/messages/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateMessageResponse _value;
    try {
      _value = UpdateMessageResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateMessageResponse>> updateMessage({
    required String id,
    required UpdateMessageRequest updateMessageRequest,
  }) {
    return _ResultCallAdapter<UpdateMessageResponse>().adapt(
      () => _updateMessage(id: id, updateMessageRequest: updateMessageRequest),
    );
  }

  Future<UpdateMessagePartialResponse> _updateMessagePartial({
    required String id,
    UpdateMessagePartialRequest? updateMessagePartialRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateMessagePartialRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<UpdateMessagePartialResponse>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/messages/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateMessagePartialResponse _value;
    try {
      _value = UpdateMessagePartialResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateMessagePartialResponse>> updateMessagePartial({
    required String id,
    UpdateMessagePartialRequest? updateMessagePartialRequest,
  }) {
    return _ResultCallAdapter<UpdateMessagePartialResponse>().adapt(
      () => _updateMessagePartial(
        id: id,
        updateMessagePartialRequest: updateMessagePartialRequest,
      ),
    );
  }

  Future<PollResponse> _updatePoll({
    required UpdatePollRequest updatePollRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updatePollRequest.toJson());
    final _options = _setStreamType<Result<PollResponse>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollResponse _value;
    try {
      _value = PollResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollResponse>> updatePoll({
    required UpdatePollRequest updatePollRequest,
  }) {
    return _ResultCallAdapter<PollResponse>().adapt(
      () => _updatePoll(updatePollRequest: updatePollRequest),
    );
  }

  Future<PollOptionResponse> _updatePollOption({
    required String pollId,
    required UpdatePollOptionRequest updatePollOptionRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updatePollOptionRequest.toJson());
    final _options = _setStreamType<Result<PollOptionResponse>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/${pollId}/options',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollOptionResponse _value;
    try {
      _value = PollOptionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollOptionResponse>> updatePollOption({
    required String pollId,
    required UpdatePollOptionRequest updatePollOptionRequest,
  }) {
    return _ResultCallAdapter<PollOptionResponse>().adapt(
      () => _updatePollOption(
        pollId: pollId,
        updatePollOptionRequest: updatePollOptionRequest,
      ),
    );
  }

  Future<PollResponse> _updatePollPartial({
    required String pollId,
    UpdatePollPartialRequest? updatePollPartialRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updatePollPartialRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<PollResponse>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/polls/${pollId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PollResponse _value;
    try {
      _value = PollResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<PollResponse>> updatePollPartial({
    required String pollId,
    UpdatePollPartialRequest? updatePollPartialRequest,
  }) {
    return _ResultCallAdapter<PollResponse>().adapt(
      () => _updatePollPartial(
        pollId: pollId,
        updatePollPartialRequest: updatePollPartialRequest,
      ),
    );
  }

  Future<UpsertPushPreferencesResponse> _updatePushNotificationPreferences({
    required UpsertPushPreferencesRequest upsertPushPreferencesRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(upsertPushPreferencesRequest.toJson());
    final _options = _setStreamType<Result<UpsertPushPreferencesResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/push_preferences',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpsertPushPreferencesResponse _value;
    try {
      _value = UpsertPushPreferencesResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpsertPushPreferencesResponse>>
  updatePushNotificationPreferences({
    required UpsertPushPreferencesRequest upsertPushPreferencesRequest,
  }) {
    return _ResultCallAdapter<UpsertPushPreferencesResponse>().adapt(
      () => _updatePushNotificationPreferences(
        upsertPushPreferencesRequest: upsertPushPreferencesRequest,
      ),
    );
  }

  Future<QueueResponse> _updateQueue({
    required String id,
    UpdateQueueRequest? updateQueueRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateQueueRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<QueueResponse>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/queues/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QueueResponse _value;
    try {
      _value = QueueResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<QueueResponse>> updateQueue({
    required String id,
    UpdateQueueRequest? updateQueueRequest,
  }) {
    return _ResultCallAdapter<QueueResponse>().adapt(
      () => _updateQueue(id: id, updateQueueRequest: updateQueueRequest),
    );
  }

  Future<UpdateReminderResponse> _updateReminder({
    required String messageId,
    UpdateReminderRequest? updateReminderRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateReminderRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<UpdateReminderResponse>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/messages/${messageId}/reminders',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateReminderResponse _value;
    try {
      _value = UpdateReminderResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateReminderResponse>> updateReminder({
    required String messageId,
    UpdateReminderRequest? updateReminderRequest,
  }) {
    return _ResultCallAdapter<UpdateReminderResponse>().adapt(
      () => _updateReminder(
        messageId: messageId,
        updateReminderRequest: updateReminderRequest,
      ),
    );
  }

  Future<UpdateThreadPartialResponse> _updateThreadPartial({
    required String messageId,
    UpdateThreadPartialRequest? updateThreadPartialRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateThreadPartialRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<UpdateThreadPartialResponse>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/threads/${messageId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateThreadPartialResponse _value;
    try {
      _value = UpdateThreadPartialResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateThreadPartialResponse>> updateThreadPartial({
    required String messageId,
    UpdateThreadPartialRequest? updateThreadPartialRequest,
  }) {
    return _ResultCallAdapter<UpdateThreadPartialResponse>().adapt(
      () => _updateThreadPartial(
        messageId: messageId,
        updateThreadPartialRequest: updateThreadPartialRequest,
      ),
    );
  }

  Future<UpdateUserGroupResponse> _updateUserGroup({
    required String id,
    UpdateUserGroupRequest? updateUserGroupRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateUserGroupRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<UpdateUserGroupResponse>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/usergroups/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateUserGroupResponse _value;
    try {
      _value = UpdateUserGroupResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateUserGroupResponse>> updateUserGroup({
    required String id,
    UpdateUserGroupRequest? updateUserGroupRequest,
  }) {
    return _ResultCallAdapter<UpdateUserGroupResponse>().adapt(
      () => _updateUserGroup(
        id: id,
        updateUserGroupRequest: updateUserGroupRequest,
      ),
    );
  }

  Future<UpdateUsersResponse> _updateUsers({
    required UpdateUsersRequest updateUsersRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateUsersRequest.toJson());
    final _options = _setStreamType<Result<UpdateUsersResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/users',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateUsersResponse _value;
    try {
      _value = UpdateUsersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateUsersResponse>> updateUsers({
    required UpdateUsersRequest updateUsersRequest,
  }) {
    return _ResultCallAdapter<UpdateUsersResponse>().adapt(
      () => _updateUsers(updateUsersRequest: updateUsersRequest),
    );
  }

  Future<UpdateUsersResponse> _updateUsersPartial({
    required UpdateUsersPartialRequest updateUsersPartialRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateUsersPartialRequest.toJson());
    final _options = _setStreamType<Result<UpdateUsersResponse>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/users',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateUsersResponse _value;
    try {
      _value = UpdateUsersResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpdateUsersResponse>> updateUsersPartial({
    required UpdateUsersPartialRequest updateUsersPartialRequest,
  }) {
    return _ResultCallAdapter<UpdateUsersResponse>().adapt(
      () => _updateUsersPartial(
        updateUsersPartialRequest: updateUsersPartialRequest,
      ),
    );
  }

  Future<UploadChannelFileResponse> _uploadChannelFile({
    required String type,
    required String id,
    UploadChannelFileRequest? uploadChannelFileRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(uploadChannelFileRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<UploadChannelFileResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/file',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UploadChannelFileResponse _value;
    try {
      _value = UploadChannelFileResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UploadChannelFileResponse>> uploadChannelFile({
    required String type,
    required String id,
    UploadChannelFileRequest? uploadChannelFileRequest,
  }) {
    return _ResultCallAdapter<UploadChannelFileResponse>().adapt(
      () => _uploadChannelFile(
        type: type,
        id: id,
        uploadChannelFileRequest: uploadChannelFileRequest,
      ),
    );
  }

  Future<UploadChannelResponse> _uploadChannelImage({
    required String type,
    required String id,
    UploadChannelRequest? uploadChannelRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(uploadChannelRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<UploadChannelResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/image',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UploadChannelResponse _value;
    try {
      _value = UploadChannelResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UploadChannelResponse>> uploadChannelImage({
    required String type,
    required String id,
    UploadChannelRequest? uploadChannelRequest,
  }) {
    return _ResultCallAdapter<UploadChannelResponse>().adapt(
      () => _uploadChannelImage(
        type: type,
        id: id,
        uploadChannelRequest: uploadChannelRequest,
      ),
    );
  }

  Future<FileUploadResponse> _uploadFile({
    FileUploadRequest? fileUploadRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(fileUploadRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<FileUploadResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/uploads/file',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late FileUploadResponse _value;
    try {
      _value = FileUploadResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<FileUploadResponse>> uploadFile({
    FileUploadRequest? fileUploadRequest,
  }) {
    return _ResultCallAdapter<FileUploadResponse>().adapt(
      () => _uploadFile(fileUploadRequest: fileUploadRequest),
    );
  }

  Future<ImageUploadResponse> _uploadImage({
    ImageUploadRequest? imageUploadRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(imageUploadRequest?.toJson() ?? <String, dynamic>{});
    final _options = _setStreamType<Result<ImageUploadResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/uploads/image',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ImageUploadResponse _value;
    try {
      _value = ImageUploadResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ImageUploadResponse>> uploadImage({
    ImageUploadRequest? imageUploadRequest,
  }) {
    return _ResultCallAdapter<ImageUploadResponse>().adapt(
      () => _uploadImage(imageUploadRequest: imageUploadRequest),
    );
  }

  Future<UpsertActionConfigResponse> _upsertActionConfig({
    required UpsertActionConfigRequest upsertActionConfigRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(upsertActionConfigRequest.toJson());
    final _options = _setStreamType<Result<UpsertActionConfigResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/action_config',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpsertActionConfigResponse _value;
    try {
      _value = UpsertActionConfigResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpsertActionConfigResponse>> upsertActionConfig({
    required UpsertActionConfigRequest upsertActionConfigRequest,
  }) {
    return _ResultCallAdapter<UpsertActionConfigResponse>().adapt(
      () => _upsertActionConfig(
        upsertActionConfigRequest: upsertActionConfigRequest,
      ),
    );
  }

  Future<UpsertConfigResponse> _upsertConfig({
    required UpsertConfigRequest upsertConfigRequest,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(upsertConfigRequest.toJson());
    final _options = _setStreamType<Result<UpsertConfigResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/moderation/config',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpsertConfigResponse _value;
    try {
      _value = UpsertConfigResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UpsertConfigResponse>> upsertConfig({
    required UpsertConfigRequest upsertConfigRequest,
  }) {
    return _ResultCallAdapter<UpsertConfigResponse>().adapt(
      () => _upsertConfig(upsertConfigRequest: upsertConfigRequest),
    );
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
