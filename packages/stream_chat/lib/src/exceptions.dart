import 'dart:convert';

/// Exception related to api calls
class ApiError extends Error {
  /// Raw body of the response
  final String body;

  /// Json parsed body
  final Map<String, dynamic> jsonData;

  /// Http status code of the response
  final int status;

  /// Stream specific error code
  int get code => _code;
  int _code;

  static Map<String, dynamic> _decode(String body) {
    try {
      if (body == null) {
        return null;
      }
      return json.decode(body);
    } on FormatException {
      return null;
    }
  }

  /// Creates a new ApiError instance using the response body and status code
  ApiError(this.body, this.status) : jsonData = _decode(body) {
    if (jsonData != null && jsonData.containsKey('code')) {
      _code = jsonData['code'];
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiError &&
          runtimeType == other.runtimeType &&
          body == other.body &&
          jsonData == other.jsonData &&
          status == other.status &&
          _code == other._code;

  @override
  int get hashCode =>
      body.hashCode ^ jsonData.hashCode ^ status.hashCode ^ _code.hashCode;

  @override
  String toString() {
    return 'ApiError{body: $body, jsonData: $jsonData, status: $status, code: $_code}';
  }
}
