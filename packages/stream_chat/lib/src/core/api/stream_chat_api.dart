import 'package:dio/dio.dart';
import 'package:stream_core/stream_core.dart' show ConnectionIdGetter, SystemEnvironmentManager, TokenManager;

import '../http/stream_http_client.dart';
import 'attachment_file_uploader.dart';
import 'channel_api.dart';
import 'general_api.dart';
import 'guest_api.dart';
import 'message_api.dart';
import 'moderation_api.dart';
import 'polls_api.dart';
import 'push_preferences_api.dart';
import 'reminders_api.dart';
import 'threads_api.dart';
import 'user_api.dart';

/// ApiClient that wraps every other specific api
class StreamChatApi {
  /// Initialize a new stream chat api
  StreamChatApi(
    String apiKey, {
    StreamHttpClient? client,
    StreamHttpClientOptions? options,
    TokenManager? tokenManager,
    ConnectionIdGetter? connectionId,
    SystemEnvironmentManager? systemEnvironmentManager,
    AttachmentFileUploaderProvider attachmentFileUploaderProvider = StreamAttachmentFileUploader.new,
    Iterable<Interceptor>? interceptors,
    HttpClientAdapter? httpClientAdapter,
  }) : _fileUploaderProvider = attachmentFileUploaderProvider,
       _client =
           client ??
           StreamHttpClient(
             apiKey,
             options: options,
             tokenManager: tokenManager,
             connectionId: connectionId,
             systemEnvironmentManager: systemEnvironmentManager,
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

  /// Api dedicated to push preference operations
  PushPreferencesApi get pushPreferences => _pushPreferences ??= PushPreferencesApi(_client);
  PushPreferencesApi? _pushPreferences;

  /// Api dedicated to moderation operations
  ModerationApi get moderation => _moderation ??= ModerationApi(_client);
  ModerationApi? _moderation;

  /// Api dedicated to message reminders operations
  RemindersApi get reminders => _reminders ??= RemindersApi(_client);
  RemindersApi? _reminders;

  /// Api dedicated to general operations
  GeneralApi get general => _general ??= GeneralApi(_client);
  GeneralApi? _general;

  /// Class responsible for uploading images and files to a given channel
  AttachmentFileUploader get fileUploader => _fileUploader ??= _fileUploaderProvider.call(_client);
  AttachmentFileUploader? _fileUploader;
}
