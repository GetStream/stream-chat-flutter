// ignore_for_file: lines_longer_than_80_chars

import 'dart:math' as math;

import 'package:dio/dio.dart';

///
enum InterceptStep {
  ///
  request,

  ///
  response,

  ///
  error,
}

///
typedef LogPrint = void Function(InterceptStep step, Object object);

void _defaultLogPrint(InterceptStep step, Object object) => print(object);

///
class LoggingInterceptor extends Interceptor {
  ///
  LoggingInterceptor({
    this.request = true,
    this.requestHeader = false,
    this.requestBody = true,
    this.responseHeader = false,
    this.responseBody = true,
    this.error = true,
    this.maxWidth = 120,
    this.compact = true,
    this.logPrint = _defaultLogPrint,
  });

  /// Print request [Options]
  final bool request;

  /// Print request header [Options.headers]
  final bool requestHeader;

  /// Print request data [Options.data]
  final bool requestBody;

  /// Print [Response.data]
  final bool responseBody;

  /// Print [Response.headers]
  final bool responseHeader;

  /// Print error message
  final bool error;

  /// InitialTab count to logPrint json response
  static const int initialTab = 1;

  /// 1 tab length
  static const String tabStep = '    ';

  /// Print compact json response
  final bool compact;

  /// Width size per logPrint
  final int maxWidth;

  /// Log printer; defaults logPrint log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file.
  void Function(InterceptStep step, Object object) logPrint;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (request) {
      _printRequestHeader(_logPrintRequest, options);
    }
    if (requestHeader) {
      _printMapAsTable(
        _logPrintRequest,
        options.queryParameters,
        header: 'Query Parameters',
      );
      final requestHeaders = <String, Object?>{...options.headers};
      requestHeaders['contentType'] = options.contentType?.toString();
      requestHeaders['responseType'] = options.responseType.toString();
      requestHeaders['followRedirects'] = options.followRedirects;
      requestHeaders['connectTimeout'] = options.connectTimeout;
      requestHeaders['receiveTimeout'] = options.receiveTimeout;
      _printMapAsTable(_logPrintRequest, requestHeaders, header: 'Headers');
      _printMapAsTable(_logPrintRequest, options.extra, header: 'Extras');
    }
    if (requestBody && options.method != 'GET') {
      final dynamic data = options.data;
      if (data != null) {
        if (data is Map) {
          _printMapAsTable(
            _logPrintRequest,
            options.data as Map?,
            header: 'Body',
          );
        } else if (data is FormData) {
          final formDataMap = <String, dynamic>{}
            ..addEntries(data.fields)
            ..addEntries(data.files);
          _printMapAsTable(_logPrintRequest, formDataMap,
              header: 'Form data | ${data.boundary}');
        } else {
          _printBlock(_logPrintRequest, data.toString());
        }
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (error) {
      if (err.type == DioErrorType.response) {
        final uri = err.response?.requestOptions.uri;
        _printBoxed(
          _logPrintError,
          header:
              'DioError ║ Status: ${err.response?.statusCode} ${err.response?.statusMessage}',
          text: uri.toString(),
        );
        if (err.response != null && err.response?.data != null) {
          _logPrintError('╔ ${err.type.toString()}');
          _printResponse(_logPrintError, err.response!);
        }
        _printLine(_logPrintError, '╚');
        _logPrintError('');
      } else {
        _printBoxed(
          _logPrintError,
          header: 'DioError ║ ${err.type}',
          text: err.message,
        );
        _printRequestHeader(_logPrintError, err.requestOptions);
      }
    }
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _printResponseHeader(_logPrintResponse, response);
    if (responseHeader) {
      final responseHeaders = <String, String>{};
      response.headers
          .forEach((k, list) => responseHeaders[k] = list.toString());
      _printMapAsTable(_logPrintResponse, responseHeaders, header: 'Headers');
    }

    if (responseBody) {
      _logPrintResponse('╔ Body');
      _logPrintResponse('║');
      _printResponse(_logPrintResponse, response);
      _logPrintResponse('║');
      _printLine(_logPrintResponse, '╚');
    }
    super.onResponse(response, handler);
  }

  void _printBoxed(
    void Function(Object) logPrint, {
    String? header,
    String? text,
  }) {
    logPrint('');
    logPrint('╔╣ $header');
    logPrint('║  $text');
    _printLine(logPrint, '╚');
  }

  void _printResponse(void Function(Object) logPrint, Response response) {
    if (response.data != null) {
      if (response.data is Map) {
        _printPrettyMap(logPrint, response.data as Map);
      } else if (response.data is List) {
        logPrint('║${_indent()}[');
        _printList(logPrint, response.data as List);
        logPrint('║${_indent()}[');
      } else {
        _printBlock(logPrint, response.data.toString());
      }
    }
  }

  void _printResponseHeader(void Function(Object) logPrint, Response response) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method;
    _printBoxed(
      logPrint,
      header:
          'Response ║ $method ║ Status: ${response.statusCode} ${response.statusMessage}',
      text: uri.toString(),
    );
  }

