///
enum ChatErrorCode {
  // client error codes
  networkFailed,
  parserError,
  socketClosed,
  socketFailure,
  cantParseConnectionEvent,
  cantParseEvent,
  invalidToken,
  undefinedToken,
  unableToParseSocketEvent,
  noErrorBody,

  // server error codes
  authenticationError,
  tokenExpired,
  tokenNotValid,
  tokenDateIncorrect,
  tokenSignatureIncorrect,
  apiKeyNotFound,
}

///
extension ChatErrorCodeX on ChatErrorCode {
  ///
  String get message => {
        // client error message
        ChatErrorCode.networkFailed: 'Response is failed. See cause',
        ChatErrorCode.parserError: 'Unable to parse error',
        ChatErrorCode.socketClosed: 'Server closed connection',
        ChatErrorCode.socketFailure: 'See stack trace in logs. '
            'Intercept error in error handler of setUser',
        ChatErrorCode.cantParseConnectionEvent:
            'Unable to parse connection event',
        ChatErrorCode.cantParseEvent: 'Unable to parse event',
        ChatErrorCode.invalidToken: 'Invalid token',
        ChatErrorCode.undefinedToken:
            'No defined token. Check if client.setUser was called and finished',
        ChatErrorCode.unableToParseSocketEvent:
            'Socket event payload either invalid or null',
        ChatErrorCode.noErrorBody: 'No error body. See http status code',

        // server error message
        ChatErrorCode.authenticationError:
            'Unauthenticated, problem with authentication',
        ChatErrorCode.tokenExpired: 'Token expired, new one must be requested.',
        ChatErrorCode.tokenNotValid: 'Unauthenticated, token not valid yet',
        ChatErrorCode.tokenDateIncorrect:
            'Unauthenticated, token date incorrect',
        ChatErrorCode.tokenSignatureIncorrect:
            'Unauthenticated, token signature invalid',
        ChatErrorCode.apiKeyNotFound:
            "Api key is not found, verify it if it's correct or was created.",
      }[this]!;

  ///
  int get code => {
        // client error codes
        ChatErrorCode.networkFailed: 1000,
        ChatErrorCode.parserError: 1001,
        ChatErrorCode.socketClosed: 1002,
        ChatErrorCode.socketFailure: 1003,
        ChatErrorCode.cantParseConnectionEvent: 1004,
        ChatErrorCode.cantParseEvent: 1005,
        ChatErrorCode.invalidToken: 1006,
        ChatErrorCode.undefinedToken: 1007,
        ChatErrorCode.unableToParseSocketEvent: 1008,
        ChatErrorCode.noErrorBody: 1009,

        // server error codes
        ChatErrorCode.authenticationError: 5,
        ChatErrorCode.tokenExpired: 40,
        ChatErrorCode.tokenNotValid: 41,
        ChatErrorCode.tokenDateIncorrect: 42,
        ChatErrorCode.tokenSignatureIncorrect: 43,
        ChatErrorCode.apiKeyNotFound: 2,
      }[this]!;

  ///
  Set<int> get authenticationErrors => {
        ChatErrorCode.authenticationError,
        ChatErrorCode.tokenExpired,
        ChatErrorCode.tokenNotValid,
        ChatErrorCode.tokenDateIncorrect,
        ChatErrorCode.tokenSignatureIncorrect,
      }.map((it) => it.code).toSet();

  ///
  bool isAuthenticationError(int code) => authenticationErrors.contains(code);
}
