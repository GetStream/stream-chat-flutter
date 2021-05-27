import 'package:logging/logging.dart';
import 'package:stream_chat/src/core/api/channel_api.dart';
import 'package:stream_chat/src/core/api/device_api.dart';
import 'package:stream_chat/src/core/api/general_api.dart';
import 'package:stream_chat/src/core/api/guest_api.dart';
import 'package:stream_chat/src/core/api/message_api.dart';
import 'package:stream_chat/src/core/api/moderation_api.dart';
import 'package:stream_chat/src/core/http/connection_id_manager.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/api/user_api.dart';
import 'package:stream_chat/src/core/http/token_manager.dart';
import 'package:stream_chat/src/core/api/attachment_file_uploader.dart';

export 'device_api.dart' show PushProvider;

///
class StreamChatApi {
  ///
  StreamChatApi(
    String apiKey, {
    StreamHttpClient? client,
    StreamHttpClientOptions? options,
    TokenManager? tokenManager,
    ConnectionIdManager? connectionIdManager,
    AttachmentFileUploader? attachmentFileUploader,
    Logger? logger,
  })  : _fileUploader = attachmentFileUploader,
        _client = client ??
            StreamHttpClient(
              apiKey,
              options: options,
              tokenManager: tokenManager,
              connectionIdManager: connectionIdManager,
              logger: logger,
            );

  final StreamHttpClient _client;

  UserApi? _user;

  ///
  UserApi get user => _user ??= UserApi(_client);

  GuestApi? _guest;

  ///
  GuestApi get guest => _guest ??= GuestApi(_client);

  MessageApi? _message;

  ///
  MessageApi get message => _message ??= MessageApi(_client);

  ChannelApi? _channel;

  ///
  ChannelApi get channel => _channel ??= ChannelApi(_client);

  DeviceApi? _device;

  ///
  DeviceApi get device => _device ??= DeviceApi(_client);

  ModerationApi? _moderation;

  ///
  ModerationApi get moderation => _moderation ??= ModerationApi(_client);

  GeneralApi? _general;

  ///
  GeneralApi get general => _general ??= GeneralApi(_client);

  AttachmentFileUploader? _fileUploader;

  ///
  AttachmentFileUploader get fileUploader =>
      _fileUploader ??= StreamAttachmentFileUploader(_client);
}
