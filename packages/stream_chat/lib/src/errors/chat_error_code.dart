// ignore_for_file: lines_longer_than_80_chars

import 'package:collection/collection.dart';

/// Complete list of errors that are returned by the API
/// together with the description and API code.
enum ChatErrorCode {
  // Client errors

  /// Unauthenticated, token not defined
  undefinedToken,

  // Bad Request

  /// Wrong data/parameter is sent to the API
  inputError,

  /// Duplicate username is sent while enforce_unique_usernames is enabled
  duplicateUsername,

  /// Message is too long
  messageTooLong,

  /// Event is not supported
  eventNotSupported,

  /// The feature is currently disabled
  /// on the dashboard (i.e. Reactions & Replies)
  channelFeatureNotSupported,

  /// Multiple Levels Reply is not supported
  /// the API only supports 1 level deep reply threads
  multipleNestling,

  /// Custom Command handler returned an error
  customCommandEndpointCall,

  /// App config does not have custom_action_handler_url
  customCommandEndpointMissing,

  // Unauthorised

  /// Unauthenticated, problem with authentication
  authenticationError,

  /// Unauthenticated, token expired
  tokenExpired,

  /// Unauthenticated, token date incorrect
  tokenBeforeIssuedAt,

  /// Unauthenticated, token not valid yet
  tokenNotValid,

  /// Unauthenticated, token signature invalid
  tokenSignatureInvalid,

  /// Access Key invalid
  accessKeyError,

  // Forbidden

  /// Unauthorised / forbidden to make request
  notAllowed,

  /// App suspended
  appSuspended,

  /// User tried to post a message during the cooldown period
  cooldownError,

  // Miscellaneous

  /// Resource not found
  doesNotExist,

  /// Request timed out
  requestTimeout,

  /// Payload too big
  payloadTooBig,

  /// Too many requests in a certain time frame
  rateLimitError,

  /// Request headers are too large
  maximumHeaderSizeExceeded,

  /// Something goes wrong in the system
  internalSystemError,

  /// No access to requested channels
  noAccessToChannels
}

const _errorCodeWithDescription = {
  ChatErrorCode.undefinedToken:
      MapEntry(1000, 'Unauthorised, token not defined'),
  ChatErrorCode.inputError:
      MapEntry(4, 'Wrong data/parameter is sent to the API'),
  ChatErrorCode.duplicateUsername: MapEntry(6,
      'Duplicate username is sent while enforce_unique_usernames is enabled'),
  ChatErrorCode.messageTooLong: MapEntry(20, 'Message is too long'),
  ChatErrorCode.eventNotSupported: MapEntry(18, 'Event is not supported'),
  ChatErrorCode.channelFeatureNotSupported: MapEntry(19,
      'The feature is currently disabled on the dashboard (i.e. Reactions & Replies)'),
  ChatErrorCode.multipleNestling: MapEntry(21,
      'Multiple Levels Reply is not supported - the API only supports 1 level deep reply threads'),
  ChatErrorCode.customCommandEndpointCall:
      MapEntry(45, 'Custom Command handler returned an error'),
  ChatErrorCode.customCommandEndpointMissing:
      MapEntry(44, 'App config does not have custom_action_handler_url'),
  ChatErrorCode.authenticationError:
      MapEntry(5, 'Unauthenticated, problem with authentication'),
  ChatErrorCode.tokenExpired: MapEntry(40, 'Unauthenticated, token expired'),
  ChatErrorCode.tokenBeforeIssuedAt:
      MapEntry(42, 'Unauthenticated, token date incorrect'),
  ChatErrorCode.tokenNotValid:
      MapEntry(41, 'Unauthenticated, token not valid yet'),
  ChatErrorCode.tokenSignatureInvalid:
      MapEntry(43, 'Unauthenticated, token signature invalid'),
  ChatErrorCode.accessKeyError: MapEntry(2, 'Access Key invalid'),
  ChatErrorCode.notAllowed:
      MapEntry(17, 'Unauthorised / forbidden to make request'),
  ChatErrorCode.appSuspended: MapEntry(99, 'App suspended'),
  ChatErrorCode.cooldownError:
      MapEntry(60, 'User tried to post a message during the cooldown period'),
  ChatErrorCode.doesNotExist: MapEntry(16, 'Resource not found'),
  ChatErrorCode.requestTimeout: MapEntry(23, 'Request timed out'),
  ChatErrorCode.payloadTooBig: MapEntry(22, 'Payload too big'),
  ChatErrorCode.rateLimitError:
      MapEntry(9, 'Too many requests in a certain time frame'),
  ChatErrorCode.maximumHeaderSizeExceeded:
      MapEntry(24, 'Request headers are too large'),
  ChatErrorCode.internalSystemError:
      MapEntry(-1, 'Something goes wrong in the system'),
  ChatErrorCode.noAccessToChannels:
      MapEntry(70, 'No access to requested channels'),
};

const _authenticationErrors = [
  ChatErrorCode.undefinedToken,
  ChatErrorCode.authenticationError,
  ChatErrorCode.tokenExpired,
  ChatErrorCode.tokenBeforeIssuedAt,
  ChatErrorCode.tokenNotValid,
  ChatErrorCode.tokenSignatureInvalid,
  ChatErrorCode.accessKeyError,
  ChatErrorCode.noAccessToChannels,
];

///
ChatErrorCode? chatErrorCodeFromCode(int code) => _errorCodeWithDescription.keys
    .firstWhereOrNull((key) => _errorCodeWithDescription[key]!.key == code);

///
extension ChatErrorCodeX on ChatErrorCode {
  ///
  String get message => _errorCodeWithDescription[this]!.value;

  ///
  int get code => _errorCodeWithDescription[this]!.key;

  ///
  bool get isAuthenticationError => _authenticationErrors.contains(this);
}