  void _printRequestHeader(
      void Function(Object) logPrint, RequestOptions options) {
    final uri = options.uri;
    final method = options.method;
    _printBoxed(logPrint, header: 'Request ║ $method ', text: uri.toString());
  }

  void _printLine(void Function(Object) logPrint,
          [String pre = '', String suf = '╝']) =>
      logPrint('$pre${'═' * maxWidth}$suf');

  void _printKV(void Function(Object) logPrint, String? key, Object? v) {
    final pre = '╟ $key: ';
    final msg = v.toString();

    if (pre.length + msg.length > maxWidth) {
      logPrint(pre);
      _printBlock(logPrint, msg);
    } else {
      logPrint('$pre$msg');
    }
  }

  void _printBlock(void Function(Object) logPrint, String msg) {
    final lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      logPrint((i >= 0 ? '║ ' : '') +
          msg.substring(i * maxWidth,
              math.min<int>(i * maxWidth + maxWidth, msg.length)));
    }
  }

  String _indent([int tabCount = initialTab]) => tabStep * tabCount;

  void _printPrettyMap(
    void Function(Object) logPrint,
    Map data, {
    int tabs = initialTab,
    bool isListItem = false,
    bool isLast = false,
  }) {
    var _tabs = tabs;
    final isRoot = _tabs == initialTab;
    final initialIndent = _indent(_tabs);
    _tabs++;

    if (isRoot || isListItem) logPrint('║$initialIndent{');

    data.keys.toList().asMap().forEach((index, dynamic key) {
      final isLast = index == data.length - 1;
      dynamic value = data[key];
      if (value is String) {
        value = '"${value.toString().replaceAll(RegExp(r'(\r|\n)+'), " ")}"';
      }
      if (value is Map) {
        if (compact) {
          logPrint('║${_indent(_tabs)} $key: $value${!isLast ? ',' : ''}');
        } else {
          logPrint('║${_indent(_tabs)} $key: {');
          _printPrettyMap(logPrint, value, tabs: _tabs);
        }
      } else if (value is List) {
        if (compact) {
          logPrint('║${_indent(_tabs)} $key: ${value.toString()}');
        } else {
          logPrint('║${_indent(_tabs)} $key: [');
          _printList(logPrint, value, tabs: _tabs);
          logPrint('║${_indent(_tabs)} ]${isLast ? '' : ','}');
        }
      } else {
        final msg = value.toString().replaceAll('\n', '');
        final indent = _indent(_tabs);
        final linWidth = maxWidth - indent.length;
        if (msg.length + indent.length > linWidth) {
          final lines = (msg.length / linWidth).ceil();
          for (var i = 0; i < lines; ++i) {
            logPrint('║${_indent(_tabs)} ${msg.substring(
              i * linWidth,
              math.min<int>(i * linWidth + linWidth, msg.length),
            )}');
          }
        } else {
          logPrint('║${_indent(_tabs)} $key: $msg${!isLast ? ',' : ''}');
        }
      }
    });

    logPrint('║$initialIndent}${isListItem && !isLast ? ',' : ''}');
  }

  void _printList(
    void Function(Object) logPrint,
    List list, {
    int tabs = initialTab,
  }) {
    list.asMap().forEach((i, dynamic e) {
      final isLast = i == list.length - 1;
      if (e is Map) {
        if (compact) {
          logPrint('║${_indent(tabs)}  $e${!isLast ? ',' : ''}');
        } else {
          _printPrettyMap(logPrint, e,
              tabs: tabs + 1, isListItem: true, isLast: isLast);
        }
      } else {
        logPrint('║${_indent(tabs + 2)} $e${isLast ? '' : ','}');
      }
    });
  }

/*  bool _canFlattenMap(Map map) =>
      map.values.where((dynamic val) => val is Map || val is List).isEmpty &&
      map.toString().length < maxWidth;

  bool _canFlattenList(List list) =>
      list.length < 10 && list.toString().length < maxWidth;*/

  void _printMapAsTable(
    void Function(Object) logPrint,
    Map? map, {
    String? header,
  }) {
    if (map == null || map.isEmpty) return;
    logPrint('╔ $header ');
    map.forEach((dynamic key, dynamic value) =>
        _printKV(logPrint, key.toString(), value));
    _printLine(logPrint, '╚');
  }

  void _logPrintRequest(Object object) =>
      logPrint(InterceptStep.request, object);

  void _logPrintResponse(Object object) =>
      logPrint(InterceptStep.response, object);

  void _logPrintError(Object object) => logPrint(InterceptStep.error, object);
}
