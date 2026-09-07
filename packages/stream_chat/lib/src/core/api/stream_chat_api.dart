import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../http/connection_id_manager.dart';
import '../http/stream_http_client.dart';
import '../http/system_environment_manager.dart';
import '../http/token_manager.dart';
import 'attachment_file_uploader.dart';
import 'channel_api.dart';
import 'device_api.dart';
import 'general_api.dart';
import 'guest_api.dart';
import 'message_api.dart';
import 'moderation_api.dart';
import 'polls_api.dart';
import 'reminders_api.dart';
import 'roles_api.dart';
import 'threads_api.dart';
import 'user_api.dart';
import 'user_groups_api.dart';

export 'device_api.dart' show PushProvider;

/// ApiClient that wraps every other specific api
class StreamChatApi {
  /// Initialize a new stream chat api
  StreamChatApi(
    String apiKey, {
    StreamHttpClient? client,
    StreamHttpClientOptions? options,
    TokenManager? tokenManager,
    ConnectionIdManager? connectionIdManager,
    SystemEnvironmentManager? systemEnvironmentManager,
    AttachmentFileUploaderProvider attachmentFileUploaderProvider = StreamAttachmentFileUploader.new,
    Logger? logger,
    Iterable<Interceptor>? interceptors,
    HttpClientAdapter? httpClientAdapter,
  }) : _fileUploaderProvider = attachmentFileUploaderProvider,
       _client =
           client ??
           StreamHttpClient(
             apiKey,
             options: options,
             tokenManager: tokenManager,
             connectionIdManager: connectionIdManager,
             systemEnvironmentManager: systemEnvironmentManager,
             logger: logger,
             interceptors: interceptors,
             httpClientAdapter: httpClientAdapter,
           );

  final StreamHttpClient _client;
  final AttachmentFileUploaderProvider _fileUploaderProvider;

  /// Api dedicated to users operations
  UserApi get user => _user ??= UserApi(_client);
  UserApi? _user;

  /// Api dedicated to guest operations
  GuestApi get guest => _guest ??= GuestApi(_client);
  GuestApi? _guest;

  /// Api dedicated to message operations
  MessageApi get message => _message ??= MessageApi(_client);
  MessageApi? _message;

  /// Api dedicated to polls operations
  PollsApi get polls => _polls ??= PollsApi(_client);
  PollsApi? _polls;

  /// Api dedicated to threads operations
  ThreadsApi get threads => _threads ??= ThreadsApi(_client);
  ThreadsApi? _threads;

  /// Api dedicated to channel operations
  ChannelApi get channel => _channel ??= ChannelApi(_client);
  ChannelApi? _channel;

  /// Api dedicated to device operations
  DeviceApi get device => _device ??= DeviceApi(_client);
  DeviceApi? _device;

  /// Api dedicated to moderation operations
  ModerationApi get moderation => _moderation ??= ModerationApi(_client);
  ModerationApi? _moderation;

  /// Api dedicated to message reminders operations
  RemindersApi get reminders => _reminders ??= RemindersApi(_client);
  RemindersApi? _reminders;

  /// Api dedicated to user groups operations
  UserGroupsApi get userGroups => _userGroups ??= UserGroupsApi(_client);
  UserGroupsApi? _userGroups;

  /// Api dedicated to roles operations
  RolesApi get roles => _roles ??= RolesApi(_client);
  RolesApi? _roles;

  /// Api dedicated to general operations
  GeneralApi get general => _general ??= GeneralApi(_client);
  GeneralApi? _general;

  /// Class responsible for uploading images and files to a given channel
  AttachmentFileUploader get fileUploader => _fileUploader ??= _fileUploaderProvider.call(_client);
  AttachmentFileUploader? _fileUploader;
}
