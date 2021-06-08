import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/channel_api.dart';
import 'package:stream_chat/src/core/api/device_api.dart';
import 'package:stream_chat/src/core/api/general_api.dart';
import 'package:stream_chat/src/core/api/message_api.dart';
import 'package:stream_chat/src/core/api/moderation_api.dart';
import 'package:stream_chat/src/core/api/stream_chat_api.dart';
import 'package:stream_chat/src/core/api/user_api.dart';
import 'package:stream_chat/src/core/api/guest_api.dart';
import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/src/core/http/token_manager.dart';
import 'package:stream_chat/stream_chat.dart';

import 'mocks.dart';

class FakeTokenManager extends Fake implements TokenManager {
  final token = Token.development('test-user-id');

  @override
  bool get isStatic => true;

  @override
  String? get userId => token.userId;

  @override
  Future<Token> loadToken({bool refresh = false}) async => token;

  @override
  Future<Token> setTokenOrProvider(
    String userId, {
    Token? token,
    TokenProvider? provider,
  }) async =>
      this.token;

  @override
  void reset() {}
}

class FakeMultiPartFile extends Fake implements MultipartFile {}

class FakeChatApi extends Fake implements StreamChatApi {
  UserApi? _user;

  @override
  UserApi get user => _user ??= MockUserApi();

  GuestApi? _guest;

  @override
  GuestApi get guest => _guest ??= MockGuestApi();

  MessageApi? _message;

  @override
  MessageApi get message => _message ??= MockMessageApi();

  ChannelApi? _channel;

  @override
  ChannelApi get channel => _channel ??= MockChannelApi();

  DeviceApi? _device;

  @override
  DeviceApi get device => _device ??= MockDeviceApi();

  ModerationApi? _moderation;

  @override
  ModerationApi get moderation => _moderation ??= MockModerationApi();

  GeneralApi? _general;

  @override
  GeneralApi get general => _general ??= MockGeneralApi();

  AttachmentFileUploader? _fileUploader;

  @override
  AttachmentFileUploader get fileUploader =>
      _fileUploader ??= MockAttachmentFileUploader();
}
