///
class SocketError {
  ///
  const SocketError({
    this.code = -1,
    this.statusCode = -1,
    this.message = '',
  });

  ///
  factory SocketError.fromJson(Map<String, dynamic> json) => SocketError(
        code: json['code'],
        statusCode: json['StatusCode'],
        message: json['message'],
      );

  ///
  final int code;

  ///
  final int statusCode;

  ///
  final String message;
}
