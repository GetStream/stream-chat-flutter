import 'package:logging/logging.dart';
import 'package:stream_chat/src/core/api/attachment_file_uploader.dart';
import 'package:stream_chat/src/core/api/call_api.dart';
import 'package:stream_chat/src/core/api/channel_api.dart';
import 'package:stream_chat/src/core/api/device_api.dart';
import 'package:stream_chat/src/core/api/general_api.dart';
import 'package:stream_chat/src/core/api/guest_api.dart';
import 'package:stream_chat/src/core/api/message_api.dart';
import 'package:stream_chat/src/core/api/moderation_api.dart';
import 'package:stream_chat/src/core/api/user_api.dart';
import 'package:stream_chat/src/core/http/connection_id_manager.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/http/token_manager.dart';

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
    AttachmentFileUploaderProvider attachmentFileUploaderProvider =
        StreamAttachmentFileUploader.new,
    Logger? logger,
  })  : _fileUploaderProvider = attachmentFileUploaderProvider,
        _client = client ??
            StreamHttpClient(
              apiKey,
              options: options,
              tokenManager: tokenManager,
              connectionIdManager: connectionIdManager,
              logger: logger,
            );

  final StreamHttpClient _client;
  final AttachmentFileUploaderProvider _fileUploaderProvider;

  UserApi? _user;

  /// Api dedicated to users operations
  UserApi get user => _user ??= UserApi(_client);

  GuestApi? _guest;

  /// Api dedicated to guest operations
  GuestApi get guest => _guest ??= GuestApi(_client);

  MessageApi? _message;

  /// Api dedicated to message operations
  MessageApi get message => _message ??= MessageApi(_client);

  CallApi? _call;

  /// Api dedicated to call operations
  CallApi get call => _call ??= CallApi(_client);

  ChannelApi? _channel;

  /// Api dedicated to channel operations
  ChannelApi get channel => _channel ??= ChannelApi(_client);

  DeviceApi? _device;

  /// Api dedicated to device operations
  DeviceApi get device => _device ??= DeviceApi(_client);

  ModerationApi? _moderation;

  /// Api dedicated to moderation operations
  ModerationApi get moderation => _moderation ??= ModerationApi(_client);

  GeneralApi? _general;

  /// Api dedicated to general operations
  GeneralApi get general => _general ??= GeneralApi(_client);

  AttachmentFileUploader? _fileUploader;

  /// Class responsible for uploading images and files to a given channel
  AttachmentFileUploader get fileUploader =>
      _fileUploader ??= _fileUploaderProvider.call(_client);
}
